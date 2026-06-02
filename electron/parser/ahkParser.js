const fs = require("fs");

function parseAhk(filePath, options = { debug: true }) {
  const log = (...args) => options.debug && console.log(...args);

  if (!filePath) {
    throw new Error("parseAhk: filePath is required");
  }

  log("🚀 PARSER START");
  log("FILE:", filePath);

  // -------------------------
  // STEP 1: READ FILE
  // -------------------------
  const text = fs.readFileSync(filePath, "utf8");
  const lines = text.split(/\r?\n/);

  log("STEP 1 OK - lines:", lines.length);

  // -------------------------
  // STATE
  // -------------------------
  const commands = [];
  let meta = {};
  let pendingFunction = null;

  // -------------------------
  // STEP 2: SCAN
  // -------------------------
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i].trim();

    if (options.debug && i < 5) {
      log("LINE:", line);
    }

    // -------------------------
    // META PARSING
    // -------------------------
    const metaMatch = line.match(/^;\s*@(\w+)\s+(.*)/);
    if (metaMatch) {
      const [, key, value] = metaMatch;
      log("META:", key, value);
      meta[key.toLowerCase()] = value;
      continue;
    }

    // -------------------------
    // FUNCTION DETECTION
    // -------------------------
    const fnMatch = line.match(/^([a-zA-Z0-9_]+)\s*\(\s*\)\s*\{/);

    if (fnMatch) {
      const fnName = fnMatch[1];
      pendingFunction = fnName;

      // emit command if metadata exists
      if (meta.name || meta.id) {
        commands.push({
          id: meta.id || fnName.toLowerCase(),
          name: meta.name || fnName,
          description: meta.desc || "",
          hotkey: meta.hotkey || "",
          category: meta.category || "uncategorized",
          function: fnName,
        });
      }

      meta = {}; // reset after binding
    }
  }

  // -------------------------
  // STEP 3: DONE
  // -------------------------
  log("DONE. COMMANDS:", commands.length);

  if (options.debug) {
    console.log(JSON.stringify(commands, null, 2));
  }

  return commands;
}

module.exports = { parseAhk };
