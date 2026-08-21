# GLKVM and Windows Runbook

## Contents

1. Connection profile
2. Reliable Vivaldi workflow
3. Computer Use mechanics
4. GLKVM settings
5. Input failure modes
6. Windows and Docker operations
7. Completion checks

## Connection profile

- Configured endpoint: `https://192.168.5.37//#/`
- Browser used successfully: Vivaldi
- Vivaldi bundle identifier: `com.vivaldi.Vivaldi`
- Observed GLKVM version: `V1.9.1 release1 (RM10)`
- Healthy stream observed as direct H.264 at 1920x1080 and roughly 39–48 dynamic fps.

Obtain the password from the user or current authorized session. Do not store it in this skill or other dotfiles. Vivaldi may retain the authenticated session and prior trust for the endpoint's certificate, but never assume that state is present on another machine.

## Reliable Vivaldi workflow

1. Open a new Vivaldi window with `Command-N` instead of replacing the user's current tabs.
2. Refresh application state and locate the address field semantically when possible.
3. Set the configured endpoint and press Return.
4. Verify that the window title is `GLKVM - Vivaldi` and that the remote canvas is visible.
5. Keep this window dedicated. Ask the user to use another browser while remote control is active.

Computer Use controls Vivaldi at the application level. A different Vivaldi window becoming active can redirect input or trigger a stale-state error. This happened during the exercise and caused actions to land on unrelated Gmail and Teams views. Never type merely because Vivaldi is active; verify the exact window and page first.

## Computer Use mechanics

Use the Computer Use skill and its persistent Node REPL. The tested bootstrap was:

```javascript
globalThis.sky = (await import("@oai/sky")).sky;
```

Call the app-state inspection operation immediately before each action. Re-inspect after focus changes, navigation, pointer-lock transitions, or the error:

```text
The user changed '/Applications/Vivaldi.app'. Re-query the latest state…
```

Prefer accessibility targets over fixed coordinates. Coordinates from the original exercise are not portable across window sizes, side panels, zoom levels, or fitted video modes.

## GLKVM settings

The exercise observed these settings before optimization:

### Video

- Mode: Smart
- Latency Mode: Lowest Latency
- Quality: Lossless
- Transfer: Direct
- Orientation: 0°
- EDID: `2560x1664/AOC/50Hz`
- View: Original Pixel
- Screen Privacy: off

### Remote device

- Keyboard: on
- Bad Link Mode: off
- Show Virtual Keyboard: off
- Swap Command and Ctrl for MacOS: on
- Mouse: on
- Show Local Cursor: off
- Mouse Jiggle: off
- Scroll Rate: 5
- Scroll Direction: Standard
- Mouse Mode: Relative
- Relative Sensitivity: 1
- Primary Button: Left

### System

- Device Identity: Customize
- Language: English

For reliable agent control, change only these high-impact settings when available:

1. Set Mouse Mode to **Absolute**. Relative mode requires pointer lock and made coordinate clicks unreliable.
2. Enable **Show Local Cursor**.
3. Enable **Show Virtual Keyboard** so Windows and system combinations can bypass macOS/Vivaldi interception.
4. Change View from **Original Pixel** to a fitted or scaled-to-window mode to avoid hidden horizontal regions and coordinate drift.
5. Keep Keyboard, Mouse, and Swap Command/Ctrl for MacOS enabled.
6. Keep Bad Link Mode and Mouse Jiggle disabled unless an unstable network or sleep prevention creates a specific need.

Hide Vivaldi side panels when possible to maximize the remote viewport.

## Input failure modes

The first click inside the remote canvas can enter pointer lock and display `Press Escape to exit pointer lock`. Under Relative mode, an automation click may move the remote pointer without activating the intended control. Repeated coordinate clicking can open the wrong Windows application.

When input becomes unreliable:

1. Stop issuing clicks.
2. Refresh Vivaldi application state.
3. Confirm the GLKVM window and remote canvas are active.
4. Exit pointer lock if necessary.
5. Open GLKVM settings and choose Absolute mouse mode.
6. Enable the local cursor and fitted view.
7. Focus the canvas again and test one harmless interaction.

Keyboard input was more reliable after focusing the canvas. Prefer the Windows Start search and terminal commands. Direct macOS/browser system shortcuts such as Alt-Tab were intercepted inconsistently; use GLKVM's virtual keyboard for those combinations.

## Windows and Docker operations

The tested terminal-launch flow was:

1. Focus the remote canvas.
2. Open Windows Start.
3. Type `powershell`.
4. Press Return.
5. Verify that PowerShell is active before entering commands.

Inspect containers before changing them:

```powershell
docker ps -a
```

The exercise recovered Redis with:

```powershell
docker start flex-redis
docker ps -a
docker exec flex-redis redis-cli ping
```

The final verification returned `PONG`. Cosmos appeared as `flex-cosmos`. Treat those observations as historical: re-run the inspection commands on every new session.

## Completion checks

Before reporting success, record:

- GLKVM connection and stream health
- Active Windows application or terminal
- Container names and states from fresh output
- Exact verification commands and results
- Any GLKVM settings changed
- Any approval prompts accepted or rejected
- Any state that could not be independently verified
