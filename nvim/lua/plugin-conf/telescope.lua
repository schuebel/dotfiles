-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
-- local lga_actions = require("telescope-live-grep-args.actions")
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
            },
        },
    },
    extensions = {
        live_grep_args = {
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = {         -- extend mappings
                i = {
                    ["<C-k>"] = require("telescope-live-grep-args.actions").quote_prompt(),
                },
            },
        }
    }
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'live_grep_args')
