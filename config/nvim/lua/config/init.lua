-- set globals
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set global border definition for hovers
-- Can be one of the pre-defined styles: `"double"`, `"none"`, `"rounded"`, `"shadow"`, `"single"` or `"solid"`.
vim.g.winborder = "rounded"
-- vim.g.winborder = "none"
-- the new one that exists but is still buggy
-- vim.o.winborder = "rounded"

-- Load globals for specific terminal emulators
require("config.program")

-- Set vim configuration options
require("config.options")

-- Load custom keybindings for the base of neovim
require("config.keymaps")

-- Load custom autocommands for the base of neovim
require("config.autocmds")
