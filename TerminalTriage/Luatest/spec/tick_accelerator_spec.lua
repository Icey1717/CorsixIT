--[[ Terminal Triage tick-accelerator tests
  Tests for App:runSimulatedTicks(n) and World:advanceToDate(y,m,d).

  Run from TerminalTriage/Luatest/:
    lua %APPDATA%\luarocks\bin\busted

  All tests are pure Lua — no SDL, no TH C bindings required.
  A lightweight mock world is used to verify tick-counting contracts.
--]]

-- ---------------------------------------------------------------------------
-- Mock helpers
-- ---------------------------------------------------------------------------

-- Builds a minimal mock World that mimics the real World:onTick() tick-timer
-- protocol and tracks how many game ticks have fired.
local function make_mock_world(opts)
  opts = opts or {}
  local w = {
    tick_timer   = opts.tick_timer   or 0,
    tick_rate    = opts.tick_rate    or 3,
    hours_per_tick = opts.hours_per_tick or 1,
    game_ticks   = 0,   -- counts actual game-logic ticks (not SDL ticks)
    tick_calls   = 0,   -- counts every onTick() invocation
    -- Simple date as {year, month, day, hour} table
    year = opts.year or 1, month = opts.month or 1,
    day  = opts.day  or 1, hour  = opts.hour  or 0,
  }
  function w:onTick()
    self.tick_calls = self.tick_calls + 1
    if self.tick_timer == 0 then
      self.game_ticks = self.game_ticks + 1
      self.tick_timer = self.tick_rate
      -- Advance date by hours_per_tick hours (simplified, no month overflow)
      self.hour = self.hour + self.hours_per_tick
      while self.hour >= 50 do
        self.hour = self.hour - 50
        self.day  = self.day + 1
      end
      while self.day > 28 do   -- uniform 28-day months for simplicity
        self.day   = self.day - 28
        self.month = self.month + 1
      end
      while self.month > 12 do
        self.month = self.month - 12
        self.year  = self.year + 1
      end
    end
    self.tick_timer = self.tick_timer - 1
  end
  -- Simulates the real Date __lt metamethod semantics
  function w:beforeDate(ty, tm, td)
    if self.year  ~= ty then return self.year  < ty end
    if self.month ~= tm then return self.month < tm end
    return self.day < td
  end
  return w
end

-- Replicates the core of App:runSimulatedTicks without touching global state.
local function run_simulated_ticks(world, n)
  if not world then return end
  for _ = 1, n do
    world.tick_timer = 0   -- force game tick on next onTick call
    world:onTick()
  end
end

-- Replicates the core of World:advanceToDate.
local function advance_to_date(world, ty, tm, td, max_ticks)
  max_ticks = max_ticks or 200000
  local ticks = 0
  while world:beforeDate(ty, tm, td) and ticks < max_ticks do
    world.tick_timer = 0
    world:onTick()
    ticks = ticks + 1
  end
  if ticks >= max_ticks then
    error(string.format("advance_to_date: did not reach %d-%02d-%02d after %d ticks",
        ty, tm, td, max_ticks))
  end
  return ticks
end

-- ---------------------------------------------------------------------------
-- 1. App:runSimulatedTicks
-- ---------------------------------------------------------------------------
describe("App:runSimulatedTicks: tick-count contract", function()

  it("fires exactly 1 game tick when called with n=1", function()
    local w = make_mock_world()
    run_simulated_ticks(w, 1)
    assert.equal(1, w.game_ticks)
  end)

  it("fires exactly N game ticks for arbitrary N", function()
    for _, n in ipairs({1, 5, 10, 100}) do
      local w = make_mock_world()
      run_simulated_ticks(w, n)
      assert.equal(n, w.game_ticks,
          string.format("expected %d game ticks, got %d", n, w.game_ticks))
    end
  end)

  it("resets tick_timer to 0 before each call (overrides any existing value)", function()
    -- Start with tick_timer stuck at 5 (would skip several ticks without reset)
    local w = make_mock_world({ tick_timer = 5 })
    run_simulated_ticks(w, 3)
    assert.equal(3, w.game_ticks)
  end)

  it("does nothing when n=0", function()
    local w = make_mock_world()
    run_simulated_ticks(w, 0)
    assert.equal(0, w.game_ticks)
    assert.equal(0, w.tick_calls)
  end)

  it("does nothing when world is nil", function()
    assert.has_no_error(function()
      run_simulated_ticks(nil, 10)
    end)
  end)

  it("each simulated tick is a real game tick (tick_timer forced to 0)", function()
    -- Verify tick_calls equals game_ticks (1 onTick call produces 1 game tick)
    local w = make_mock_world()
    run_simulated_ticks(w, 7)
    assert.equal(7, w.game_ticks)
    assert.equal(7, w.tick_calls)
  end)

  it("works with non-default tick_rate", function()
    local w = make_mock_world({ tick_rate = 10 })
    run_simulated_ticks(w, 4)
    assert.equal(4, w.game_ticks)
  end)

  it("large tick counts complete without error", function()
    local w = make_mock_world()
    assert.has_no_error(function()
      run_simulated_ticks(w, 5000)
    end)
    assert.equal(5000, w.game_ticks)
  end)
end)

