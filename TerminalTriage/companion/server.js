#!/usr/bin/env node
// Terminal Triage Companion App — Local Server
// Requires Node.js 18+. No npm packages needed.
//
// Usage: node server.js  (or double-click companion.bat)

"use strict";

const http = require("http");
const fs = require("fs");
const path = require("path");
const url = require("url");

const PORT = 3747;
const COMPANION_DIR = __dirname;
const MOD_LANG_FILE = path.join(COMPANION_DIR, "..", "Lua", "languages", "english_terminal_triage.lua");

// ---------------------------------------------------------------------------
// Original Theme Hospital / CorsixTH English names (hardcoded — these come
// from the binary .dat files and never change).
// ---------------------------------------------------------------------------

const ORIGINALS = {
  rooms: {
    reception:         { short: "Reception",           long: "Reception" },
    gps_office:        { short: "GP's Office",         long: "GP's Office" },
    psychiatric:       { short: "Psychiatry",          long: "Psychiatry" },
    ward:              { short: "Ward",                long: "Ward" },
    operating_theatre: { short: "Operating Theatre",   long: "Operating Theatre" },
    pharmacy:          { short: "Pharmacy",            long: "Pharmacy" },
    cardiogram:        { short: "Cardiogram Room",     long: "Cardiogram Room" },
    scanner:           { short: "Scanner Room",        long: "Scanner Room" },
    ultrascan:         { short: "Ultrascan",           long: "Ultrascan" },
    blood_machine:     { short: "Blood Machine",       long: "Blood Machine" },
    x_ray:             { short: "X-Ray Room",          long: "X-Ray Room" },
    inflation:         { short: "Inflation Room",      long: "Inflation Room" },
    dna_fixer:         { short: "DNA Fixer",           long: "DNA Fixer" },
    hair_restoration:  { short: "Hair Restoration",    long: "Hair Restoration" },
    tongue_clinic:     { short: "Tongue Clinic",       long: "Tongue Clinic" },
    fracture_clinic:   { short: "Fracture Clinic",     long: "Fracture Clinic" },
    training_room:     { short: "Training Room",       long: "Training Room" },
    electrolysis:      { short: "Electrolysis",        long: "Electrolysis" },
    jelly_vat:         { short: "Jelly Vat",           long: "Jelly Vat" },
    staffroom:         { short: "Staff Room",          long: "Staff Room" },
    general_diag:      { short: "General Diagnosis",   long: "General Diagnosis" },
    research_room:     { short: "Research Room",       long: "Research Room" },
    decontamination:   { short: "Decontamination",     long: "Decontamination" },
    toilets:           { short: "Toilets",             long: "Toilets" },
  },
  diseases: {
    general_practice:      { name: "General Practice" },
    bloaty_head:           { name: "Bloaty Head" },
    hairyitis:             { name: "Hairyitis" },
    king_complex:          { name: "King Complex" },
    invisibility:          { name: "Invisibility" },
    serious_radiation:     { name: "Serious Radiation" },
    slack_tongue:          { name: "Slack Tongue" },
    alien_dna:             { name: "Alien DNA" },
    fractured_bones:       { name: "Fractured Bones" },
    baldness:              { name: "Baldness" },
    discrete_itching:      { name: "Discrete Itching" },
    jellyitis:             { name: "Jellyitis" },
    sleeping_illness:      { name: "Sleeping Illness" },
    transparency:          { name: "Transparency" },
    uncommon_cold:         { name: "Uncommon Cold" },
    broken_wind:           { name: "Broken Wind" },
    spare_ribs:            { name: "Spare Ribs" },
    kidney_beans:          { name: "Kidney Beans" },
    broken_heart:          { name: "Broken Heart" },
    ruptured_nodules:      { name: "Ruptured Nodules" },
    tv_personalities:      { name: "TV Personalities" },
    infectious_laughter:   { name: "Infectious Laughter" },
    corrugated_ankles:     { name: "Corrugated Ankles" },
    chronic_nosehair:      { name: "Chronic Nosehair" },
    third_degree_sideburns:{ name: "Third Degree Sideburns" },
    fake_blood:            { name: "Fake Blood" },
    gastric_ejections:     { name: "Gastric Ejections" },
    the_squits:            { name: "The Squits" },
    iron_lungs:            { name: "Iron Lungs" },
    sweaty_palms:          { name: "Sweaty Palms" },
    heaped_piles:          { name: "Heaped Piles" },
    gut_rot:               { name: "Gut Rot" },
    golf_stones:           { name: "Golf Stones" },
    unexpected_swelling:   { name: "Unexpected Swelling" },
  },
  staff_class: {
    nurse:        "Nurse",
    doctor:       "Doctor",
    handyman:     "Handyman",
    receptionist: "Receptionist",
    surgeon:      "Surgeon",
  },
  staff_title: {
    receptionist: "Receptionist",
    general:      "General",
    nurse:        "Nurse",
    junior:       "Junior",
    doctor:       "Doctor",
    surgeon:      "Surgeon",
    psychiatrist: "Psychiatrist",
    consultant:   "Consultant",
    researcher:   "Researcher",
  },
  objects: {
    reception_desk:      "Reception Desk",
    computer:            "Computer",
    pharmacy_cabinet:    "Pharmacy Cabinet",
    blood_machine:       "Blood Machine",
    cardio:              "Cardiogram Machine",
    scanner:             "Scanner",
    operating_table:     "Operating Table",
    hair_restorer:       "Hair Restorer",
    dna_fixer:           "DNA Fixer",
    x_ray:               "X-Ray Machine",
    inflator:            "Inflator",
    crash_trolley:       "Crash Trolley",
    lecture_chair:       "Lecture Chair",
    pool_table:          "Pool Table",
    projector:           "Projector",
    plant:               "Plant",
    bin:                 "Bin",
    radiator:            "Radiator",
    sofa:                "Sofa",
    tv:                  "TV",
    video_game:          "Video Game",
    bookcase:            "Bookcase",
    skeleton:            "Skeleton",
    bed:                 "Bed",
    cabinet:             "Cabinet",
    jelly_moulder:       "Jelly Moulder",
    cast_remover:        "Cast Remover",
    electrolyser:        "Electrolyser",
    litter_bomb:         "Litter Bomb",
    defibrillator:       "Defibrillator",
    autopsy:             "Autopsy Table",
    ultrascan:           "Ultrascan Machine",
    tongue_laz:          "Tongue Laz-or",
    desk:                "Desk",
    hot_drinks_machine:  "Hot Drinks Machine",
    drinks_machine:      "Soft Drinks Machine",
    extinguisher:        "Fire Extinguisher",
    shower:              "Shower",
    couch:               "Psychiatry Couch",
    screen:              "Screen",
    swing_door:          "Swing Door",
    entrance_door:       "Entrance Door",
  },
};

