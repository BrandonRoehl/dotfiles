local vim = vim
local Plug = vim.fn['plug#']

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.call('plug#begin')

-- Plug('preservim/nerdtree', { ['on'] = ['NERDTreeToggle', 'NERDTree'] })
-- Plug 'scrooloose/nerdcommenter'
Plug('nvim-tree/nvim-tree.lua')
Plug('easymotion/vim-easymotion')
Plug('terryma/vim-multiple-cursors')

Plug('tpope/vim-bundler')
Plug('tpope/vim-git')

-- if exists('$TMUX')
--     Plug 'tpope/vim-tbone'
--     Plug 'roxma/vim-tmux-clipboard'
-- endif

vim.call('plug#end')

local tree = require "nvim-tree"
local api = require "nvim-tree.api"

-- empty setup using defaults
-- local function my_on_attach(bufnr)
-- 	local function opts(desc)
-- 		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
-- 	end

-- 	-- default mappings
-- 	api.config.mappings.default_on_attach(bufnr)

-- 	-- custom mappings
-- 	-- vim.keymap.set('i', '<C-\\>', api.tree.toggle)
-- 	-- vim.keymap.set('n', '<C-\\>', api.tree.toggle, opts('Toggle'))
-- 	-- vim.keymap.set('n', '<C-\\>', function() print("real lua function") end)
-- 	-- vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
-- 	-- vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
-- 	end
-- pass to setup along with your other options
tree.setup {
	on_attach = my_on_attach,
}
vim.keymap.set({'n', 'v', 'i'}, '<C-\\>', api.tree.toggle, { noremap = true })
-- vim.keymap.set('n', '<C-\\>', function() print("real lua function") end)