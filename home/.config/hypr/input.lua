-- Keep only your input overrides here. Uncommented settings below
-- replace Omarchy's defaults.

-- Keyboard layout and options.
hl.config({ input = { kb_layout = "us,ru", kb_variant = ",mac" } })

-- Click with a light tap instead of physically pressing the touchpad.
hl.config({ input = { touchpad = { tap_to_click = true } } })

-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input
-- hl.config({
--   input = {
--     -- Use multiple keyboard layouts and switch between them with Left Alt + Right Alt.
--     kb_layout = "us,dk,eu",
--     kb_options = "compose:caps,shift:both_capslock_cancel,grp:alts_toggle",
--
--     -- Use a specific keyboard variant if needed (e.g. intl for international keyboards).
--     kb_variant = "intl",
--
--     -- Change speed of keyboard repeat.
--     repeat_rate = 40,
--     repeat_delay = 250,
--
--     -- Start with numlock on by default.
--     numlock_by_default = true,
--
--     -- Increase sensitivity for mouse/trackpad (default: 0).
--     sensitivity = 0.35,
--
--     -- Turn off mouse acceleration (default: adaptive).
--     accel_profile = "flat",
--
--     touchpad = {
--       -- Use traditional (non-inverse) scrolling.
--       natural_scroll = false,
--
--       -- Re-enable tap-to-click (one-finger tap = left, two-finger = right).
--       tap_to_click = true,
--
--       -- Use two-finger clicks for right-click instead of lower-right corner.
--       clickfinger_behavior = true,
--
--       -- Control the speed of your scrolling.
--       scroll_factor = 0.4,
--
--       -- Enable the touchpad while typing.
--       disable_while_typing = false,
--
--       -- Left-click-and-drag with three fingers.
--       drag_3fg = 1,
--     },
--   },
-- })

-- App-specific touchpad scroll speeds.
-- o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
-- o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })

-- Enable touchpad gestures for changing workspaces.
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Gestures/
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

-- Enable touchpad gestures for moving focus (helpful on scrolling layout).
-- hl.gesture({ fingers = 3, direction = "left", action = function() hl.dispatch(hl.dsp.focus({ direction = "l" })) end })
-- hl.gesture({ fingers = 3, direction = "right", action = function() hl.dispatch(hl.dsp.focus({ direction = "r" })) end })

-- BEGIN omarchy-mac-keybinding
hl.config({
  input = {
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
      tap_and_drag = true,
      drag_lock = 1,
      clickfinger_behavior = true,
      scroll_factor = 0.4,
    },
  },
})

-- The user's input.lua already configures four-finger workspace swipes.
-- Keep that setting without adding a three-finger gesture.

-- Launchpad-like Apps view and an Omarchy-native Expose alternative.
hl.gesture({
  fingers = 4,
  direction = "up",
  action = function() hl.exec_cmd("omarchy-menu toggle apps") end,
})
hl.gesture({
  fingers = 4,
  direction = "down",
  action = "special",
  workspace_name = "scratchpad",
})
-- END omarchy-mac-keybinding

-- Three-finger swipes open and close the Noctalia panel.
hl.gesture({ fingers = 3, direction = "left", action = function() hl.exec_cmd("noctalia msg panel-open control-center") end })
hl.gesture({ fingers = 3, direction = "right", action = function() hl.exec_cmd("noctalia msg panel-close control-center") end })
