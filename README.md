# Famicom Clovercon Fix

Hakchi CE module for the **Famicom Mini or Shonen Jump firmware running on NES or SNES Classic hardware**. It fixes controllers that stop responding and the home menu freezing or going into a loop.

## The problem

The Famicom Mini and the Shonen Jump edition have wired controllers, so their firmware sets `boardtype=dp-hvc`. Hakchi's `S78clvcon` reads that value and loads the `clovercon` driver without controller detect lines (`module_params=1,-1,2,-1`).

The NES and SNES Classic have detachable controllers, whose detect lines are on GPIO 195/194. Without them both ports are always registered, even when nothing is plugged in. This produces a phantom controller 2 and constant I2C polling of empty ports, and the stock UI stops responding.

Hakchi only catches this case when the stock kernel (the backup in sector 68) is marked `hardwired controllers` in `/etc/firmwaredb`. When the hardware is an NES or SNES Classic, the backup is that console's own kernel, which has no such note.

## What the module does

It installs `/etc/init.d/S77clvcon_detect`, which runs before hakchi's `S78clvcon`. It only acts if **every** check below passes:

| Check | Value |
| --- | --- |
| The firmware is a Famicom one | `$squashfs/etc/issue` contains `dp-hvc` (Famicom Mini `dp-hvc-*`, Shonen Jump `dp-hvcj-*`) |
| The firmware expects wired controllers | `$squashfs/etc/clover/boardtype` = `dp-hvc` |
| The hardware is an NES/SNES Classic | the stock kernel (sector 68) is in `/etc/firmwaredb` as `dp-nes-*` or `dp-shvc-*` |

When all three pass, it loads `clovercon` with `module_params=1,195,2,194` and keeps the `cfg_clovercon_*` settings (home combination, autofire, `fc_start`). `S78clvcon` then sees that the module is already loaded and does nothing.

If any check fails, the script exits without doing anything and `S78clvcon` loads the driver as usual. This covers:

- NES/SNES Classic with their own firmware
- a real Famicom Mini or Shonen Jump (their kernel is `dp-hvc-*`)
- a stock kernel that isn't in `firmwaredb`

## Requirements

- Hakchi CE with the madmonkey kernel (the one that provides `S78clvcon` and `clovercon.ko`)
- Famicom Mini or Shonen Jump firmware installed on an NES or SNES Classic

## Install

1. Build the `.hmod` (see below) or download it from the releases.
2. In Hakchi2 CE: **Kernel → Install/uninstall modules → Add more mods**, choose `famicom_clovercon_fix.hmod` and install. It replaces the older `shonen_jump_clovercon_fix` module if that one is installed.
3. Reboot the console.

To check over SSH:

```sh
cat /sys/module/clovercon/parameters/module_params   # 1,195,2,194
```

## Build

From Git Bash, WSL or Linux:

```sh
./build.sh
```

The file is written to `out/famicom_clovercon_fix.hmod`.

## RetroArch shortcut

The firmware's emulator wrappers, as installed by the RetroArch hmod, read the controller state when a game is launched:

- **Hold Down** (tap A to launch, keep holding Down): opens the game in RetroArch
- **Hold Up**: opens the game in the stock emulator

The wrappers compare the exact value, so A+Down held together doesn't work. A must be released while Down stays held.

## License

GPLv3 or later — see [LICENSE](LICENSE).