-- ---------------------------------------------------------------------------
-- 2. World:advanceToDate
-- ---------------------------------------------------------------------------
describe("World:advanceToDate: date-advancement contract", function()

  it("does not tick when already at the target date", function()
    local w = make_mock_world({ year=1, month=3, day=1 })
    local ticks = advance_to_date(w, 1, 3, 1)
    assert.equal(0, ticks)
    assert.equal(0, w.game_ticks)
  end)

  it("does not tick when already past the target date", function()
    local w = make_mock_world({ year=1, month=4, day=1 })
    local ticks = advance_to_date(w, 1, 3, 1)
    assert.equal(0, ticks)
  end)

  it("advances at least 1 tick when target is tomorrow", function()
    local w = make_mock_world({ year=1, month=1, day=1 })
    local ticks = advance_to_date(w, 1, 1, 2)
    assert.is_true(ticks >= 1)
    -- After advancing, day should be >= 2
    assert.is_true(w.day >= 2 or w.month > 1)
  end)

  it("advances across a month boundary", function()
    local w = make_mock_world({ year=1, month=1, day=1 })
    advance_to_date(w, 1, 2, 1)
    -- Should be at or after month 2
    assert.is_true(w.month >= 2 or w.year > 1)
  end)

  it("advances across a year boundary", function()
    local w = make_mock_world({ year=1, month=1, day=1 })
    advance_to_date(w, 2, 1, 1)
    assert.is_true(w.year >= 2)
  end)

  it("terminates deterministically (same start produces same tick count)", function()
    local ticks_a, ticks_b
    do
      local w = make_mock_world({ year=1, month=1, day=1 })
      ticks_a = advance_to_date(w, 1, 3, 1)
    end
    do
      local w = make_mock_world({ year=1, month=1, day=1 })
      ticks_b = advance_to_date(w, 1, 3, 1)
    end
    assert.equal(ticks_a, ticks_b)
  end)

  it("raises an error when the safety limit is exceeded", function()
    -- A world whose date never advances (broken mock)
    local w = make_mock_world({ year=1, month=1, day=1 })
    w.onTick = function(self)
      -- Deliberately never advances the date
      self.tick_calls = self.tick_calls + 1
    end
    w.beforeDate = function(self, ty, tm, td)
      return true  -- always "before" target → infinite loop without cap
    end
    assert.has_error(function()
      advance_to_date(w, 1, 2, 1, 50)  -- low cap for test speed
    end)
  end)
end)

-- ---------------------------------------------------------------------------
-- 3. Interaction between runSimulatedTicks and advanceToDate patterns
-- ---------------------------------------------------------------------------
describe("Tick accelerator: composite scenarios", function()

  it("runSimulatedTicks(50) advances one full game day (50 hours/day, 1 h/tick)", function()
    local w = make_mock_world({ year=1, month=1, day=1, hour=0 })
    run_simulated_ticks(w, 50)
    -- 50 hours = 1 full day; should be on day 2 (or later)
    assert.is_true(w.day >= 2 or w.month > 1 or w.year > 1)
  end)

  it("runSimulatedTicks followed by advanceToDate maintains correct state", function()
    local w = make_mock_world({ year=1, month=1, day=1 })
    run_simulated_ticks(w, 100)   -- advance ~2 days
    local day_after_first_run = w.day
    advance_to_date(w, 1, 2, 1)  -- advance to month 2
    assert.is_true(w.month >= 2 or w.year > 1)
    -- The combined ticks are monotonically increasing
    assert.is_true(w.game_ticks > day_after_first_run)
  end)

  it("hours_per_tick=8 (Speed Up) reaches month 2 in fewer ticks than hours_per_tick=1", function()
    local slow_ticks, fast_ticks
    do
      local w = make_mock_world({ hours_per_tick = 1 })
      slow_ticks = advance_to_date(w, 1, 2, 1)
    end
    do
      local w = make_mock_world({ hours_per_tick = 8 })
      fast_ticks = advance_to_date(w, 1, 2, 1)
    end
    assert.is_true(fast_ticks < slow_ticks,
        string.format("fast=%d should be < slow=%d", fast_ticks, slow_ticks))
  end)
end)
