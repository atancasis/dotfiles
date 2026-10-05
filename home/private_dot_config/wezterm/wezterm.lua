local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local function active_pane_info(win)
	local mux_tab = win:active_tab()

	if mux_tab == nil then
		wezterm.log_warn("smart_split: couldn't find tab")
		return
	end

	for _, item in ipairs(mux_tab:panes_with_info()) do
		if item.is_active then
			return item
		end
	end
end

local function smart_split(win, pane, domain)
	local info = active_pane_info(win)

	if info == nil then
		wezterm.log_warn("smart_split: couldn't find pane")
		return
	end

	if info.pixel_width > info.pixel_height then
		win:perform_action(wezterm.action.SplitHorizontal({ domain = domain }), pane)
	else
		win:perform_action(wezterm.action.SplitVertical({ domain = domain }), pane)
	end
end

return {
	color_scheme = 'Kanagawa (Gogh)',
	font = wezterm.font 'FiraCode Nerd Font Mono',
	font_size = 10.0,
	cell_width = 1,
	line_height = 1.03,
	freetype_load_target = 'Light',
	freetype_interpreter_version = 40,

	keys = {
		{
			key = 'Enter',
			mods = 'SUPER',
			action = wezterm.action_callback(function(win, pane)
				smart_split(win, pane, "CurrentPaneDomain")
			end),
		},
		{
			key = 'd',
			mods = 'SUPER',
			action = wezterm.action.SplitHorizontal {
				domain = 'CurrentPaneDomain',
			},
		},
		{
			key = 'd',
			mods = 'SUPER|SHIFT',
			action = wezterm.action.SplitVertical {
				domain = 'CurrentPaneDomain',
			},
		},
		{
			key = '[',
			mods = 'SUPER',
			action = wezterm.action.ActivatePaneDirection 'Prev',
		},
		{
			key = ']',
			mods = 'SUPER',
			action = wezterm.action.ActivatePaneDirection 'Next',
		},
		{
			key = 'n',
			mods = 'SHIFT|CTRL',
			action = wezterm.action.ToggleFullScreen,
		},
	},

	selection_word_boundary = " \t\n{}[]()\"'`:",
}
