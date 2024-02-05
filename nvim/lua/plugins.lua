-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<M-h>",  "<cmd>TmuxNavigateLeft<cr>" },
            { "<M-j>",  "<cmd>TmuxNavigateDown<cr>" },
            { "<M-k>",  "<cmd>TmuxNavigateUp<cr>" },
            { "<M-l>",  "<cmd>TmuxNavigateRight<cr>" },
            { "<M-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
        },
    },
    -- Floaterm is required for calling lazygit inside nvim
    {
        'voldikss/vim-floaterm',
        keys = {
            { "<leader>lg", "<cmd>FloatermNew --width=0.85 --height=0.85 lazygit <cr>", desc = "Launch lazygit in Floaterm" },
        },
    },
    --
    -- Useful plugin to show you pending keybinds.
    {
        'folke/which-key.nvim',
        keys = {
            { "<leader>tk", "<cmd>Telescope keymaps<CR>", desc = "Telescope keymaps" },
        },

        config = function()
            -- document existing key chains
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
                ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
                ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            }
            -- register which-key VISUAL mode
            -- required for visual <leader>hs (hunk stage) to work
            require('which-key').register({
                ['<leader>'] = { name = 'VISUAL <leader>' },
                ['<leader>h'] = { 'Git [H]unk' },
            }, { mode = 'v' })
        end,

    },

    -- Detect tabstop and shiftwidth automatically
    -- {
    --     'tpope/vim-sleuth', lazy = false
    -- },

    {
        'numToStr/Comment.nvim',
        lazy = false,
        config = function()
            require('Comment').setup()
            vim.keymap.set('n', '<leader>/', function()
                require('Comment.api').toggle.linewise.current()
            end)
            vim.keymap.set('v', '<leader>/',
                "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
                { desc = 'Toggle comment in visual mode' })
        end,
        opts = { toggler = { line = '<leader>/' } }
    },

    -- file tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        init = function()
            if vim.fn.argc(-1) == 1 then
                local stat = vim.loop.fs_stat(vim.fn.argv(0))
                if stat and stat.type == "directory" then require("neo-tree").setup({ filesystem = { hijack_netrw_behavior = "open_current", }, }) end
            end
        end,
        keys = {
            { "<C-n>",     "<cmd>Neotree toggle<cr>",      desc = "NeoTree" },
            { '<leader>e', "<cmd>Neotree reveal=true<cr>", desc = 'NeoTree: Reveal file' },
        },
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            'lewis6991/gitsigns.nvim',
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },
        opts = {
            hijack_netrw_behavior = 'open_current',
            enable_diagnostics = false,
            filtered_items = {
                hide_gitignored = false,
                always_show = {
                    ".gitignore",
                    ".config",
                },
            },
            filesystem = {
                window = {
                    mappings = {
                        -- disable fuzzy finder
                        ["/"] = "noop",
                        ["<c-/>"] = "fuzzy_finder",
                    }
                }
            }
        },
    },

    {
        "folke/todo-comments.nvim",
        lazy = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = { { '<leader>tt', "<cmd>TodoTelescope<cr>", desc = 'Telescope Todos', }, },
        opts = {},
    },

    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
        },
    },

    {
        '/WhoIsSethDaniel/mason-tool-installer',
        lazy = false,
        opts = {
            ensure_installed = {
                'pyright',
                'dockerfile-language-server',
                'lua-language-server',
                'stylua',
                'editorconfig-checker',
                'shfmt',
                'prettier',
                'ruff',
            },

            run_on_start = true,
            start_delay = 3000,
        },
        dependencies = 'williamboman/mason.nvim',
    },

    {
        'folke/neodev.nvim',
        lazy = false,
        config = function()
            require('neodev').setup()
        end
    },

    {
        'ggandor/leap.nvim',
        lazy = false,
        config = function()
            require('leap').add_default_mappings()
        end,
    },


    {
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
        },
    },

    -- Adds git related signs to the gutter, as well as utilities for managing changes
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
                delete = { text = '_' },
                topdelete = { text = '‾' },
                changedelete = { text = '~' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ 'n', 'v' }, ']c', function()
                    if vim.wo.diff then
                        return ']c'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to next hunk' })

                map({ 'n', 'v' }, '[c', function()
                    if vim.wo.diff then
                        return '[c'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to previous hunk' })

                -- Actions
                -- visual mode
                map('v', '<leader>hs', function()
                    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'stage git hunk' })
                map('v', '<leader>hr', function()
                    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
                end, { desc = 'reset git hunk' })
                -- normal mode
                map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
                map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
                map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
                map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
                map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
                map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
                map('n', '<leader>hb', function()
                    gs.blame_line { full = false }
                end, { desc = 'git blame line' })
                map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
                map('n', '<leader>hD', function()
                    gs.diffthis '~'
                end, { desc = 'git diff against last commit' })

                -- Toggles
                map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
                map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
            end,
        },
    },


    -- Themes
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 100,
        opts = {},
        config = function()
            vim.cmd.colorscheme 'tokyonight'
        end,
    },

    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        lazy = false,
        opts = {
            options = {
                icons_enabled = false,
                theme = 'onedark',
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    -- Add indentation guides even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        lazy = false,
        opts = {},
    },


    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
        },
    },

    -- Highlight, edit, and navigate code
    {
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
    },

    -- Autoformat plugin
    {
        'stevearc/conform.nvim',
        event = 'BufWritePre', -- load the plugin before saving
        keys = { { '<leader>fm', function() require('conform').format() end, desc = 'Format current buffer', }, },
        opts = {
            formatters_by_ft = {
                python = { 'ruff_format' },
                sh = { 'shfmt' },
                javascript = { 'prettier' },
                json = { 'jq' }
            },
            -- enable format-on-save
            format_on_save = {
                -- when no formatter is setup for a filetype, fallback to formatting
                -- via the LSP. This is relevant e.g. for taplo (toml LSP), where the
                -- LSP can handle the formatting for us
                lsp_fallback = true,
            },
            formatters = {
                shfmt = {
                    prepend_args = { '-i', '4' },
                },
            },
        },
    },

    {
        "LintaoAmons/cd-project.nvim",

        keys = {
            { "<leader>sp", "<cmd>CdProject<cr>", desc = "[S]earch [P]rojects" },
        },
        config = function()
            require("cd-project").setup({
                projects_picker = "telescope",
                projects_config_filepath = vim.fs.normalize(vim.fn.stdpath("config") .. "/cd-project.nvim.json"),
            })
        end
    }
}, { defaults = { lazy = true } })

-- load some more plugin specific stuff
require("plugin-conf.treesitter")
require("plugin-conf.languages")
require("plugin-conf.telescope")
