local wezterm = require("wezterm")
local act = wezterm.action

wezterm.on("update-right-status", function(window, pane)
  if window:leader_is_active() then
    window:set_right_status(" LEADER ")
  else
    window:set_right_status("")
  end
end)

return {
  -- Appearance
  font_size = 13.0,
  color_scheme = "Builtin Solarized Dark",

  -- Whole-window behavior when font size changes
  adjust_window_size_when_changing_font_size = true,

  -- Scrollback
  scrollback_lines = 10000,

  -- Tabs
  hide_tab_bar_if_only_one_tab = false,
  use_fancy_tab_bar = true,

  -- Auto reload config
  automatically_reload_config = true,

  -- Leader key: Ctrl+Space, then another key
  leader = {
    key = "Space",
    mods = "CTRL",
    timeout_milliseconds = 2000,
  },

  keys = {
    ----------------------------------------------------------------------
    -- Reload config
    ----------------------------------------------------------------------
    {
      key = "r",
      mods = "LEADER",
      action = act.ReloadConfiguration,
    },

    ----------------------------------------------------------------------
    -- Tabs
    ----------------------------------------------------------------------
    {
      key = "t",
      mods = "CTRL|SHIFT",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "w",
      mods = "CTRL|SHIFT",
      action = act.CloseCurrentPane({ confirm = true }),
    },

    ----------------------------------------------------------------------
    -- Split panes
    ----------------------------------------------------------------------
    {
      key = "d",
      mods = "CTRL|SHIFT",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "e",
      mods = "CTRL|SHIFT",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "\\",
      mods = "LEADER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "-",
      mods = "LEADER",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },

    ----------------------------------------------------------------------
    -- Move between split panes
    ----------------------------------------------------------------------
    {
      key = "LeftArrow",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "RightArrow",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "UpArrow",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "DownArrow",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Down"),
    },

    ----------------------------------------------------------------------
    -- Resize split panes
    ----------------------------------------------------------------------
    {
      key = "LeftArrow",
      mods = "LEADER|SHIFT",
      action = act.AdjustPaneSize({ "Left", 5 }),
    },
    {
      key = "RightArrow",
      mods = "LEADER|SHIFT",
      action = act.AdjustPaneSize({ "Right", 5 }),
    },
    {
      key = "UpArrow",
      mods = "LEADER|SHIFT",
      action = act.AdjustPaneSize({ "Up", 5 }),
    },
    {
      key = "DownArrow",
      mods = "LEADER|SHIFT",
      action = act.AdjustPaneSize({ "Down", 5 }),
    },

    ----------------------------------------------------------------------
    -- Approximate whole window resize
    -- This changes font size; with adjust_window_size_when_changing_font_size=true,
    -- the OS window grows/shrinks too.
    ----------------------------------------------------------------------
    {
      key = "=",
      mods = "LEADER",
      action = act.IncreaseFontSize,
    },
    {
      key = "-",
      mods = "LEADER|SHIFT",
      action = act.DecreaseFontSize,
    },
    {
      key = "0",
      mods = "LEADER",
      action = act.ResetFontSize,
    },

    ----------------------------------------------------------------------
    -- Zoom current pane
    ----------------------------------------------------------------------
    {
      key = "z",
      mods = "LEADER",
      action = act.TogglePaneZoomState,
    },

    ----------------------------------------------------------------------
    -- Search
    ----------------------------------------------------------------------
    {
      key = "f",
      mods = "CTRL|SHIFT",
      action = act.Search("CurrentSelectionOrEmptyString"),
    },
  },
}
