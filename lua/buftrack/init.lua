local core = require("buftrack.core")
local ui = require("buftrack.ui")
local utils = require("buftrack.utils")

local M = {}

local on_buffer_close = function(args)
	local buf = args.buf
	if not (utils.bufvalid(buf)) then
		return
	end
	local buf_name = vim.api.nvim_buf_get_name(buf)

	utils.remove(core.closed_buffers, buf_name)
	table.insert(core.closed_buffers, buf_name)

	utils.cap_list_size(core.closed_buffers)
end

M.setup = function(opts)
	opts = opts or {}
	core.max_tracked = opts["max_tracked"] or 16

	vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
		callback = core.track_buffer,
	})

	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
		callback = on_buffer_close,
	})

	vim.api.nvim_create_user_command("BufReopen", core.reopen_buffer, {})
	vim.api.nvim_create_user_command("BufTrack", core.track_buffer, {})
	vim.api.nvim_create_user_command("BufTrackPrev", core.prev_buffer, {})
	vim.api.nvim_create_user_command("BufTrackNext", core.next_buffer, {})
	vim.api.nvim_create_user_command("BufTrackList", ui.buffers_list, {})
	vim.api.nvim_create_user_command("BufClosedList", ui.closed_buffers_list, {})
	vim.api.nvim_create_user_command("BufTrackClear", core.clear_tracked_buffers, {})
	vim.api.nvim_create_user_command("BufClear", core.clear, {})
	vim.api.nvim_create_user_command("BufClosedClear", core.clear_closed, {})
end

return M
