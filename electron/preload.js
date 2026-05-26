const { contextBridge, ipcRenderer } = require("electron");

contextBridge.exposeInMainWorld("api", {
  getCommands: () => ipcRenderer.invoke("get-commands"),
  runCommand: (id) => ipcRenderer.invoke("run-command", id),
});
