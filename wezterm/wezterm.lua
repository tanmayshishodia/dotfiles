local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

-- ===========================================
-- Plugins
-- ===========================================
local tabline = wezterm.plugin.require 'https://github.com/michaelbrusegard/tabline.wez'
local resurrect = wezterm.plugin.require 'https://github.com/MLFlexer/resurrect.wezterm'
local workspace_switcher = wezterm.plugin.require 'https://github.com/MLFlexer/smart_workspace_switcher.wezterm'

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
-- Tab Bar (using tabline plugin)
-- ===========================================
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 32

tabline.setup({
  options = {
    theme = {
      normal_mode = { a = { fg = '#0a0c10', bg = '#f0f3f6' }, b = { fg = '#f0f3f6', bg = '#272b33' }, c = { fg = '#9ea7b3', bg = '#0a0c10' } },
      tab = { active = { fg = '#0a0c10', bg = '#f0f3f6' }, inactive = { fg = '#9ea7b3', bg = '#272b33' } },
    },
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    tab_separators = { left = '', right = '' },
  },
  sections = {
    tabline_a = { 'workspace' },
    tabline_b = {},
    tabline_c = {},
    tab_active = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = {},
    tabline_y = { 'datetime' },
    tabline_z = { 'hostname' },
  },
})
tabline.apply_to_config(config)

-- Ensure tab bar always shows (after tabline plugin)
config.hide_tab_bar_if_only_one_tab = false

-- ===========================================
-- Session Management (resurrect)
-- ===========================================
resurrect.periodic_save({ interval_seconds = 300 })

-- ===========================================
-- Workspace Switcher (with zoxide)
-- ===========================================
workspace_switcher.zoxide_path = '/opt/homebrew/bin/zoxide'

-- ===========================================
-- tmux Integration
-- ===========================================
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- ===========================================
-- Cursor & Scrolling
-- ===========================================
config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate = 500
config.scrollback_lines = 10000
config.enable_scroll_bar = false

-- ===========================================
-- Performance
-- ===========================================
config.front_end = 'WebGpu'
config.webgpu_power_preference = 'HighPerformance'
config.animation_fps = 60
config.max_fps = 120

-- ===========================================
-- Quick Select (like tmux-fingers)
-- ===========================================
config.quick_select_patterns = {
  -- Git hashes
  '[0-9a-f]{7,40}',
  -- URLs
  'https?://[^\\s]+',
  -- File paths
  '[\\w\\-./]+\\.[a-zA-Z]{2,4}',
  -- UUIDs
  '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
}

-- ===========================================
-- Keybindings
-- ===========================================
config.leader = { key = 'a', mods = 'CMD', timeout_milliseconds = 1000 }

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

  -- Pane Navigation (vim-style with Cmd+Shift)
  { key = 'h', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Down' },
  -- Also keep arrow keys
  { key = 'LeftArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Down' },

  -- Pane resizing
  { key = 'h', mods = 'CMD|CTRL', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'l', mods = 'CMD|CTRL', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'k', mods = 'CMD|CTRL', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'j', mods = 'CMD|CTRL', action = act.AdjustPaneSize { 'Down', 5 } },

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

  -- Quick select mode (like tmux-fingers)
  { key = 'f', mods = 'CMD|SHIFT', action = act.QuickSelect },

  -- Copy mode (vim-style selection)
  { key = 'v', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Workspace switcher (with zoxide integration)
  { key = 's', mods = 'CMD|SHIFT', action = workspace_switcher.switch_workspace() },

  -- Session management (Cmd+A then S to save, Cmd+A then R to restore)
  { key = 's', mods = 'LEADER', action = wezterm.action_callback(function(win, pane)
    resurrect.save_state(resurrect.workspace_state.get_workspace_state())
  end) },
  { key = 'r', mods = 'LEADER', action = wezterm.action_callback(function(win, pane)
    resurrect.fuzzy_load(win, pane, function(id)
      local state = resurrect.load_state(id, 'workspace')
      resurrect.workspace_state.restore_workspace(state, {
        relative = true,
        restore_text = true,
      })
    end)
  end) },

  -- Pane rotation/swapping
  { key = '[', mods = 'CTRL|SHIFT', action = act.RotatePanes 'CounterClockwise' },
  { key = ']', mods = 'CTRL|SHIFT', action = act.RotatePanes 'Clockwise' },
  { key = 'Space', mods = 'LEADER', action = act.PaneSelect { mode = 'SwapWithActive' } },

  -- Debug overlay
  { key = 'L', mods = 'CTRL|SHIFT', action = act.ShowDebugOverlay },
}

-- ===========================================
-- Mouse bindings
-- ===========================================
config.mouse_bindings = {
  -- Cmd+Click to open URLs
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = act.OpenLinkAtMouseCursor,
  },
}

return config