// Treatment room lookup (disease_id → room_id), derived from CorsixTH disease files
const TREATMENT_ROOMS = {
  bloaty_head:            "inflation",
  hairyitis:              "hair_restoration",
  king_complex:           "psychiatric",
  invisibility:           "dna_fixer",
  serious_radiation:      "decontamination",
  slack_tongue:           "tongue_clinic",
  alien_dna:              "dna_fixer",
  fractured_bones:        "fracture_clinic",
  baldness:               "hair_restoration",
  discrete_itching:       "decontamination",
  jellyitis:              "jelly_vat",
  sleeping_illness:       "ward",
  transparency:           "decontamination",
  uncommon_cold:          "pharmacy",
  broken_wind:            "general_diag",
  spare_ribs:             "operating_theatre",
  kidney_beans:           "blood_machine",
  broken_heart:           "fracture_clinic",
  ruptured_nodules:       "psychiatric",
  tv_personalities:       "psychiatric",
  infectious_laughter:    "jelly_vat",
  corrugated_ankles:      "fracture_clinic",
  chronic_nosehair:       "hair_restoration",
  third_degree_sideburns: "hair_restoration",
  fake_blood:             "decontamination",
  gastric_ejections:      "general_diag",
  the_squits:             "ward",
  iron_lungs:             "operating_theatre",
  sweaty_palms:           "operating_theatre",
  heaped_piles:           "operating_theatre",
  gut_rot:                "pharmacy",
  golf_stones:            "blood_machine",
  unexpected_swelling:    "pharmacy",
};

// ---------------------------------------------------------------------------
// Lua file parser — extracts key = "value" assignments, including entries
// inside named table blocks (e.g. subtitles = { emerg001 = "...", ... })
// and positional array blocks (e.g. totd_window.tips = { "tip1", ... }).
// ---------------------------------------------------------------------------

