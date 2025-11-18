local wezterm = require 'wezterm'

local scheme = 'Spacemacs (base16)'

local scheme_def = wezterm.color.get_builtin_schemes()[scheme]

local config = wezterm.config_builder()

config.enable_tab_bar = false

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = '#000',
      fg_color = '#000',
    }
  }
}

config.font = wezterm.font 'Iosevka Nerd Font'
config.font_size = 14

local super_vim_keys_map = {
	h = utf8.char(0xAA),
	j = utf8.char(0xAB),
	k = utf8.char(0xAC),
	l = utf8.char(0xAD),
}

local vim_keys_direction_map = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function bind_super_key_to_vim(key)
  return {
    key = key,
    mods = 'CMD',
    action = wezterm.action_callback(function(win, pane)
      local vars = pane:get_user_vars()
      local is_nvim = vars.IS_NVIM == 'true'
      local mode = vars.NVIM_MODE or 'normal'

      if is_nvim then
        -- Pass to neovim (it will handle window or terminal navigation)
        local char = super_vim_keys_map[key]
        win:perform_action({ SendKey = { key = char } }, pane)
      else
        -- Move between wezterm panes
        win:perform_action(wezterm.action.ActivatePaneDirection(vim_keys_direction_map[key]), pane)
      end
    end),
  }
end

local function bind_ctrl_resize_key(key)
  return {
    key = key,
    mods = 'CTRL',
    action = wezterm.action_callback(function(win, pane)
      local vars = pane:get_user_vars()
      local is_nvim = vars.IS_NVIM == 'true'

      if is_nvim then
        win:perform_action({ SendKey = { key = key, mods = 'CTRL' } }, pane)
      else
        win:perform_action(wezterm.action.AdjustPaneSize { vim_keys_direction_map[key], 3 }, pane)
      end
    end),
  }
end

config.keys = {
  bind_super_key_to_vim('h'),
  bind_super_key_to_vim('j'),
  bind_super_key_to_vim('k'),
  bind_super_key_to_vim('l'),
  bind_ctrl_resize_key('h'),
  bind_ctrl_resize_key('j'),
  bind_ctrl_resize_key('k'),
  bind_ctrl_resize_key('l'),
  {
    key = 'd',
    mods = 'SUPER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'D',
    mods = 'SUPER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'Space',
    mods = 'CTRL',
    action = wezterm.action.TogglePaneZoomState
  },
  {
    key = "Enter",
    mods = "SHIFT",
    action = wezterm.action.SendString "\x0a",
  },
}

-- and finally, return the configuration to wezterm
return config
