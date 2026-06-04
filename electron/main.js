console.log("🔥 ELECTRON MAIN FILE LOADED");

const path = require("path");
const { execFile } = require("child_process");
const fs = require("fs");
const { app, BrowserWindow, ipcMain, screen, Tray, Menu } = require("electron");
const { parseAhk } = require("./parser/ahkParser");
const net = require("net");

const PIPE_NAME = "\\\\.\\pipe\\zigi-board";

let pipeServer = null;
let tray = null;

let mainWindow;
let commands = [];

const isProd = app.isPackaged;

// --------------------
// PATHS
// --------------------

const iconPath = isProd
  ? path.join(process.resourcesPath, "assets", "icon.ico")
  : path.join(__dirname, "../assets/icon.ico");

const baseDir = isProd
  ? path.dirname(process.execPath) // EXE folder
  : path.join(__dirname, ".."); // project root

const workerScript = path.join(baseDir, "runtime", "Commands.ahk");
console.log("PRELOAD PATH:", path.join(__dirname, "preload.js"));
const ahkExe = "C:\\Program Files\\AutoHotkey\\AutoHotkey.exe";

// --------------------
// WINDOW
// --------------------

function moveToTopRight(win) {
  const display = screen.getPrimaryDisplay();
  const { width } = screen.getPrimaryDisplay().workAreaSize;
  const { workArea } = display;

  const winBounds = win.getBounds();
  const x = workArea.x + workArea.width - winBounds.width;
  const y = workArea.y;

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
    backgroundColor: "#00000000",
    title: "Zigi Command Board",
    resizable: false,
    show: false,
    skipTaskbar: true,
    alwaysOnTop: true,
    x: 0,
    y: 0,
    autoHideMenuBar: true,

    icon: iconPath,
    webPreferences: {
      preload: path.join(__dirname, "preload.js"),
      contextIsolation: true,
      nodeIntegration: false,
    },
  });

  const isDev = !app.isPackaged;
  mainWindow.setTitle("Zigi Command Board");

  if (isDev) {
    mainWindow.loadURL("http://localhost:5173");
    mainWindow.webContents.setZoomFactor(1);

    mainWindow.webContents.on("did-finish-load", () => {
      mainWindow.webContents.send("app-ready");
      moveToTopRight(mainWindow);
    });
  } else {
    const prodPath = path.join(__dirname, "../ui/dist/index.html");
    mainWindow.loadFile(prodPath);
    mainWindow.webContents.setZoomFactor(1);

    mainWindow.webContents.on("did-finish-load", () => {
      mainWindow.webContents.send("app-ready");
      moveToTopRight(mainWindow);
    });
  }
}

function createTray() {
  tray = new Tray(iconPath);

  const menu = Menu.buildFromTemplate([
    {
      label: "Show Dashboard",
      click: () => {
        if (!mainWindow) return;

        mainWindow.show();
        mainWindow.focus();

        mainWindow.webContents.send("dashboard-visible", true);
      },
    },
    {
      label: "Hide Dashboard",
      click: () => {
        if (!mainWindow) return;

        mainWindow.webContents.send("dashboard-visible", false);

        setTimeout(() => {
          mainWindow.hide();
        }, 250);
      },
    },
    { type: "separator" },

    {
      label: "Open DevTools",
      click: () => {
        if (!mainWindow) return;

        mainWindow.show();
        mainWindow.focus();
        mainWindow.webContents.openDevTools({
          mode: "detach",
        });
      },
    },

    { type: "separator" },
    {
      label: "Quit",
      click: () => {
        app.quit();
      },
    },
  ]);

  tray.setToolTip("Zigi Command Board");
  tray.setContextMenu(menu);
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
      if (!mainWindow) return;

      if (msg === "ensure") {
        if (!mainWindow) createWindow();
        if (mainWindow && !mainWindow.isVisible()) {
          mainWindow.show();
        }
      }

      if (msg === "bing") {
        console.log("bong");
        return;
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
    createTray();
    startPipeServer();
  } catch (err) {
    console.error("🔥 ELECTRON STARTUP ERROR:", err);
  }
});
