# Zigi Command Board

A hybrid desktop command system combining **AutoHotkey (AHK)** for system orchestration and **Electron** for a modern visual command interface.

The system is designed to act as a fast, keyboard-driven control layer for OS-level actions, audio routing, and application commands.

---

# 🚀 Overview

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

## 🎛 Features

### 📦 Building the Application

#### ⚙️ Requirements

#### Make sure you have installed dependencies before building:

```
npm install
```

### Production

##### To generate a distributable build artifact of Zigi Command Board, run:

```
npm run dist
```

#### Creates a standalone installable application.

#### This will:

- Bundle the Electron application
- Package all runtime dependencies
- Include assets (UI, sounds, configs)
- Output a distributable build in the dist/ folder

### 📁 Output

#### After the build completes, you will find:

```
parent folder of local repo/Zigi-Command-Board-Portable
├── /resources/win-unpacked/
├── /runtime
├── /assets
└── Zigi Command Board.exe
```

(Exact output may vary depending on your Electron builder configuration.)

### 🚀 Development

#### Development mode

```
npm run dev
```

#### Runs the Electron app with live reload (if configured).

#### ⚙ System Control (AHK)

- Default audio device switching (nircmd integration)
- Shutdown orchestration pipeline
- Game-aware behavior hooks
- Command execution engine

#### 🎨 UI Layer (Electron)

- Hexagonal command grid layout
- Dynamic per-command coloring
- Hotkey reveal on hover
- Smooth enter/exit animations
- Fully transparent window mode

#### 🔔 Notifications (AHK UI Service)

- Toast-style system notifications
- Auto-dismiss timers
- Bottom-right positioning
- Lightweight overlay rendering

#### 🎨 UI Design Goals

- Minimal friction command execution
- Fast visual feedback loop
- Hover-to-reveal hotkeys
- Fully keyboard-compatible interface
- No persistent traditional UI panels

### 🧪 Audio System

Audio feedback is handled through Electron + AHK hybrid loading.

Sounds used:
appReady.wav → startup confirmation
device switch sound → audio routing feedback

Audio files are imported via bundler-safe paths in Electron to ensure production compatibility.

### 🧠 Key Design Decisions

#### ✔ Why AHK?

- Low-level system control
- Fast automation
- Direct OS interaction

#### ✔ Why Electron?

- Flexible UI rendering
- Smooth animations
- Hex grid layout flexibility
- Modern UX design layer

#### ✔ Why PostMessage IPC?

- No external dependencies
- Lightweight communication
- Fast local message passing
- Works across scheduled tasks

#### 📦 Project Status

- Core orchestration system: Stable
- IPC messaging: Stable
- Electron UI: Active development
- Legacy AHK GUI: Removed

#### 🏁 Summary

Zigi Command Board is evolving into a dual-layer control system:

AHK → deterministic system brain
Electron → expressive visual interface

Together they form a fast, extensible command-driven OS overlay.
