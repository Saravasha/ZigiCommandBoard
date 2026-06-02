const { contextBridge, ipcRenderer } = require("electron");

contextBridge.exposeInMainWorld("api", {
  getCommands: () => ipcRenderer.invoke("get-commands"),
  runCommand: (id) => ipcRenderer.invoke("run-command", id),
  showDashboard: () => ipcRenderer.send("show-dashboard"),
  hideDashboard: () => ipcRenderer.send("hide-dashboard"),

  onDashboardVisible: (callback) => {
    const handler = (_, v) => callback(v);
    ipcRenderer.on("dashboard-visible", handler);

    return () => ipcRenderer.removeListener("dashboard-visible", handler);
  },
});
