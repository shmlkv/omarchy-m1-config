-- Keep only your keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- Cmd/Super+Space switches keyboard layouts.
hl.unbind("SUPER + SPACE")
o.bind("SUPER + SPACE", "Switch keyboard language", "hyprctl switchxkblayout all next")

-- Full Go menu.
o.bind("F4", "Go menu", "omarchy-menu toggle root")
-- Apple keyboards emit XF86LaunchB for the F4/Launchpad key without Fn.
o.bind("XF86LaunchB", "Go menu", "omarchy-menu toggle root")
-- Newer Apple keyboards use the Spotlight/Search key instead.
o.bind("XF86Search", "Go menu", "omarchy-menu toggle root")

-- Option/Alt+1 selects a screenshot region and saves it directly to Pictures.
o.bind("ALT + 1", "Save screenshot region", "omarchy capture screenshot region save")

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- BEGIN omarchy-mac-keybinding
-- Display MacBook modifier names in the keybindings menu. Display only:
-- Hyprland still receives Command as SUPER, Option as ALT, and Control as CTRL.
hl.unbind("SUPER + K")
o.bind("SUPER + K", "Keybindings", "~/.local/bin/omarchy-menu-keybindings-mac")

-- macOS-style editing and navigation, with terminal-specific handling.
dofile(os.getenv("HOME") .. "/.config/hypr/mac-editing.lua")
-- END omarchy-mac-keybinding

-- Option+T opens Telegram.
o.bind("ALT + T", "Telegram", { launch = "Telegram" })

-- Consume physical Caps Lock (normally Compose) for local dictation.
o.bind("Multi_key", "Toggle local dictation", "~/.local/bin/voxtype record toggle")

-- Noctalia widget panel.
o.bind("ALT + N", "Noctalia widgets", "noctalia msg panel-toggle control-center")
