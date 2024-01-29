local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('MyAutocmds', { clear = true })

autocmd('VimResized', {
	desc = 'Auto resize panes when resizing nvim window',
	group = augroup,
	pattern = '*',
	command = 'tabdo wincmd =',
})

autocmd('BufReadPost', {
	desc = 'Open file at the last position it was edited earlier',
	group = augroup,
	pattern = '*',
	command = 'silent! normal! g`"zv'
})

autocmd('TextYankPost', {
	desc = 'Highlight on yank',
	group = augroup,
	pattern = '*',
	callback = function()
		vim.highlight.on_yank()
	end,
})
