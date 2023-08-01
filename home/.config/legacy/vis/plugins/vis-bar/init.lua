require('vis')

vis.events.subscribe(vis.events.WIN_STATUS, function(win)
	local modes = {
		[vis.modes.NORMAL]              = 'NORMAL',
		[vis.modes.OPERATOR_PENDING]    = 'PENDING',
		[vis.modes.VISUAL]              = 'VISUAL',
		[vis.modes.VISUAL_LINE]         = 'VISUAL-LINE',
		[vis.modes.INSERT]              = 'INSERT',
		[vis.modes.REPLACE]             = 'REPLACE',
	}

	local mode         = modes[vis.mode]
	local file         = win.file
	local name         = file.name
	local size         = file.size
	local selection    = win.selection
	local col          = selection.col
	local pos          = selection.pos
	local line         = selection.line

	local nstatus = " "..mode.."   "..(name or 'No Name').." "
	local lstatus = " "..mode.."   "..(name or 'No Name').." "
	local rnstatus = "  MASTER  "..math.ceil(pos/size*100).."%    "..line..",  "..col.." "
	local rstatus = "  FORK  "..math.ceil(pos/size*100).."%    "..line..",  "..col.." "

	-- Conditional statusbar update
	if vis.mode == vis.modes.NORMAL then
		-- win:style_define(win.STYLE_STATUS_FOCUSED, 'fore:'..fg..',bold,back:'..bg)
		win:status(nstatus, rnstatus) ;;
	else
		-- win:style_define(win.STYLE_STATUS_FOCUSED, 'fore:'..fg..',bold,italics,back:'..bg)
		win:status(lstatus, rstatus) ;;
	end
end)
