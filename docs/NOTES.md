# FFXI Addon — Furrow

> [!NOTE]
> **Quick Reference**
> - **Path:** `C:\Windower\addons\Furrow\`
> - **Author / Version:** Algar (forked/modified by Kevin `gimlic1`) / `1.3`
> - **Commands:** `//furrow`
> - **Load Status:** On-Demand
> - **Origin:** Custom / Modified (`https://github.com/gimlic1/Furrow.git`, branch `master`, with uncommitted local changes)

Mog Garden automation script that plants Revival Roots, harvests unlocked Garden Furrows on a 1-hour loop, and (via Kevin's local edits) sells junk to the Green Thumb Moogle.

## What the Code Does
`Furrow.lua` automates Mog Garden chores using `TAB` target cycling, `/item "Revival Root" <t>`, and `setkey` (`enter`/`down`/`escape`) menu navigation with `coroutine.sleep` delays:
- **Furrow Targeting (`target1()`–`target3()`):** Presses `TAB` until `'t'` matches `"Garden Furrow"`, `"Garden Furrow #2"`, or `"Garden Furrow #3"`.
- **Cycles (`plantcycle()`, `harvestcycle()`, `loop()`):** Calls `Check_KI()` to determine how many furrows to service, plants or harvests each unlocked furrow, and in `loop()` sleeps `3600` seconds (printing 10-minute reminders) between planting and harvesting before recursing.
- **Abort/Stop:** Reloads the addon (`lua reload furrow`) to interrupt sleeping coroutines.

## Commands & Usage
- `//furrow start` — Start the continuous plant → sell junk → wait 60m → harvest loop.
- `//furrow plant` — Run a single planting cycle across unlocked furrows.
- `//furrow harvest` — Run a single harvesting cycle across unlocked furrows.
- `//furrow ki` — Run `Check_KI()` to refresh unlocked furrow count.
- `//furrow sell` — *(Local addition)* Target Green Thumb Moogle and run `Sell_junk()`.
- `//furrow stop` / `//furrow abort` — Reload the addon to cancel active loops.
- `//furrow help` — Print command summary *(does not list `ki` or `sell`)*.

## Events, Packets & Technical Hooks
- **Windower Events:** `addon command`
- **Packets:** None (keyboard simulation via `setkey` + `windower.chat.input`)
- **Dependencies / Libraries:** `logger`, `coroutine`; `Sell_junk()` invokes `//sellnpc junk` (SellNPC addon)

## Local Settings & Customizations
Kevin's fork (`gimlic1/Furrow`) plus uncommitted working-tree edits in `Furrow.lua`:
1. **`Check_KI()` (committed in fork):** Scans `windower.ffxi.get_key_items()` for key item IDs `2413` (2nd furrow) and `2415` (3rd furrow) to set `Furrows_unlocked` (`1`, `2`, or `3`) automatically, plus `//furrow ki`.
2. **`target4()` & `Sell_junk()` (uncommitted):**
   - `target4()` cycles `TAB` until `"Green Thumb Moogle"` is targeted.
   - `Sell_junk()` calls `target4()`, runs `//sellnpc junk`, waits `2s`, then presses `enter` → `down` → `enter` → `enter` → `escape` → `escape` to confirm the vendor dialog and close menus.
   - Hooked into `//furrow sell` and called inside `loop()` immediately after `plantcycle()` (where `loop()` restores `running = true` afterward because `plantcycle()` sets `running = false`).
3. **Target-nil recovery (uncommitted):** `target1()`, `target2()`, and `target3()` now sleep `5s` (up from `0.1s`) and tap `escape` before retrying when `get_mob_by_target('t') == nil`, matching `target4()`.

## Related Notes
- `FFXI Windower Overview`
- `FFXI Windower Addons Catalog`
