local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd('VimResized', {
	pattern = '*',
	command = 'tabdo wincmd =',
})
-- treat Jenkinsfile as groovy
-- BufNewFile,BufRead Jenkinsfile setf groovy
autocmd({ 'BufRead', 'BufNewFile' }, {
	pattern = '*enkinsfile',
	command = 'setfiletype groovy',
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})
