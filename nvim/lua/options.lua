vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '
-- Set highlight on search
vim.o.hlsearch       = false

-- Make line numbers default
vim.wo.number        = true
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse          = 'a'

-- Enable break indent
vim.o.breakindent    = true

-- Save undo history
vim.o.undofile       = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase     = true
vim.o.smartcase      = true

-- Keep signcolumn on by default
vim.wo.signcolumn    = 'yes'

-- Decrease update time
vim.o.updatetime     = 250
vim.o.timeoutlen     = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt    = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors  = true

vim.opt.scrolloff    = 8

-- Disable intro
vim.opt.shortmess    = 'I'

-- Split new windows below
vim.opt.splitbelow   = true

-- Tab handling
vim.opt.tabstop      = 4

-- Use tabstop value to determine shiftwidth
vim.opt.shiftwidth   = 0
vim.opt.expandtab    = true
