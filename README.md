# Omarchy M1 config

Personal Omarchy configuration for a MacBook Air M1: familiar Mac shortcuts, a Russian keyboard layout, touchpad gestures, and the full Go launcher. Configuration snapshot from September 17, 2026.

Built for Omarchy with Lua-based Hyprland configuration, used with Hyprland 0.56.2. This repository contains user settings, not a distribution or driver installer. It has not been tested on other machines.

## Shortcuts and gestures

| Action | Shortcut |
|---|---|
| Switch English / Russian Mac layout | Cmd+Space |
| Full Go menu | F4 / Apple Spotlight key |
| Select a region and save a screenshot | Option+1 |
| Shortcut list with Command/Option labels | Cmd+K |
| Emoji picker | Cmd+Ctrl+E or Emoji in Go |
| Telegram, if installed | Option+T |
| Local Voxtype dictation, if installed | Caps Lock / Compose |
| Noctalia panel, if installed | Option+N |
| Switch workspaces | Four-finger swipe left/right |
| Apps menu | Four-finger swipe up |
| Scratchpad | Four-finger swipe down |
| Open / close Noctalia | Three-finger swipe left/right |

Tap to click, tap-and-drag, natural scrolling, and two-finger right-click are enabled. The screensaver displays `shmlkv` with the standard Omarchy animation.

`mac-editing.lua` adds Cmd+C/V/X/A/Z, find, save, tab shortcuts, text navigation, and selection. Some actions behave differently or are disabled in terminals. Commands use physical keycodes so they also work with the Russian layout. These shortcuts replace some standard Omarchy window-management bindings; see the file for the full list.

## Contents

- `home/.config/hypr/`: input, gestures, shortcuts, text editing, autostart, and an example display configuration.
- `home/.config/omarchy/`: bar settings, the Emoji menu entry, and screensaver text.
- `home/.local/bin/omarchy-menu-keybindings-mac`: shortcut menu with Mac modifier labels.
- `home/.config/fontconfig/`: Apple Color Emoji and FiraCode Nerd Font preferences.
- `home/.config/noctalia/`: a companion panel with its extra bar and notification daemon disabled.
- `home/.config/voxtype/` and `home/.config/systemd/user/voxtype.service`: local dictation settings.
- `shell/codex-aliases.bash`: optional `x` and `ч` aliases for Codex.

## Applying the configuration

Compare these files with your own settings first. Do not copy the entire `home` directory over an existing profile: it includes personal preferences, and Noctalia and Voxtype require separate installations.

To apply the core keyboard and touchpad configuration, run from the repository root:

```bash
backup_dir="$HOME/.local/state/omarchy-m1-config/backups/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$backup_dir"
cp -a "$HOME/.config/hypr" "$backup_dir/hypr"
mkdir -p "$HOME/.local/bin"
if [ -e "$HOME/.local/bin/omarchy-menu-keybindings-mac" ]; then
  cp -a "$HOME/.local/bin/omarchy-menu-keybindings-mac" "$backup_dir/"
fi
cp home/.config/hypr/{bindings,input,mac-editing}.lua "$HOME/.config/hypr/"
install -m 755 home/.local/bin/omarchy-menu-keybindings-mac "$HOME/.local/bin/"
hyprctl reload
hyprctl configerrors
```

The standard `hyprland.lua` must load `hypr.input` and `hypr.bindings` after the Omarchy defaults. If errors occur, restore the previous files from the backup directory and run `hyprctl reload`.

Copy the remaining files selectively, backing up the corresponding settings first:

- **Display:** `monitors.lua` uses automatic Hyprland scaling and `GDK_SCALE=2`; the latter does not suit every display.
- **Noctalia:** requires a `noctalia` executable supporting `--daemon` and `msg panel-*`. Autostart is configured in `autostart.lua`. Without Noctalia, remove its shortcuts and three-finger gestures or leave those commands unused.
- **Voxtype:** requires `~/.local/bin/voxtype` and the local Whisper `small` model. The service uses `%h` instead of a user-specific home path. Once configured, run `systemctl --user daemon-reload` and `systemctl --user enable --now voxtype.service`. Without Voxtype, the Caps Lock binding cannot start dictation.
- **Emoji:** the picker is Omarchy's built-in `omarchy.emojis`. Fontconfig selects Apple Color Emoji when that font is available. The font is not distributed in this repository; install it separately if you have the right to use it. FiraCode Nerd Font is not included either.
- **Screensaver:** back up `~/.config/omarchy/branding/screensaver.txt`, then copy the supplied file. To generate your own text: `omarchy ascii "yourname" > ~/.config/omarchy/branding/screensaver.txt`.

## Optional Codex aliases

```bash
alias x='codex --dangerously-bypass-approvals-and-sandbox'
alias ч='codex --dangerously-bypass-approvals-and-sandbox'
```

Only add these to `~/.bashrc` intentionally: they disable Codex approvals and sandboxing. The Cyrillic `ч` occupies the same physical key as `x` on the Russian layout. These aliases are not applied automatically.

## Credits

The Mac preset base and menu wrapper come from [niraj-envision/omarchy-mac-keybinding](https://github.com/niraj-envision/omarchy-mac-keybinding), MIT, Copyright © 2026 Niraj Envision. Its license is preserved in `LICENSES/omarchy-mac-keybinding.txt`. Configuration templates originate from [Omarchy](https://github.com/omacom/omarchy); its license is included separately.

This snapshot excludes tokens, account credentials, SSH keys, command history, dictation models, program binaries, and font files. Bash syntax, JSON/TOML/XML formats, and the current Hyprland configuration were checked; deployment to another machine has not been tested.
