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

-- Window navigation with leader v
k('n', '<leader>v', '<C-w>', { noremap = true })

k('n', '<C-A-\\>', "<cmd>vsp<CR>")
k('n', '<A-`>', "<cmd>sp<CR>")

-- Copilot
k('n', '<leader>ch', '<cmd>Copilot help<CR>', { desc = 'Copilot: help' })
k('n', '<leader>ce', '<cmd>Copilot enable<CR>', { desc = 'Copilot: enable' })
k('n', '<leader>cd', '<cmd>Copilot disable<CR>', { desc = 'Copilot: disable' })
k('n', '<leader>cp', '<cmd>Copilot panel<CR>', { desc = 'Copilot: panel' })
k('i', '<C-u>', 'copilot#Accept("\\<CR>")', { desc = 'Copilot: use suggestion', expr = true, replace_keycodes = false })
-- for whatever reason this does not work with the k function...
vim.keymap.set('i', '<C-y>', '<Plug>(copilot-accept-word)')

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
