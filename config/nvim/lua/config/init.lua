-- set globals
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load globals for specific terminal emulators
require("config.program")

-- Set vim configuration options
require("config.options")

-- Load custom keybindings for the base of neovim
require("config.keymaps")

-- Load custom autocommands for the base of neovim
require("config.autocmds")
