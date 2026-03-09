--[[ Terminal Triage: device-loss action override

In the base game a patient death triggers either a heaven sequence (wings appear,
patient flies upward) or a grim reaper + lava-hole sequence.  Both are
medically-themed and break the IT repair fantasy.

This override replaces those sequences with a simple despawn after the fall
animation.  Semantically: the device has been written off and is removed from
the floor — no supernatural visitors required.

The `permanent` keys match the base game exactly so that save/load remains
compatible with the underlying engine.
--]]

class "DieAction" (HumanoidAction)

---@type DieAction
local DieAction = _G["DieAction"]

function DieAction:DieAction()
  self:HumanoidAction("die")
end

-- After the fall animation: despawn and destroy.  No heaven or reaper sequence.
local action_die_tick; action_die_tick = permanent"action_die_tick"( function(humanoid)
  humanoid:despawn()
  humanoid.world:destroyEntity(humanoid)
end)

-- Grim reaper path redirected to the same simple despawn.
-- Defined with the original permanent key for save/load compatibility.
local action_die_tick_reaper; action_die_tick_reaper = permanent"action_die_tick_reaper"( function(humanoid) -- luacheck: ignore 211
  action_die_tick(humanoid)
end)

local function action_die_start(action, humanoid)
  humanoid:setMoodInfo()  -- clear mood icons
  local preferred_fall_direction
  if math.random(0, 1) == 1 then
    preferred_fall_direction = "east"
  else
    preferred_fall_direction = "south"
  end
  local anims = humanoid.die_anims
  assert(anims, "Error: no death animation for humanoid " .. humanoid.humanoid_class)
  action.must_happen = true

  -- Fix hair layer for baldness before playing the fall animation (same as base).
  if humanoid.disease.id == "baldness" then humanoid:setLayer(0, 2) end

  local mirror_fall = preferred_fall_direction == "east" and 0 or 1
  humanoid.last_move_direction = preferred_fall_direction
  humanoid:setAnimation(anims.fall_east, mirror_fall)
  action.phase = 0

  local fall_anim_duration = TheApp.animation_manager:getAnimLength(anims.fall_east)
  -- Chewbacca has a bugged animation past frame 21; truncate as the base does.
  if humanoid:isType("Chewbacca Patient") then
    fall_anim_duration = 21
  end

  humanoid.dead = true
  -- Always use simple despawn — no grim reaper, no wings.
  humanoid:setTimer(fall_anim_duration, action_die_tick)
end

return action_die_start
