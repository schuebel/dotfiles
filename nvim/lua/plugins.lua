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

-- [[ Configure plugins ]]
require('lazy').setup({
	-- NOTE: First, some plugins that don't require any configuration

	-- Git related plugins
	-- 'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Floaterm is required for calling lazygit inside nvim
	{
		'voldikss/vim-floaterm',
		keys = {
			{ "<leader>lg", "<cmd>FloatermNew --width=0.85 --height=0.85 lazygit <cr>", desc = "Launch lazygit in Floaterm" },
		},
		-- config = function()
		--   require("vim-floaterm").setup()
		-- end,
	},
	--
	-- Useful plugin to show you pending keybinds.
	{
		'folke/which-key.nvim',
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
		end
	},

	-- Detect tabstop and shiftwidth automatically
	{ 'tpope/vim-sleuth',      lazy = false },

	-- NOTE: This is where your plugins related to LSP can be installed.
	--  The configuration is done below. Search for lspconfig to find it below.

	-- measure startup time
	'dstein64/vim-startuptime',

	{
		"nvim-neo-tree/neo-tree.nvim",
		keys = {
			{ "<C-n>",     "<cmd>Neotree toggle<cr>",      desc = "NeoTree" },
			{ '<leader>e', "<cmd>Neotree reveal=true<cr>", desc = 'NeoTree: Reveal file' },
		},
		config = function()
			require("neo-tree").setup()
		end,
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			'lewis6991/gitsigns.nvim',
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		opts = {
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
		keys = {
			{
				'<leader>tt',
				function()
					require('todo-comments').setup()
				end,
				desc = 'Telescope Todos',
			},
		},
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
			'folke/neodev.nvim',
		},
	},

	{
		'ggandor/leap.nvim',
		lazy = false,
		config = function()
			require('leap').add_default_mappings()
		end,
	},

	-- {
	--   'gennaro-tedesco/nvim-possession',
	--   lazy = false,
	--   dependencies = {
	--     'ibhagwan/fzf-lua',
	--   },
	--   config = true,
	-- },

	-- {
	--   'nvim-tree/nvim-tree.lua',
	--   version = '*',
	--   lazy = true,
	--   dependencies = {
	--     'nvim-tree/nvim-web-devicons',
	--   },
	--   opts = {
	--
	--     filters = {
	--       dotfiles = false,
	--       exclude = { vim.fn.stdpath 'config' .. '/lua/custom' },
	--     },
	--     disable_netrw = true,
	--     hijack_netrw = true,
	--     hijack_cursor = true,
	--     hijack_unnamed_buffer_when_opening = false,
	--     sync_root_with_cwd = true,
	--     update_focused_file = {
	--       enable = true,
	--       update_root = false,
	--     },
	--     view = {
	--       adaptive_size = false,
	--       side = 'left',
	--       width = 30,
	--       preserve_window_proportions = true,
	--     },
	--     git = {
	--       enable = false,
	--       ignore = true,
	--     },
	--     filesystem_watchers = {
	--       enable = true,
	--     },
	--     actions = {
	--       open_file = {
	--         resize_window = true,
	--       },
	--     },
	--     renderer = {
	--       root_folder_label = false,
	--       highlight_git = false,
	--       highlight_opened_files = 'none',
	--
	--       indent_markers = {
	--         enable = false,
	--       },
	--
	--       icons = {
	--         show = {
	--           file = true,
	--           folder = true,
	--           folder_arrow = true,
	--           git = false,
	--         },
	--
	--         glyphs = {
	--           default = '󰈚',
	--           symlink = '',
	--           folder = {
	--             default = '',
	--             empty = '',
	--             empty_open = '',
	--             open = '',
	--             symlink = '',
	--             symlink_open = '',
	--             arrow_open = '',
	--             arrow_closed = '',
	--           },
	--           git = {
	--             unstaged = '✗',
	--             staged = '✓',
	--             unmerged = '',
	--             renamed = '➜',
	--             untracked = '★',
	--             deleted = '',
	--             ignored = '◌',
	--           },
	--         },
	--       },
	--     },
	--   },
	-- },

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

			-- Adds a number of user-friendly snippets
			-- 'rafamadriz/friendly-snippets',
		},
	},


	-- {
	--   'romgrk/barbar.nvim',
	--   dependencies = {
	--     'lewis6991/gitsigns.nvim',
	--     'nvim-tree/nvim-web-devicons',
	--   },
	--   init = function() vim.g.barbar_auto_setup = false end,
	--   opts = {
	--   },
	-- },

	{
		-- Adds git related signs to the gutter, as well as utilities for managing changes
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
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd.colorscheme 'tokyonight'
		end,
	},

	-- {
	--   'ellisonleao/gruvbox.nvim',
	--   lazy = false,
	--   priority = 1000,
	--   config = function()
	--     vim.cmd.colorscheme 'gruvbox'
	--   end,
	-- },

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

	{
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help ibl`
		main = 'ibl',
		lazy = false,
		opts = {},
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', lazy = false, opts = { toggler = { line = '<leader>/' } } },

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

	{
		-- Highlight, edit, and navigate code
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
		keys = {
			{
				'<leader>fm',
				function()
					require('conform').format { lsp_fallback = true }
				end,
				desc = 'Format',
			},
		},
		opts = {
			formatters_by_ft = {
				-- python = { "isort", "black" },
				-- python = { 'black' },
				python = { 'ruff_format' },
				sh = { 'shfmt' },
				javascript = { 'prettier' },
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
}, { defaults = { lazy = true } })