function parseLuaAssignments(filePath) {
  const result = {};
  try {
    const content = fs.readFileSync(filePath, "utf8");
    const lines = content.split(/\r?\n/);

    // Regex patterns
    const topKeyRe    = /^[ \t]*([\w][\w.]*)\s*=\s*"((?:[^"\\]|\\.)*)"/;
    const tableOpenRe = /^[ \t]*([\w][\w.]*)\s*=\s*\{/;
    const innerKeyRe  = /^[ \t]*([\w]+)\s*=\s*"((?:[^"\\]|\\.)*)"/;
    const innerStrRe  = /^[ \t]*"((?:[^"\\]|\\.)*)"/;

    let inTable   = null;  // tableName prefix while inside a block
    let depth     = 0;
    let arrayIdx  = 0;

    for (const line of lines) {
      const trimmed = line.trim();
      if (trimmed.startsWith("--")) continue;  // skip comments

      if (inTable) {
        // Track brace depth
        for (const ch of line) {
          if (ch === "{") depth++;
          else if (ch === "}") depth--;
        }
        if (depth <= 0) {
          inTable = null;
          depth   = 0;
          continue;
        }

        // Keyed entry inside a table block
        const km = line.match(innerKeyRe);
        if (km) {
          result[`${inTable}.${km[1]}`] = unescapeLuaString(km[2]);
          continue;
        }

        // Positional string entry (array)
        const sm = line.match(innerStrRe);
        if (sm) {
          arrayIdx++;
          result[`${inTable}[${arrayIdx}]`] = unescapeLuaString(sm[1]);
        }
      } else {
        // Check for table block open
        const tm = line.match(tableOpenRe);
        if (tm) {
          // Count opens/closes on the same line to detect single-line tables
          let opens = 0, closes = 0;
          for (const ch of line) {
            if (ch === "{") opens++;
            else if (ch === "}") closes++;
          }
          if (closes < opens) {
            inTable  = tm[1];
            depth    = opens - closes;
            arrayIdx = 0;
          }
          continue;
        }

        // Simple top-level assignment
        const m = line.match(topKeyRe);
        if (m) {
          result[m[1]] = unescapeLuaString(m[2]);
        }
      }
    }
  } catch (e) {
    console.error("Parse error:", e.message);
  }
  return result;
}

