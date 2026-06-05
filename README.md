# Zigi Command Board

A hybrid desktop command system combining **AutoHotkey (AHK)** for system orchestration and **Electron** for a modern visual command interface.

The system is designed to act as a fast, keyboard-driven control layer for OS-level actions, audio routing, and application commands.

---

## 🚀 Overview

Zigi Command Board is split into two core layers:

### 🧠 AHK Orchestrator (Backend Control Layer)

- Handles system-level actions (audio, shutdown, command execution)
- Manages runtime state
- Processes IPC messages from other scripts
- Runs mostly hidden / headless

### 🖥 Electron UI (Frontend Layer)

- Hexagonal command board interface
- Visual command execution surface
- Hotkey + command visualization
- Animated UI transitions

### ⏱ Shutdown Script (Scheduled Trigger)

- Runs via Windows Task Scheduler
- Initiates shutdown sequence
- Sends IPC message to orchestrator
