local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- ===========================================
-- Theme & Colors (High Contrast)
-- ===========================================
config.color_scheme = 'GitHub Dark High Contrast'
config.window_background_opacity = 1.0

-- ===========================================
-- Typography
-- ===========================================
config.font = wezterm.font('MesloLGS Nerd Font', { weight = 'Regular' })
config.font_size = 14.5
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }  -- Disable ligatures

-- ===========================================
-- Window
-- ===========================================
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Start maximized
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- ===========================================
-- Tab Bar (minimal)
-- ===========================================
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false

-- High contrast tab colors
config.colors = {
  tab_bar = {
    background = '#0a0c10',
    active_tab = {
      bg_color = '#f0f3f6',
      fg_color = '#0a0c10',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = '#272b33',
      fg_color = '#9ea7b3',
    },
    inactive_tab_hover = {
      bg_color = '#3d444d',
      fg_color = '#f0f3f6',
    },
  },
}

-- ===========================================
-- tmux Integration
-- ===========================================
-- Allow Cmd keys to pass through to tmux
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- ===========================================
-- Keybindings
-- ===========================================
config.keys = {
  -- iTerm2-style pane splits
  { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = 'd', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Cmd+R: rename tab
  { key = 'r', mods = 'CMD', action = act.PromptInputLine {
    description = 'Enter new tab name',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},

  -- Line editing
  { key = 'LeftArrow', mods = 'CMD', action = act.SendKey { key = 'a', mods = 'CTRL' } },
  { key = 'RightArrow', mods = 'CMD', action = act.SendKey { key = 'e', mods = 'CTRL' } },
  { key = 'Backspace', mods = 'CMD', action = act.SendKey { key = 'u', mods = 'CTRL' } },
  { key = 'Backspace', mods = 'OPT', action = act.SendKey { key = 'w', mods = 'CTRL' } },
  { key = 'LeftArrow', mods = 'OPT', action = act.SendKey { key = 'b', mods = 'ALT' } },
  { key = 'RightArrow', mods = 'OPT', action = act.SendKey { key = 'f', mods = 'ALT' } },
  { key = 'Enter', mods = 'OPT', action = act.SendKey { key = 'Enter', mods = 'ALT' } },
  { key = 'Enter', mods = 'SHIFT', action = act.SendKey { key = 'Enter', mods = 'ALT' } },

  -- Pane Navigation
  { key = 'LeftArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Down' },

  -- Pane management
  { key = 'w', mods = 'CMD', action = act.CloseCurrentPane { confirm = true } },
  { key = 'z', mods = 'CMD', action = act.TogglePaneZoomState },

  -- Tab switching
  { key = '[', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD|SHIFT', action = act.ActivateTabRelative(1) },

  -- Cmd+1-9: Switch to tab by number
  { key = '1', mods = 'CMD', action = act.ActivateTab(0) },
  { key = '2', mods = 'CMD', action = act.ActivateTab(1) },
  { key = '3', mods = 'CMD', action = act.ActivateTab(2) },
  { key = '4', mods = 'CMD', action = act.ActivateTab(3) },
  { key = '5', mods = 'CMD', action = act.ActivateTab(4) },
  { key = '6', mods = 'CMD', action = act.ActivateTab(5) },
  { key = '7', mods = 'CMD', action = act.ActivateTab(6) },
  { key = '8', mods = 'CMD', action = act.ActivateTab(7) },
  { key = '9', mods = 'CMD', action = act.ActivateTab(8) },

  -- Command palette
  { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },

  -- Pane rotation/swapping
  { key = '[', mods = 'CTRL|SHIFT', action = act.RotatePanes 'CounterClockwise' },
  { key = ']', mods = 'CTRL|SHIFT', action = act.RotatePanes 'Clockwise' },
  { key = 's', mods = 'CTRL|SHIFT', action = act.PaneSelect { mode = 'SwapWithActive' } },
}

return config
