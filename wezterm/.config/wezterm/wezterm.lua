local wezterm = require("wezterm")
local act = wezterm.action

-- Session save/restore across reboots (upstream is archived; fetched once into
-- ~/.local/share/wezterm/plugins). Restores layout + cwd, not running processes.
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")
resurrect.state_manager.periodic_save()

wezterm.on("update-right-status", function(window, pane)
  if window:leader_is_active() then
    window:set_right_status(" LEADER ")
  else
    window:set_right_status("")
  end
end)

-- Save a window/tab snapshot; an empty title would write ".json" (invisible to the
-- fuzzy loader, overwritten by the next one), so prompt for a name first.
local function save_named(win, pane, what, title, set_title, get_state)
  if title ~= nil and title ~= "" then
    resurrect.state_manager.save_state(get_state())
    return
  end
  win:perform_action(
    wezterm.action.PromptInputLine({
      description = "Enter new " .. what .. " title",
      action = wezterm.action_callback(function(_, _, input)
        if input and input ~= "" then
          set_title(input)
          resurrect.state_manager.save_state(get_state())
        end
      end),
    }),
    pane
  )
end

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

  -- Keep tabs/panes alive when the window closes (lost on reboot; see resurrect)
  unix_domains = { { name = "unix" } },
  default_gui_startup_args = { "connect", "unix" },

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

    ----------------------------------------------------------------------
    -- Sessions (resurrect.wezterm): save / load
    ----------------------------------------------------------------------
    {
      key = "s",
      mods = "LEADER",
      action = wezterm.action_callback(function()
        resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
      end),
    },
    {
      key = "W",
      mods = "LEADER|SHIFT",
      -- upstream save_window_action calls a non-exported resurrect.save_state; use state_manager directly
      action = wezterm.action_callback(function(win, pane)
        local mux_win = win:mux_window()
        save_named(win, pane, "window", mux_win:get_title(), function(t)
          mux_win:set_title(t)
        end, function()
          return resurrect.window_state.get_window_state(mux_win)
        end)
      end),
    },
    {
      key = "T",
      mods = "LEADER|SHIFT",
      -- same upstream bug in save_tab_action's untitled branch
      action = wezterm.action_callback(function(win, pane)
        local tab = pane:tab()
        save_named(win, pane, "tab", tab:get_title(), function(t)
          tab:set_title(t)
        end, function()
          return resurrect.tab_state.get_tab_state(tab)
        end)
      end),
    },
    {
      key = "o",
      mods = "LEADER",
      action = wezterm.action_callback(function(win, pane)
        resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
          local kind = string.match(id, "^([^/]+)")
          id = string.match(id, "([^/]+)$")
          id = string.match(id, "(.+)%..+$")
          local opts = {
            relative = true,
            restore_text = false, -- scrollback may hold secrets and state is unencrypted
          }
          if kind == "workspace" then
            resurrect.workspace_state.restore_workspace(resurrect.state_manager.load_state(id, "workspace"), opts)
          elseif kind == "window" then
            resurrect.window_state.restore_window(pane:window(), resurrect.state_manager.load_state(id, "window"), opts)
          elseif kind == "tab" then
            -- restore_tab splits the active pane; close the old ones so the layout is exact
            opts.close_open_panes = true
            resurrect.tab_state.restore_tab(pane:tab(), resurrect.state_manager.load_state(id, "tab"), opts)
          end
        end)
      end),
    },
  },
}
