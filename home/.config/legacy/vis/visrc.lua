-- ┐ ┬o┐─┐  ┬─┐┬─┐o┌┐┐┌─┐┬─┐
-- │┌┘│└─┐──├─ │ ││ │ │ ││┬┘
-- └┘ ┆──┘  ┴─┘┆─┘┆ ┆ ┘─┘┆└┘

-- VIS CONFIGURATION FILE visrc.lua

-- Plugins
require('vis')
require('plugins/vis-title')
require('plugins/vis-bar')

-- Global configuration options (on init)
vis.events.subscribe(vis.events.INIT, function()
	vis:command('set theme base16')
	vis:command('set change-256colors on')
	vis:command('set ignorecase')
	vis:command('set autoindent on')
	vis:command('set tabwidth 4')
end)

-- Regex match file name, removing ext
function get_file_name(file)
	return file:match("^(.+)%..*$")
end

-- Per window configuration options (on window open)
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command('set cursorline')
	vis:command('set relativenumbers')
	vis:command('set colorcolumn 80')
	vis:command('set show-tabs on')

	local leader = ' '
	-- split navigation
	vis:map(vis.modes.NORMAL, "<C-w>q", "<C-w>c")
	vis:map(vis.modes.NORMAL, leader .. "h", "C-w>h")
	vis:map(vis.modes.NORMAL, leader .. "j", "C-w>j")
	vis:map(vis.modes.NORMAL, leader .. "k", "C-w>k")
	vis:map(vis.modes.NORMAL, leader .. "l", "C-w>l")

	-- yank to system clipboard
	vis:map(vis.modes.VISUAL, leader .. "y", "+y")

	-- building/running programs
	vis:map(vis.modes.NORMAL, leader .. ";", ":!foot --title vis-repl<Enter>")

	if win.syntax == "ansi_c" then
		-- compile and run
		vis:map(
			vis.modes.NORMAL, '<F5>', string.format(":!gcc -lm %s -o %s && %s<Enter>",
			win.file.path, get_file_name(win.file.name), get_file_name(win.file.path))
		)
		-- GNU indent for formatting
		vis:map(vis.modes.VISUAL, "=", ":|indent -kr -i 8 -as<Enter>")
	end
end)

-- Repl for some interpreters
interactives = {
	["python"] = "!python -i ",
	["haskell"] = "!stack ghci ",
	["lithaskell"] = "!stack ghci ",
	["latex"] = "!tectonic ",
	["lua"] = "!luajit -i ",
}

vis:map(vis.modes.NORMAL, ";i", function()
	local command = interactives[vis.win.syntax]
	if command then
		vis:command(":w")
		vis:command(command.."'"..vis.win.file.name.."'")
	end
end)

-- Trim trailing whitespace and trailing empty lines
vis.events.subscribe(vis.events.FILE_SAVE_PRE, function(file, _)
	local lines = file.lines
	for i=1, #lines do
		local trimmed = lines[i]:match('^(.-)%s+$')
		if trimmed then
			lines[i] = trimmed
		end
	end

	local empty_lines = 0
	for i=#lines, 0, -1 do
		if lines[i] ~= "" then
			break
		end
		empty_lines = empty_lines + 1
	end
	if empty_lines > 0 then
		file:delete(file.size - empty_lines, empty_lines)
	end

	return true
end)

-- Msg after writing file
vis.events.subscribe(vis.events.FILE_SAVE_POST, function()
	  vis:info(vis.win.file.name .. ": " .. vis.win.file.size .. "B written")
end)
