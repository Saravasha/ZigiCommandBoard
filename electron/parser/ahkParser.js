const fs = require("fs");

function parseAhk(filePath, options = { debug: true }) {
  const log = (...args) => options.debug && console.log(...args);

  if (!filePath) {
    throw new Error("parseAhk: filePath is required");
  }

  log("🚀 PARSER START");
  log("FILE:", filePath);

  const text = fs.readFileSync(filePath, "utf8");

  // -------------------------
  // STEP 1: MATCH COMMANDMAP ENTRIES
  // -------------------------
  const commandRegex = /CommandMap\["(.+?)"\]\s*:=\s*Object\s*\(([\s\S]*?)\)/g;

  const commands = [];
  let match;

  while ((match = commandRegex.exec(text)) !== null) {
    const id = match[1];
    const body = match[2];

    log("FOUND COMMAND:", id);

    const parsed = parseObject(body);

    commands.push({
      id,
      name: parsed.name || id,
      description: parsed.desc || "",
      hotkey: parsed.hotkey || "",
      category: parsed.category || "uncategorized",
      exec: parsed.exec || null, // function reference name (string)
    });
  }

  log("DONE. COMMANDS:", commands.length);

  if (options.debug) {
    console.log(JSON.stringify(commands, null, 2));
  }

  return commands;
}

function parseObject(str) {
  const result = {};

  // matches: "key", "value"
  const pairRegex = /"([^"]+)"\s*,\s*"([^"]*)"/g;

  let match;
  while ((match = pairRegex.exec(str)) !== null) {
    const key = match[1].toLowerCase();
    const value = match[2];
    result[key] = value;
  }

  return result;
}

module.exports = { parseAhk };
