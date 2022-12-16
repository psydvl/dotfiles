local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  _, _ = tab, pane
  window:gui_window():maximize()
end)

local mykeys = {}
for i = 1, 8 do
  -- ALT + number to activate that tab
  table.insert(mykeys, {
    key = tostring(i),
    mods = 'ALT',
    action = act.ActivateTab(i - 1),
  })
  -- F1 through F8 to activate that tab
  table.insert(mykeys, {
    key = 'F' .. tostring(i),
    action = act.ActivateTab(i - 1),
  })
end
-- Ctrl+F2 to make tab overflow
table.insert(mykeys, {
  key = 'F2',
  mods = 'CTRL',
  action = act.EmitEvent 'float-this-tab',
})

local isFloat = false
wezterm.on('float-this-tab', function(window, pane)
  _ = pane
  local overrides = window:get_config_overrides() or {}
  if not isFloat then
    overrides.window_background_opacity = 0.6
    isFloat = true
    window:restore()
  else
    overrides.window_background_opacity = 1.0
    isFloat = false
    window:maximize()
  end
  window:set_config_overrides(overrides)
end)

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  local index = ''
  if #tabs > 1 then
    index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
  end

  -- works with GNOME https://extensions.gnome.org/extension/4691/pip-on-top/
  local floating = ''
  if isFloat then
    floating = ' - PiP'
  end

  return index .. tab.active_pane.title .. floating
end)

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'Catppuccin Mocha'
  else
    return 'Catppuccin Latte'
  end
end

local function window_border_for_scheme(scheme)
  local color = wezterm.color.get_builtin_schemes()[scheme].foreground
  return {
    border_left_width = '2px',
    border_right_width = '1px',
    border_bottom_height = '2px',
    border_top_height = '2px',
    border_left_color = color,
    border_right_color = color,
    border_bottom_color = color,
    border_top_color = color,
  }
end

wezterm.on('window-config-reloaded', function(window, pane)
  _ = pane
  local overrides = window:get_config_overrides() or {}
  local appearance = window:get_appearance()
  local scheme = scheme_for_appearance(appearance)
  if overrides.color_scheme ~= scheme then
    overrides.color_scheme = scheme
    window:set_config_overrides(overrides)
  end
end)

local function build_config(appearance)
  local scheme = scheme_for_appearance(appearance)
  return {
    initial_cols = 40,
    initial_rows = 22,

    enable_wayland = true,
    xcursor_theme = 'Adwaita',

    color_scheme = scheme,

    window_background_opacity = 1.0,

    window_decorations = "RESIZE",
    window_frame = window_border_for_scheme(scheme),

    hide_tab_bar_if_only_one_tab = true,
    use_fancy_tab_bar = false,

    window_padding = {
      left = '5px',
      right = '5px',
      top = 0,
      bottom = 0,
    },
    enable_scroll_bar = true,

    keys = mykeys,
  }
end

return build_config(wezterm.gui.get_appearance())