function unescapeLuaString(s) {
  return s
    .replace(/\\n/g, "\n")
    .replace(/\\t/g, "\t")
    .replace(/\\"/g, '"')
    .replace(/\\\\/g, "\\");
}

function escapeLuaString(s) {
  return s
    .replace(/\\/g, "\\\\")
    .replace(/"/g, '\\"')
    .replace(/\n/g, "\\n")
    .replace(/\t/g, "\\t");
}

// ---------------------------------------------------------------------------
// Mapping builder
// ---------------------------------------------------------------------------

function buildMappings(modAssignments) {
  // --- Rooms ---
  const rooms = Object.entries(ORIGINALS.rooms).map(([id, orig]) => {
    const short = modAssignments[`rooms_short.${id}`] || orig.short;
    const long  = modAssignments[`rooms_long.${id}`]  || orig.long;
    return { id, original: orig.short, mod: { name: short, long_name: long } };
  });

  // --- Diseases ---
  const diseases = Object.entries(ORIGINALS.diseases).map(([id, orig]) => {
    const treatmentId = TREATMENT_ROOMS[id] || null;
    const treatmentMod = treatmentId
      ? (modAssignments[`rooms_short.${treatmentId}`] || ORIGINALS.rooms[treatmentId]?.short || treatmentId)
      : null;
    return {
      id,
      original: orig.name,
      treatment_room_id: treatmentId,
      treatment_room_name: treatmentMod,
      mod: {
        name:     modAssignments[`diseases.${id}.name`]     || orig.name,
        cause:    modAssignments[`diseases.${id}.cause`]    || "",
        symptoms: modAssignments[`diseases.${id}.symptoms`] || "",
        cure:     modAssignments[`diseases.${id}.cure`]     || "",
      },
    };
  });

  // --- Staff ---
  const staffItems = [];
  for (const [id, orig] of Object.entries(ORIGINALS.staff_class)) {
    staffItems.push({
      id: `class.${id}`,
      type: "Class",
      original: orig,
      mod: { name: modAssignments[`staff_class.${id}`] || orig },
    });
  }
  for (const [id, orig] of Object.entries(ORIGINALS.staff_title)) {
    staffItems.push({
      id: `title.${id}`,
      type: "Title",
      original: orig,
      mod: { name: modAssignments[`staff_title.${id}`] || orig },
    });
  }

  // --- Objects ---
  const objects = Object.entries(ORIGINALS.objects)
    .map(([id, orig]) => ({
      id,
      original: orig,
      mod: { name: modAssignments[`object.${id}`] || modAssignments[`tooltip.objects.${id}`] || orig },
    }));

  return { rooms, diseases, staff: staffItems, objects, ...buildMessages(modAssignments) };
}

// ---------------------------------------------------------------------------
// Messages builder — adviser, PA subtitles, tips of the day
// ---------------------------------------------------------------------------

// Maps adviser sub-key prefix → display group name
const ADVISER_GROUPS = {
  warnings:          "Warnings",
  praise:            "Praise",
  information:       "Information",
  goals:             "Goals",
  level_progress:    "Level Progress",
  research:          "Research",
  competitors:       "Competitors",
  epidemic:          "Epidemic",
  boiler_issue:      "Infrastructure",
  vomit_wave:        "Incidents",
  earthquake:        "Disruption",
  staff_advice:      "Staff Advice",
  staff_place_advice:"Placement Advice",
  room_requirements: "Room Requirements",
  surgery_requirements:"Surgery Requirements",
};

// Maps subtitle key prefix → display group name
const SUBTITLE_GROUPS = {
  emerg: "Emergency",
  epid:  "Epidemic",
  maint: "Maintenance",
  quake: "Disruption",
  rand:  "Random PA",
  reqd:  "Staff Required",
  sack:  "Dismissal",
  sorry: "Apology",
  vip:   "VIP",
  cheat: "Cheat",
  mach:  "Machine Alarm",
};

function subtitleGroup(key) {
  for (const [prefix, group] of Object.entries(SUBTITLE_GROUPS)) {
    if (key.startsWith(prefix)) return group;
  }
  return "General";
}

function buildMessages(mod) {
  // --- Adviser messages ---
  const adviser = [];
  for (const [luaKey, text] of Object.entries(mod)) {
    if (!luaKey.startsWith("adviser.")) continue;
    // luaKey: "adviser.warnings.money_low" → parts[1]="warnings", parts[2]="money_low"
    const parts = luaKey.split(".");
    if (parts.length < 3) continue;
    const subcat = parts[1];
    const label  = parts.slice(2).join(".");
    adviser.push({
      id:    luaKey,
      group: ADVISER_GROUPS[subcat] || subcat,
      label,
      text,
    });
  }
  adviser.sort((a, b) => a.id.localeCompare(b.id));

  // --- PA Subtitles ---
  const subtitles = [];
  for (const [luaKey, text] of Object.entries(mod)) {
    if (!luaKey.startsWith("subtitles.")) continue;
    const key = luaKey.replace("subtitles.", "");
    subtitles.push({
      id:    luaKey,
      key,
      group: subtitleGroup(key),
      text,
    });
  }
  subtitles.sort((a, b) => a.id.localeCompare(b.id));

  // --- Tips of the Day ---
  const tips = [];
  let idx = 1;
  while (mod[`totd_window.tips[${idx}]`] !== undefined) {
    tips.push({ id: `tip.${idx}`, index: idx, text: mod[`totd_window.tips[${idx}]`] });
    idx++;
  }

  return { adviser, subtitles, tips };
}

// ---------------------------------------------------------------------------
// Write a single field back to english_terminal_triage.lua
// ---------------------------------------------------------------------------

// Write a top-level key = "value" assignment
function writeSimpleKey(luaKey, value) {
  const content = fs.readFileSync(MOD_LANG_FILE, "utf8");
  const escaped = escapeLuaString(value);
  const escapedKey = luaKey.replace(/\./g, "\\.").replace(/[-[\]{}()*+?^$|]/g, "\\$&");
  const lineRe = new RegExp(`^([ \\t]*${escapedKey}[ \\t]*=[ \\t]*)"(?:[^"\\\\]|\\\\.)*"`, "m");

  if (!lineRe.test(content)) {
    atomicWrite(MOD_LANG_FILE, content.trimEnd() + "\n" + `${luaKey} = "${escaped}"` + "\n");
  } else {
    atomicWrite(MOD_LANG_FILE, content.replace(lineRe, `$1"${escaped}"`));
  }
}

// Write a keyed entry inside a named table block: blockName = { key = "value", ... }
function writeTableEntry(blockName, key, value) {
  const content  = fs.readFileSync(MOD_LANG_FILE, "utf8");
  const lines    = content.split(/\r?\n/);
  const escaped  = escapeLuaString(value);

  // Locate the block
  const blockStartRe = new RegExp(`^${blockName.replace(/\./g, "\\.")}\\s*=\\s*\\{`);
  let blockStart = -1, blockEnd = -1, depth = 0;
  for (let i = 0; i < lines.length; i++) {
    if (blockStart === -1 && blockStartRe.test(lines[i])) {
      blockStart = i;
      for (const ch of lines[i]) { if (ch === "{") depth++; else if (ch === "}") depth--; }
    } else if (blockStart !== -1) {
      for (const ch of lines[i]) { if (ch === "{") depth++; else if (ch === "}") depth--; }
      if (depth <= 0) { blockEnd = i; break; }
    }
  }
  if (blockStart === -1) throw new Error(`Table block "${blockName}" not found in file`);

  // Find and replace the keyed entry within the block
  const escapedKey = key.replace(/[-[\]{}()*+?^$|]/g, "\\$&");
  const entryRe = new RegExp(`^([ \\t]*${escapedKey}[ \\t]*=[ \\t]*)"(?:[^"\\\\]|\\\\.)*"`);
  for (let i = blockStart; i <= blockEnd; i++) {
    if (entryRe.test(lines[i])) {
      lines[i] = lines[i].replace(entryRe, `$1"${escaped}"`);
      atomicWrite(MOD_LANG_FILE, lines.join("\n"));
      return;
    }
  }

  // Not found in block — insert before the closing brace
  lines.splice(blockEnd, 0, `  ${key} = "${escaped}",`);
  atomicWrite(MOD_LANG_FILE, lines.join("\n"));
}

// Write a positional entry inside an array block: blockName = { "v1", "v2", ... }
function writeArrayEntry(blockName, index, value) {
  const content  = fs.readFileSync(MOD_LANG_FILE, "utf8");
  const lines    = content.split(/\r?\n/);
  const escaped  = escapeLuaString(value);

  const blockStartRe = new RegExp(`^${blockName.replace(/\./g, "\\.")}\\s*=\\s*\\{`);
  let blockStart = -1, blockEnd = -1, depth = 0;
  for (let i = 0; i < lines.length; i++) {
    if (blockStart === -1 && blockStartRe.test(lines[i])) {
      blockStart = i;
      for (const ch of lines[i]) { if (ch === "{") depth++; else if (ch === "}") depth--; }
    } else if (blockStart !== -1) {
      for (const ch of lines[i]) { if (ch === "{") depth++; else if (ch === "}") depth--; }
      if (depth <= 0) { blockEnd = i; break; }
    }
  }
  if (blockStart === -1) throw new Error(`Array block "${blockName}" not found in file`);

  // Find the Nth positional string
  const strRe = /^([ \t]*)"((?:[^"\\]|\\.)*)"/;
  let count = 0;
  for (let i = blockStart + 1; i < blockEnd; i++) {
    if (strRe.test(lines[i])) {
      count++;
      if (count === index) {
        lines[i] = lines[i].replace(strRe, `$1"${escaped}"`);
        atomicWrite(MOD_LANG_FILE, lines.join("\n"));
        return;
      }
    }
  }
  throw new Error(`Array entry ${index} not found in block "${blockName}"`);
}

