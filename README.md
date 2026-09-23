# InfiniteMatcha

Infinite Yield rebuilt for the Matcha Lua VM. Same idea, different engine: a typed command bar over the Drawing library, 83 commands, no Instance.new anywhere.

## Load

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/OWNER/InfiniteMatcha/main/InfiniteMatcha.lua"))()
```

Press RightShift to toggle the bar. Prefix is `;`.

## Feature status

### Works

- Movement: fly, noclip, infjump, spin, goto, tp, spawn, bring (client side)
- Aimbot: camera steering toward the nearest head, fov and team toggles, clickaim bind
- ESP: boxes, tracers, names, distances, two-loop renderer with a fixed pool, team check
- Speed via the gc scanner (getgc/setgc), unspeed to reset
- Camera: view, unview, fov
- Server tools: remotes list, serverbrowser, copyjob, hop attempt
- Chat log: pulls text out of PlayerGui TextLabels
- Config: saveprefs/loadprefs, prefix change, binds, admins, banlist
- Utility: copypos, copyname, serverinfo, age, displayname, userid, team, ping, getreg, charinfo, partcount
- Command bar UI: suggestions, Tab complete, history with Up/Down, hint bar via ;cmds

### Impossible on this VM

- Anything needing Instance.new: Highlight/BoxHandleAdornment chams, fake GUI, cloning tools, bringing players' real bodies, GravityScale-based features
- ClickDetector-style features (clicktp still works, it raycasts instead)
- Real chat (no chat ui writable, no TextChatService calls)
- TeamColor/Neutral, AccountAge, DisplayName readable but TeamColor etc are not on the property whitelist
- Fullbright: the vm cannot write Lighting properties, the command tells you so
- walkspeed as a property: not on the whitelist, hence the gc scanner approach
- Signals on instances: no CharacterAdded, no Died, so join detection polls instead

### Hybrid mode

Remote commands (remotes list, fireservercheck, hop) need **hybrid mode on** in the Matcha menu. The script detects nothing itself; Matcha gates FireServer at runtime. If fireservercheck passes, you have it enabled. FireServer/InvokeServer exist as functions with hybrid off but throw when called.

## Notes

- The bar is Drawings, not game GUI, so it stays invisible to the game and to other clients
- ;exit or ;unload restores camera, fov, collision and removes every Drawing
- loadstring return values are broken on this executor, so the script never relies on them
- The gc scanner is a full heap scan; speed/getreg run it once per call, keep it out of hot loops
- Menu toggle defaults to RightShift, change with ;setkey menu <key>
