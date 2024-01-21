-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '[f', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- my keymaps
-- vim.keymap.set('n', '<leader>lg', function()
--   -- require('vim-floaterm').setup()
--   vim.cmd.FloatermNew '--width=0.85 --height=0.85 lazygit'
-- end, { desc = ' Open lazygit' })

-- vim.keymap.set('n', '<C-n>', function() vim.cmd.Neotree 'toggle' end, { desc = 'Toggle NeoTree' })
-- vim.keymap.set('n', '<leader>e', function() vim.cmd.Neotree 'reveal=true' end,
-- 	{ desc = 'Show current file in NeoTree' })

-- vim.keymap.set('n', '<leader>e', function()
--   vim.cmd.NvimTreeFocus()
-- end, { desc = 'Focus current file in NvimTree' })


vim.keymap.set('n', '<Tab>', function() vim.cmd.bnext() end, { desc = 'Next Buffer' })
vim.keymap.set('n', '<S-Tab>', function() vim.cmd.bprevious() end, { desc = 'Previous Buffer' })
vim.keymap.set('n', '<leader>x', function() vim.cmd.bdelete() end, { desc = 'Close Buffer' })

-- -- Possession
-- vim.keymap.set('n', '<leader>sl', function() require('nvim-possession').list() end,
--   { desc = 'Possession: List sessions' })
-- vim.keymap.set('n', '<leader>su', function()
--   require('nvim-possession').update()
-- end, { desc = 'Possession: Update session' })
-- vim.keymap.set('n', '<leader>sn', function()
--   require('nvim-possession').new()
-- end, { desc = 'Possession: New session' })
-- vim.keymap.set('n', '<leader>sD', function()
--   require('nvim-possession').delete()
-- end, { desc = 'Possession: Delete sessions' })

--
vim.keymap.set('c', 'qq', 'qa')
vim.keymap.set('n', ';', ':')

-- Comment linewiese in visual mode
vim.keymap.set('v', '<leader>/', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
	{ desc = 'BarBar: Restore Buffer' })
