const { contextBridge, ipcRenderer } = require("electron");

contextBridge.exposeInMainWorld("api", {
  getCommands: () => ipcRenderer.invoke("get-commands"),
  runCommand: (id) => ipcRenderer.invoke("run-command", id),
  showDashboard: () => ipcRenderer.send("show-dashboard"),
  hideDashboard: () => ipcRenderer.send("hide-dashboard"),

  onDashboardVisible: (callback) =>
    ipcRenderer.on("dashboard-visible", (_, visible) => callback(visible)),
});
