-- [[ Install `lazy.nvim` plugin manager ]]
local utils = require('utils')
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

    -- Floaterm is required for calling lazygit inside nvim
    {
        'voldikss/vim-floaterm',
        keys = {
            { "<leader>lg", "<cmd>FloatermNew --width=0.85 --height=0.85 lazygit <cr>", desc = "Launch lazygit in Floaterm" },
            { "<C-\\>",     "<cmd>FloatermToggle<CR>",                                  mode = "n",                         desc = "Toggle Floaterm" },
            { "<C-\\>",     "<C-\\><C-n><cmd>q<CR>",                                    mode = "t",                         desc = "Toggle Floaterm" },

        },
    },
    {
        "nvim-pack/nvim-spectre",
        cmd = { "Spectre" },
    },
    {
        "OXY2DEV/markview.nvim",

        ft = "markdown",
        dependencies = {
            -- You may not need this if you don't lazy load
            -- Or if the parsers are in your $RUNTIMEPATH
            "nvim-treesitter/nvim-treesitter",

            "nvim-tree/nvim-web-devicons"
        },
    },
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
        'WhoIsSethDaniel/mason-tool-installer',
        event = 'VeryLazy',
        opts = {
            ensure_installed = {
                'groovyls',
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
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
        },
        { "Bilal2453/luvit-meta" }, -- optional `vim.uv` typings
        {                           -- optional completion source for require statements and module annotations
            "hrsh7th/nvim-cmp",
            opts = function(_, opts)
                opts.sources = opts.sources or {}
                table.insert(opts.sources, {
                    name = "lazydev",
                    group_index = 0, -- set group index to 0 to skip loading LuaLS completions
                })
            end,
        },
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
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
        event = "VeryLazy",
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

    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap", "mfussenegger/nvim-dap-python", --optional
            { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
        },
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
            require("venv-selector").setup()
        end,
        keys = {
            { "<leader>ve", "<cmd>VenvSelect<cr>" },
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
        -- See `:help lualine.txt`
        'nvim-lualine/lualine.nvim',
        event = "VeryLazy",
        opts = {
            options = {
                icons_enabled = false,
                theme = 'onedark',
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1, -- Relative path
                    }
                }
            }
        },
    },

    -- Add indentation guides even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        event = "VeryLazy",
        opts = {},
    },


    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        cmd = 'Telescope',
        branch = '0.1.x',
        config = function()
            require('plugin-conf.telescope')
        end,
        dependencies = {
            'nvim-telescope/telescope-live-grep-args.nvim',
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
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
                choice_format = "path",
            })
        end
    },

    {
        "github/copilot.vim",
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.cmd('Copilot restart')
        end,
        -- keys = {
        --     {
        --         "<leader>cl",
        --         function()
        --             print('Load Github CoPilot');
        --         end,
        --         desc = "Copilot: load plugin"
        --     },
        -- },
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
            { "github/copilot.vim" },    -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        keys = {
            { "<leader>cl",  function() print('Load Github CoPilot'); end, desc = "Copilot: load plugin" },
            { "<leader>cc",  '<cmd>CopilotChatToggle<CR>',                 desc = "Copilot: Open CopilotChat" },
            { "<leader>gcm", '<cmd>CopilotChatCommit<CR>',                 desc = "Copilot: Generate commit message" },
        },
        window = {
            width = 0.25,
        },
        opts = {
            -- debug = true, -- Enable debugging
            -- See Configuration section for rest
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            animate = { enabled = true },
            bigfile = { enabled = true },
            dashboard = {
                preset = {
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "o", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" }, -- Changed key from 'r' to 'o'
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                        { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
                enabled = true,
            },
            indent = { enabled = true },
            gitbrowse = { enabled = true },
            input = { enabled = true },
            picker = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scratch = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = true },
            toggle = { enabled = true },
            words = { enabled = true },
        },
        keys = {
            { "<leader>gB",       function() Snacks.gitbrowse() end,                                      desc = "Git Browse",                            mode = { "n", "v" } },
            { "<leader>.",        function() Snacks.scratch() end,                                        desc = "Toggle Scratch Buffer" },
            { "<leader>S",        function() Snacks.scratch.select() end,                                 desc = "Select Scratch Buffer" },
            { "<leader>gl",       function() Snacks.picker.git_log_file() end,                            desc = "Git Log on file" },
            { "<leader>gL",       function() Snacks.picker.git_log() end,                                 desc = "Git Log on entire repo" },
            { "<leader>sk",       function() Snacks.picker.keymaps() end,                                 desc = "Keymaps" },
            { "<leader><leader>", function() Snacks.picker.buffers() end,                                 desc = "Buffers" },
            { "<leader>fo",       function() Snacks.picker.recent() end,                                  desc = "Recent" },
            { "<leader>/",        function() Snacks.picker.grep() end,                                    desc = "Fuzzy search in current buffer" },
            { "<leader>fg",       function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
            { "<leader>fc",       function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
            { "<leader>ff",       function() Snacks.picker.files() end,                                   desc = "Find Files (respect ignores and hidden" },
            { "<leader>faf",      function() Snacks.picker.files({ ignored = true, hidden = true }) end,  desc = "Find all Files" },
            { "<leader>gg",       function() Snacks.picker.grep({ dirs = { utils.get_git_root() } }) end, desc = "Grep in git repo" },
            { "<leader>ss",       function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
        }
    },
    {
        "nvzone/typr",
        dependencies = "nvzone/volt",
        opts = {},
        cmd = { "Typr", "TyprStats" },
    }

}, { defaults = { lazy = true } })

-- load some more plugin specific stuff
require("plugin-conf.treesitter")
require("plugin-conf.languages")