function writeField(category, id, field, value) {
  if (category === "adviser") {
    // id IS the full Lua key, e.g. "adviser.warnings.money_low"
    writeSimpleKey(id, value);
    return;
  }

  if (category === "subtitles") {
    // id is "subtitles.emerg001" → key within subtitles table is "emerg001"
    writeTableEntry("subtitles", id.replace("subtitles.", ""), value);
    return;
  }

  if (category === "tips") {
    // id is "tip.N" → Nth entry in totd_window.tips array
    const index = parseInt(id.replace("tip.", ""), 10);
    writeArrayEntry("totd_window.tips", index, value);
    return;
  }

  // Entity categories (rooms, diseases, staff, objects)
  let luaKey;
  if (category === "rooms") {
    luaKey = field === "long_name" ? `rooms_long.${id}` : `rooms_short.${id}`;
  } else if (category === "diseases") {
    luaKey = `diseases.${id}.${field}`;
  } else if (category === "staff") {
    const [type, staffId] = id.split(".");
    luaKey = `staff_${type}.${staffId}`;
  } else if (category === "objects") {
    luaKey = `object.${id}`;
  } else {
    throw new Error(`Unknown category: ${category}`);
  }
  writeSimpleKey(luaKey, value);
}

function atomicWrite(filePath, content) {
  const tmp = filePath + ".tmp";
  fs.writeFileSync(tmp, content, "utf8");
  fs.renameSync(tmp, filePath);
}

