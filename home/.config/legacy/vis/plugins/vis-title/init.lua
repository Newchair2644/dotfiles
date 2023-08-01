require('vis')

local function set_title(title)
	vis:command(string.format(":!printf '\\033]0;%s\\007'", title))
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	set_title(win.file.name or '[No Name]')
end)

vis.events.subscribe(vis.events.FILE_SAVE_POST, function(file, path)
	set_title(file.name)
end)
