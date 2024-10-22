local vim = vim
local Plug = vim.fn['plug#']

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

vim.call('plug#begin')

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- Check the website for other language servers to use
Plug('neovim/nvim-lspconfig')
-- Plug('preservim/nerdtree', { ['on'] = ['NERDTreeToggle', 'NERDTree'] })
-- Plug 'scrooloose/nerdcommenter'
Plug('nvim-tree/nvim-tree.lua')
Plug('easymotion/vim-easymotion')
Plug('terryma/vim-multiple-cursors')
-- Git stuff
Plug('tpope/vim-bundler')
Plug('tpope/vim-git')

-- Auto Completion
Plug('hrsh7th/nvim-cmp') -- Autocompletion plugin
Plug('hrsh7th/cmp-nvim-lsp') -- LSP source for nvim-cmp
Plug('saadparwaiz1/cmp_luasnip') -- Snippets source for nvim-cmp
Plug('L3MON4D3/LuaSnip') -- Snippets plugin

-- if exists('$TMUX')
--		 Plug 'tpope/vim-tbone'
--		 Plug 'roxma/vim-tmux-clipboard'
-- endif

vim.call('plug#end')

local ok, ntree = pcall(require, "nvim-tree")
if ok then
	local api = require "nvim-tree.api"
	ntree.setup()
	vim.keymap.set({'n', 'v', 'i'}, '<C-\\>', api.tree.toggle, { noremap = true })
-- empty setup using defaults
-- tree.setup { on_attach = my_on_attach, }
-- local function my_on_attach(bufnr)
-- 	local function opts(desc)
-- 		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
-- 	end

-- 	-- default mappings
-- 	api.config.mappings.default_on_attach(bufnr)

-- 	-- custom mappings
--	-- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent, opts('Up'))
-- 	-- vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
-- 	end
-- pass to setup along with your other options
end

-- normal stuff

-- LSP

-- Python
-- https://github.com/microsoft/pyright
-- brew install pyright

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require("lspconfig")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { "gopls", "pyright", "ts_ls" }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		-- on_attach = my_custom_on_attach,
		capabilities = capabilities,
	}
end


-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
		['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
		-- C-b (back) C-f (forward) for snippet placeholder navigation.
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
}