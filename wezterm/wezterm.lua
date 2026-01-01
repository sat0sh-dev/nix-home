-- WezTerm configuration (managed by nix-home)
local wezterm = require 'wezterm'

return {
  -- ========== Clipboard Integration ==========
  -- Enable OSC 52 for SSH clipboard sharing
  -- This allows copying from remote tmux sessions to local macOS clipboard
  enable_osc52_clipboard = true,

  -- ========== Font Settings ==========
  font_size = 14.0,

  -- ========== Color Scheme ==========
  -- Popular options: "Tokyo Night", "Dracula", "Catppuccin", "Nord"
  color_scheme = "Tokyo Night",

  -- ========== Window Settings ==========
  -- Window appearance
  window_decorations = "RESIZE",  -- macOS native title bar
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },

  -- Initial window size
  initial_cols = 120,
  initial_rows = 40,

  -- ========== Tab Bar ==========
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,  -- macOS-style tabs

  -- ========== Scrollback ==========
  scrollback_lines = 10000,

  -- ========== Performance ==========
  -- GPU acceleration
  front_end = "WebGpu",
  max_fps = 120,

  -- ========== Keybindings ==========
  keys = {
    -- Split panes (similar to tmux)
    { key = '|', mods = 'CMD|SHIFT', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '_', mods = 'CMD|SHIFT', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Close pane
    { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentPane { confirm = true } },

    -- Navigate panes
    { key = 'h', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'CMD|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down' },
  },

  -- ========== Mouse ==========
  -- Enable mouse support
  mouse_bindings = {
    -- Open links on Cmd+Click
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CMD',
      action = wezterm.action.OpenLinkAtMouseCursor,
    },
  },

  -- ========== Miscellaneous ==========
  -- Automatically reload config when it changes
  automatically_reload_config = true,

  -- Disable bell
  audible_bell = 'Disabled',

  -- Default shell (uses login shell)
  -- default_prog = { '/bin/zsh', '-l' },
}