// ---------------------------------------------------------------------------
// HTTP server
// ---------------------------------------------------------------------------

const MIME = {
  ".html": "text/html; charset=utf-8",
  ".js":   "application/javascript",
  ".json": "application/json",
  ".css":  "text/css",
};

const server = http.createServer((req, res) => {
  const parsed = url.parse(req.url, true);
  const pathname = parsed.pathname;

  // CORS for local dev
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, PATCH, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");

  if (req.method === "OPTIONS") {
    res.writeHead(204); res.end(); return;
  }

  // --- GET / → serve index.html ---
  if (req.method === "GET" && (pathname === "/" || pathname === "/index.html")) {
    serveFile(res, path.join(COMPANION_DIR, "index.html"));
    return;
  }

  // --- GET /api/mappings → full mappings JSON ---
  if (req.method === "GET" && pathname === "/api/mappings") {
    try {
      const mod = parseLuaAssignments(MOD_LANG_FILE);
      const mappings = buildMappings(mod);
      jsonResponse(res, 200, mappings);
    } catch (e) {
      jsonResponse(res, 500, { error: e.message });
    }
    return;
  }

  // --- GET /api/reload → same as /api/mappings (alias for browser reload button) ---
  if (req.method === "GET" && pathname === "/api/reload") {
    try {
      const mod = parseLuaAssignments(MOD_LANG_FILE);
      const mappings = buildMappings(mod);
      jsonResponse(res, 200, mappings);
    } catch (e) {
      jsonResponse(res, 500, { error: e.message });
    }
    return;
  }

  // --- PATCH /api/entry → write a field back to the Lua file ---
  if (req.method === "PATCH" && pathname === "/api/entry") {
    readBody(req, (body) => {
      try {
        const { category, id, field, value } = JSON.parse(body);
        if (!category || !id || !field || value === undefined) {
          jsonResponse(res, 400, { error: "Missing required fields: category, id, field, value" });
          return;
        }
        if (typeof value !== "string" || value.trim() === "") {
          jsonResponse(res, 400, { error: "Value must be a non-empty string" });
          return;
        }
        writeField(category, id, field, value.trim());
        // Return the updated entry from whatever category it belongs to
        const mod = parseLuaAssignments(MOD_LANG_FILE);
        const mappings = buildMappings(mod);
        const categoryData = mappings[category];
        const entry = Array.isArray(categoryData)
          ? categoryData.find((e) => e.id === id)
          : null;
        jsonResponse(res, 200, { ok: true, entry });
      } catch (e) {
        jsonResponse(res, 500, { error: e.message });
      }
    });
    return;
  }

  res.writeHead(404); res.end("Not found");
});

function serveFile(res, filePath) {
  try {
    const ext = path.extname(filePath);
    const data = fs.readFileSync(filePath);
    res.writeHead(200, { "Content-Type": MIME[ext] || "application/octet-stream" });
    res.end(data);
  } catch {
    res.writeHead(404); res.end("File not found");
  }
}

function jsonResponse(res, status, data) {
  const body = JSON.stringify(data, null, 2);
  res.writeHead(status, { "Content-Type": "application/json" });
  res.end(body);
}

function readBody(req, cb) {
  const chunks = [];
  req.on("data", (c) => chunks.push(c));
  req.on("end", () => cb(Buffer.concat(chunks).toString("utf8")));
}

server.listen(PORT, "127.0.0.1", () => {
  console.log(`\n  🖥️  Terminal Triage Companion`);
  console.log(`  ─────────────────────────────`);
  console.log(`  Open in browser: http://localhost:${PORT}`);
  console.log(`  Lang file:       ${MOD_LANG_FILE}`);
  console.log(`  Press Ctrl+C to stop.\n`);
});
