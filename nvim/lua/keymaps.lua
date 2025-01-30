local k = vim.keymap.set
k({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
k('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
k('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
k('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
k('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
k('n', '[f', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
k('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Buffer navigation
k('n', '<leader>x', function() vim.cmd.bdelete() end, { desc = 'Close Buffer' })

-- Pane navigation
k('n', '<C-H>', "<C-w>h", { desc = 'Focus pane to the left' })
k('n', '<C-J>', "<C-w>j", { desc = 'Focus pane to the bottom' })
k('n', '<C-K>', "<C-w>k", { desc = 'Focus pane to the top' })
k('n', '<C-L>', "<C-w>l", { desc = 'Focus pane to the right' })

k('n', '<C-A-\\>', "<cmd>vsp<CR>")
k('n', '<A-`>', "<cmd>sp<CR>")

-- Copilot
k('n', '<leader>ch', '<cmd>Copilot help<CR>', { desc = 'Copilot: help' })
k('n', '<leader>ce', '<cmd>Copilot enable<CR>', { desc = 'Copilot: enable' })
k('n', '<leader>cd', '<cmd>Copilot disable<CR>', { desc = 'Copilot: disable' })
k('n', '<leader>cp', '<cmd>Copilot panel<CR>', { desc = 'Copilot: panel' })
k('i', '<C-u>', 'copilot#Accept("\\<CR>")', { desc = 'Copilot: use suggestion', expr = true, replace_keycodes = false })
k('i', '<C-i>', '<Plug>(copilot-accept-word)', { desc = 'Copilot: use next suggested word' })
k('n', '<leader>ccq', function()
        local input = vim.fn.input("Quick Chat: ")
        if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
        end
    end,
    { desc = "CopilotChat - Quick chat" }
)
k('v', '<leader>cc', function()
    require("CopilotChat").open()
end, { desc = 'CopilotChat on selection' })

-- misc
k('c', 'qq', 'qa')
k('n', ';', ':')
k('n', '<C-c>', '<cmd> %y+ <CR>', { desc = 'Copy buffer to system clipboard' })
k('n', '<leader>nb', '<cmd>enew<CR>', { desc = 'New Buffer' })
k('n', '<leader>gy', '<cmd>YankParentDirPath<CR>', { desc = 'Copy parent directory of buffer to system clipboard' })

-- use Y to copy to system register
k('v', 'Y', '"+y')

-- Telescope
-- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- vim.keymap.set('n', '<leader>rs', require('telescope.builtin').resume, { desc = '[R]esume [S]earch' })
-- vim.keymap.set('n', '<leader>tc', require('telescope.builtin').commands, { desc = '[T]elescope [C]ommands' })
-- vim.keymap.set('n', '<leader>to', require('telescope.builtin').treesitter, { desc = '[T]elescope Treesitter [O]bjects' })
-- vim.keymap.set("n", "<leader>sr", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
-- { desc = '[S]earch with [r]ipgrep - supports args' })
