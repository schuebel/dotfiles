vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

require("plugins")

require("options")
require("autocmds")
require("keymaps")

require("p-telescope")
require("p-treesitter")
require("p-lsp")
require("p-languages")
