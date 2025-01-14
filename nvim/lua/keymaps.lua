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
k('n', '<leader>cc', '<cmd>CopilotChatToggle<CR>', { desc = 'Copilot Chat: toggle' })
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

local function find_git_root()
    -- Use the current buffer's path as the starting point for the git search
    local current_file = vim.api.nvim_buf_get_name(0)
    local current_dir
    local cwd = vim.fn.getcwd()
    -- If the buffer is not associated with a file, return nil
    if current_file == '' then
        current_dir = cwd
    else
        -- Extract the directory from the current file's path
        current_dir = vim.fn.fnamemodify(current_file, ':h')
    end

    -- Find the Git root directory from the current file's path
    local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
    if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
    end
    return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
    local git_root = find_git_root()
    if git_root then
        require('telescope.builtin').live_grep {
            search_dirs = { git_root },
        }
    end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles, { desc = 'Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>?', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[?] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
    require('telescope.builtin').live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
    }
end

vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>rs', require('telescope.builtin').resume, { desc = '[R]esume [S]earch' })
vim.keymap.set('n', '<leader>tc', require('telescope.builtin').commands, { desc = '[T]elescope [C]ommands' })
vim.keymap.set('n', '<leader>to', require('telescope.builtin').treesitter, { desc = '[T]elescope Treesitter [O]bjects' })
vim.keymap.set('n', '<leader>fw', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').git_bcommits,
    { desc = '[S]earch git [c]ommits on buffer' })
vim.keymap.set('n', '<leader>sC', require('telescope.builtin').git_commits,
    { desc = '[S]earch git [C]ommits on directory' })
vim.keymap.set("n", "<leader>sr", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
    { desc = '[S]earch with [r]ipgrep - supports args' })
