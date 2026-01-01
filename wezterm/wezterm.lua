-- WezTerm configuration (managed by nix-home)
local wezterm = require 'wezterm'

return {
  -- ========== Clipboard Integration ==========
  -- OSC 52 is enabled by default in WezTerm
  -- This allows copying from remote tmux sessions to local macOS clipboard

  -- ========== Font Settings ==========
  -- Source Han Code JP: Adobe's programming font with complete Japanese support
  font = wezterm.font('Source Han Code JP R'),  -- R = Regular weight
  font_size = 14.0,

  -- ========== Color Scheme ==========
  -- Popular options: "Tokyo Night", "Dracula", "Catppuccin Mocha", "Nord", "One Dark"
  color_scheme = "Catppuccin Mocha",

  -- ========== Window Settings ==========
  -- Window appearance
  window_decorations = "TITLE | RESIZE",  -- macOS native title bar with resize
  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },

  -- Background transparency
  window_background_opacity = 0.80,  -- 0.0 (transparent) to 1.0 (opaque)
  macos_window_background_blur = 10,  -- macOS blur effect
  native_macos_fullscreen_mode = false,  -- Keep transparency in fullscreen

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
