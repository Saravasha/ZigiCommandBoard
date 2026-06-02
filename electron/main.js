console.log("🔥 ELECTRON MAIN FILE LOADED");

const path = require("path");
const { execFile } = require("child_process");
const fs = require("fs");
const { app, BrowserWindow, ipcMain } = require("electron");
const { parseAhk } = require("./parser/ahkParser");

const http = require("http");

let mainWindow;
let commands = [];

// --------------------
// PATHS
// --------------------

const workerScript = app.isPackaged
  ? path.join(
      process.resourcesPath,
      "app.asar.unpacked",
      "electron",
      "Commands.ahk",
    )
  : path.join(__dirname, "Commands.ahk");
console.log("PRELOAD PATH:", path.join(__dirname, "preload.js"));
const ahkExe = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe";

// --------------------
// WINDOW
// --------------------
function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    frame: false,
    transparent: true,
    resizable: false,
    show: false,
    alwaysOnTop: true,
    icon: path.join(__dirname, "../assets/icon.ico"),
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
    const prodPath = path.join(__dirname, "../ui/dist/index.html");
    console.log("Loading:", prodPath);
    mainWindow.loadFile(prodPath);
    mainWindow.webContents.openDevTools();
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

  http
    .createServer((req, res) => {
      if (req.url === "/show") {
        mainWindow.show();
        mainWindow.focus();
        mainWindow.webContents.send("dashboard-visible", true);
      }

      if (req.url === "/hide") {
        mainWindow.webContents.send("dashboard-visible", false);

        setTimeout(() => {
          mainWindow.hide();
        }, 250);
      }

      res.writeHead(200);
      res.end("OK");
    })
    .listen(7777);
});

ipcMain.on("show-dashboard", () => {
  if (!mainWindow) return;
  setTimeout(() => {
    mainWindow.focus();
    mainWindow.show();
    mainWindow.webContents.send("dashboard-visible", true);
  }, 1000);
});

ipcMain.on("hide-dashboard", () => {
  mainWindow.webContents.send("dashboard-visible", false);
  setTimeout(() => {
    mainWindow.hide();
  }, 250);
});
