console.log("🔥 ELECTRON MAIN FILE LOADED");

const path = require("path");
const { execFile } = require("child_process");
const fs = require("fs");
const { app, BrowserWindow, ipcMain } = require("electron");
const { parseAhk } = require("../parser/ahkParser");

let mainWindow;
let commands = [];

// --------------------
// PATHS
// --------------------

const workerScript = path.join(__dirname, "..", "Commands.ahk");
console.log("PRELOAD PATH:", path.join(__dirname, "preload.js"));
// --------------------
// WINDOW
// --------------------
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      preload: path.join(__dirname, "preload.js"),
      contextIsolation: true,
      nodeIntegration: false,
    },
  });

  const isDev = !app.isPackaged;

  if (isDev) {
    mainWindow.loadURL("http://localhost:5173");
  } else {
    mainWindow.loadFile(path.join(__dirname, "../ui/dist/index.html"));
  }
}

// --------------------
// IPC (REGISTER ONCE)
// --------------------
ipcMain.handle("get-commands", () => {
  return commands;
});

ipcMain.handle("run-command", (event, commandId) => {
  console.log("RUN COMMAND:", commandId);

  const ahkExe = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe";
  const workerScript = path.join(__dirname, "..", "Commands.ahk");

  execFile(ahkExe, [workerScript, commandId]);
});

// --------------------
// APP START
// --------------------
app.whenReady().then(() => {
  try {
    console.log("START PARSE CALL");

    commands = parseAhk(workerScript);

    console.log("COMMANDS LOADED:", commands.length);

    createWindow();
  } catch (err) {
    console.error("🔥 ELECTRON STARTUP ERROR:", err);
  }
});
