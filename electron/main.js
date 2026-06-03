console.log("🔥 ELECTRON MAIN FILE LOADED");

const path = require("path");
const { execFile } = require("child_process");
const fs = require("fs");
const { app, BrowserWindow, ipcMain, screen } = require("electron");
const { parseAhk } = require("./parser/ahkParser");
const net = require("net");

const PIPE_NAME = "\\\\.\\pipe\\zigi-board";

let pipeServer = null;

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

function moveToTopRight(win) {
  const { width } = screen.getPrimaryDisplay().workAreaSize;
  const { workArea } = display;

  const winBounds = win.getBounds();
  const x = workArea.x + workArea.width - winBounds.width - 20;
  const y = workArea.y + 20;

  win.setPosition(x, y);
}

function getResponsiveSize() {
  const { width, height } = screen.getPrimaryDisplay().workAreaSize;

  return {
    width: Math.floor(width * 0.35), // 35% of screen width
    height: Math.floor(height * 0.5), // 50% of screen height
  };
}

function createWindow() {
  mainWindow = new BrowserWindow({
    width: getResponsiveSize().width,
    height: getResponsiveSize().height,
    frame: false,
    transparent: true,
    resizable: false,
    show: false,
    skipTaskbar: true,
    alwaysOnTop: true,
    x: 0,
    y: 0,
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
    mainWindow.on("moved", () => moveToTopRight(mainWindow));
    mainWindow.webContents.setZoomFactor(1);

    mainWindow.webContents.on("did-finish-load", () => {
      mainWindow.webContents.send("app-ready");
    });
  } else {
    const prodPath = path.join(__dirname, "../ui/dist/index.html");
    mainWindow.loadFile(prodPath);
    mainWindow.on("moved", () => moveToTopRight(mainWindow));
    mainWindow.webContents.setZoomFactor(1);

    mainWindow.webContents.on("did-finish-load", () => {
      mainWindow.webContents.send("app-ready");
    });
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

const gotLock = app.requestSingleInstanceLock();

if (!gotLock) {
  app.quit();
}

app.on("second-instance", () => {
  if (mainWindow) {
    mainWindow.show();
    mainWindow.focus();
  }
});

app.on("before-quit", () => {
  if (pipeServer) {
    pipeServer.close();
    pipeServer = null;
  }
});

function startPipeServer() {
  if (pipeServer) return;

  pipeServer = net.createServer((stream) => {
    stream.on("data", (data) => {
      const msg = data.toString().trim();
      console.log("PIPE MSG:", msg);
      console.log("RAW MSG:", JSON.stringify(msg));
      if (!mainWindow) return;

      if (msg === "ensure") {
        if (!mainWindow) createWindow();
        if (mainWindow && !mainWindow.isVisible()) {
          mainWindow.show();
        }
      }

      if (msg === "show") {
        mainWindow.show();
        mainWindow.focus();
        mainWindow.webContents.send("dashboard-visible", true);
      }

      if (msg === "hide") {
        mainWindow.webContents.send("dashboard-visible", false);

        setTimeout(() => {
          mainWindow.hide();
        }, 250);
      }
    });
  });

  pipeServer.listen(PIPE_NAME, () => {
    console.log("Named pipe ready:", PIPE_NAME);
  });
}

// --------------------
// APP START
// --------------------
app.whenReady().then(() => {
  try {
    console.log("START PARSE CALL");

    commands = parseAhk(workerScript);

    console.log("COMMANDS LOADED:", commands.length);

    createWindow();
    startPipeServer();
  } catch (err) {
    console.error("🔥 ELECTRON STARTUP ERROR:", err);
  }
});
