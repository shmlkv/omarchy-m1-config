-- Command stays SUPER; Control and Option keep their native meanings.
-- Explicit key-up events follow Omarchy's clipboard workaround.
local queue, sending = {}, false
-- XKB keycodes are layout-independent: symbolic key names can fail with alternate layouts.
local keycodes = {
  A=38, B=56, C=54, D=40, F=41, K=45, L=46, N=57, O=32,
  P=33, R=27, S=39, T=28, U=30, V=55, W=25, X=53, Z=52,
  Home=110, End=115, Left=113, Right=114, Up=111, Down=116,
  BackSpace=22, Delete=119, Insert=118,
}
local function physical(chord)
  if chord[2] == "underscore" then return chord[1] .. " SHIFT", "code:20" end
  local code = keycodes[chord[2]]
  return chord[1], code and ("code:" .. code) or chord[2]
end

local function terminal()
  local window = hl.get_active_window()
  for _, tag in ipairs(window and window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then return true end
  end
  return false
end

local function address()
  local window = hl.get_active_window()
  return window and window.address
end

local function drain()
  if sending or #queue == 0 then return end
  local job = table.remove(queue, 1)
  if job.address ~= address() then return drain() end
  sending = true
  local step = 1
  local function next_key()
    -- Do not deliver the deletion half of a sequence to another window.
    if job.address ~= address() or step > #job.keys then
      sending = false
      return drain()
    end
    local chord = job.keys[step]
    local mods, key = physical(chord)
    local ok = pcall(function()
      hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
    end)
    if not ok then
      sending = false
      return drain()
    end
    hl.timer(function()
      pcall(function()
        hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
      end)
      step = step + 1
      next_key()
    end, { timeout = 50, type = "oneshot" })
  end
  next_key()
end

local function send(keys)
  queue[#queue + 1] = { address = address(), keys = keys }
  drain()
end

local function bind(chord, description, gui, term)
  hl.unbind(chord)
  local callback = function() send(terminal() and term or gui) end
  o.bind(chord, description, callback)
end

-- Override the existing clipboard bindings too: they used Latin key names.
bind("SUPER + C", "Mac: copy", {{"CTRL", "C"}}, {{"CTRL", "Insert"}})
bind("SUPER + V", "Mac: paste", {{"CTRL", "V"}}, {{"SHIFT", "Insert"}})
bind("SUPER + X", "Mac: cut", {{"CTRL", "X"}}, {})
bind("SUPER + A", "Mac: select all (shell: line start)", {{"CTRL", "A"}}, {{"CTRL", "A"}})
bind("SUPER + Z", "Mac: undo", {{"CTRL", "Z"}}, {{"CTRL", "underscore"}})
bind("SUPER + SHIFT + Z", "Mac: redo", {{"CTRL SHIFT", "Z"}}, {})
bind("SUPER + SHIFT + V", "Mac: paste without formatting", {{"CTRL SHIFT", "V"}}, {{"SHIFT", "Insert"}})

hl.unbind("SUPER + BACKSPACE")
o.bind("SUPER + BACKSPACE", "Mac: delete line prefix / move file to trash", function()
  local window = hl.get_active_window()
  local class = window and window.class or ""
  if terminal() then
    send({{"CTRL", "U"}})
  elseif class == "org.kde.dolphin" or class == "dolphin" or class == "org.gnome.Nautilus" then
    -- Native Delete moves selected files to trash; text fields handle it locally.
    send({{"", "Delete"}})
  else
    send({{"SHIFT", "Home"}, {"", "BackSpace"}})
  end
end)
bind("SUPER + DELETE", "Mac: delete to line end", {{"SHIFT", "End"}, {"", "BackSpace"}}, {{"CTRL", "K"}})
bind("ALT + BACKSPACE", "Mac: delete previous word", {{"CTRL", "BackSpace"}}, {{"CTRL", "W"}})
bind("ALT + DELETE", "Mac: delete next word", {{"CTRL", "Delete"}}, {{"ALT", "D"}})

bind("SUPER + LEFT", "Mac: line start", {{"", "Home"}}, {{"", "Home"}})
bind("SUPER + RIGHT", "Mac: line end", {{"", "End"}}, {{"", "End"}})
bind("SUPER + SHIFT + LEFT", "Mac: select to line start", {{"SHIFT", "Home"}}, {})
bind("SUPER + SHIFT + RIGHT", "Mac: select to line end", {{"SHIFT", "End"}}, {})
bind("SUPER + UP", "Mac: document start", {{"CTRL", "Home"}}, {{"CTRL SHIFT", "Home"}})
bind("SUPER + DOWN", "Mac: document end", {{"CTRL", "End"}}, {{"CTRL SHIFT", "End"}})
bind("SUPER + SHIFT + UP", "Mac: select to document start", {{"CTRL SHIFT", "Home"}}, {})
bind("SUPER + SHIFT + DOWN", "Mac: select to document end", {{"CTRL SHIFT", "End"}}, {})
bind("ALT + LEFT", "Mac: previous word", {{"CTRL", "Left"}}, {{"ALT", "B"}})
bind("ALT + RIGHT", "Mac: next word", {{"CTRL", "Right"}}, {{"ALT", "F"}})
bind("ALT + SHIFT + LEFT", "Mac: select previous word", {{"CTRL SHIFT", "Left"}}, {{"ALT SHIFT", "Left"}})
bind("ALT + SHIFT + RIGHT", "Mac: select next word", {{"CTRL SHIFT", "Right"}}, {{"ALT SHIFT", "Right"}})

-- GUI-only commands are no-ops in terminals: forwarding Super+letter can
-- insert a literal letter in Foot. Never send Ctrl+S (flow control) here.
for _, entry in ipairs({
  {"F", "find"}, {"S", "save"}, {"O", "open"}, {"N", "new"},
  {"L", "address bar"}, {"T", "new tab"}, {"P", "print"},
}) do
  local key, description = entry[1], entry[2]
  local term = key == "F" and {{"CTRL SHIFT", "R"}} or {}
  bind("SUPER + " .. key, "Mac: " .. description, {{"CTRL", key}}, term)
end
bind("SUPER + SHIFT + T", "Mac: reopen closed tab", {{"CTRL SHIFT", "T"}}, {})
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Mac: close tab (terminal: close window)", function()
  if terminal() then
    hl.dispatch(hl.dsp.window.close())
  else
    send({{"CTRL", "W"}})
  end
end)

-- Additional standard application shortcuts.
bind("SUPER + R", "Mac: reload", {{"CTRL", "R"}}, {})
bind("SUPER + SHIFT + R", "Mac: reload without cache", {{"CTRL SHIFT", "R"}}, {})
bind("SUPER + SHIFT + S", "Mac: save as", {{"CTRL SHIFT", "S"}}, {})
bind("SUPER + SHIFT + N", "Mac: new folder / private window", {{"CTRL SHIFT", "N"}}, {})
