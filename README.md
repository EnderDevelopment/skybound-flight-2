# Roblox Flight Ability Script

Skybound Flight is a Roblox flight ability script for an experience you own. This Roblox script includes a client flight controller and a server toggle handler, with camera-relative WASD movement, vertical controls, flight state tracking, and a toggle cooldown.

## Install

1. Open your Roblox experience in Roblox Studio.
2. In `ServerScriptService`, create a `Script` named `ServerScript`.
3. Paste the contents of `ServerScript.lua` into the server script.
4. In `StarterPlayer > StarterPlayerScripts`, create a `LocalScript` named `ClientScript`.
5. Paste the contents of `ClientScript.lua` into the local script.
6. Start a play test in Roblox Studio.
7. The server script automatically creates the `FlightToggle` RemoteEvent in `ReplicatedStorage`.

## Use

1. Press `F` to start or stop flying.
2. Use `W`, `A`, `S`, and `D` to move relative to the camera.
3. Hold `Space` to rise.
4. Hold `LeftControl` to descend.
5. Change the `SPEED` value in `ClientScript.lua` to adjust flight speed.
6. Read the player’s `FlightEnabled` attribute from server scripts if your experience needs to check the current flight state.
7. Add any game-specific permission checks to `ServerScript.lua` before accepting flight toggles.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/a1bbb614-42b4-4cf2-b557-f583df8436d1?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=a1bbb614-42b4-4cf2-b557-f583df8436d1
