# 📊 DistroLine

A highly responsive, adaptive, production-grade **6-Entity Line Distribution Engine** built from scratch using **Godot 4**. Designed for K-pop archivists, data nerds, and line-distribution creators who want a fast, lightweight desktop tool instead of a rigid, clunky spreadsheet.

Licensed under the permissive **MIT License** — feel free to download, modify, break, or customize it completely for free!

---

## ✨ Key Features

* **Adaptive Grid Layout:** Dynamically scale your session anywhere from 1 to 6 member slots on the fly. Left the input fields blank? The engine automatically engages a fallback database initialized with a classic 6-member IVE roster (`WONYOUNG`, `LIZ`, `REI`, `YUJIN`, `GAEUL`, `LEESEO`).
* **Unison Chorus Macro:** Skip the 400 APM finger-breaking struggle during massive chorus sections or group harmonies. Tapping the unison hotkey (`KEY_0`) activates **Unison Mode**, dynamically distributing tracking runtime across all active slots simultaneously in perfect synchronization.
* **CSV Export Pipeline:** The gold standard for data tracking. Hitting the `SAVE LnDis` button instantly flushes active tracking memory and compiles a beautifully formatted `.csv` spreadsheet straight to your local directory with exact second durations and rounded percentage values.
* **Terminal Diagnostics:** Fully polished with custom engine logging using `print_rich()`. Your local debugging terminal tracks state transitions and input shifts like a high-end command-line matrix.

---

## 🛠️ Tech Stack & Constraints

* **Engine:** Godot 4 (GDScript)
* **Current Boundary Limits:** Hardcapped up to 6 members (Optimized for 2-6 member groups). 
* **Roadmap Targets:** Swapping the core layout into a scrollable viewport container to scale up to 43 members safely without clipping text boundaries.
* **Audio Setup:** Currently utilizes external background audio playing (e.g., Spotify, YouTube). *No built-in player is active in the current alpha layer to keep execution times blazingly fast.*

---

## 👻 The Dev Chronicles: The Ghosting Nightmare

Every systems architecture sprint has its demons. During development, a catastrophic UI bug caused the engine to layer every single newly instantiated member row directly over each other at coordinate `(0, 0)`. It looked less like an asset manager and more like a glitched, deep-fried 3D text overlay from a psychological horror game. 

**The Culprit:** The layout engine was reading a flat, generic root `Control` node as a raw `0x0` pixel boundary box, causing child elements to visual-spill out into the viewport space. Switching the scene's root node type to a true `LineEdit` immediately established proper layout bounds and forced crisp, uniform spacing.

---

## 🚀 Getting Started

1. Clone this repository to your local system.
2. Import the project root directory into the **Godot 4 engine launcher**.
3. Fire up the execution script from the main menu!
4. Map `ui_key_1` through `ui_key_6` and `ui_key_all` inside your **Input Map Settings** to control your real-time tracking keys.

---

## 📝 License

Distributed under the **MIT License**. See `LICENSE` for more information.

*p.s. The full development process recording and editing pass will be posted over on YouTube along with the visual breakdown video!*
