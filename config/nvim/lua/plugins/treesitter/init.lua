---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	import = "plugins.treesitter",
	branch = "main",
	version = false, -- Latest release is way too old and doesn't work on Windows
	lazy = true,
	event = { "LazyFile", "VeryLazy" },
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
	build = function()
		local TS = require("nvim-treesitter")
		if not TS.get_installed then
			vim.notify(
				"Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.",
				vim.log.levels.ERROR
			)
			return
		end
		Utils.treesitter:build(function()
			TS.update(nil, { summary = true })
		end)
	end,
	opts_extend = { "ensure_installed" },
	---@class LazyTSConfig: TSConfig
	opts = {
		---@type string[]
		ensure_installed = {},
	},
	---@param opts LazyTSConfig
	config = function(_, opts)
		local LU = require("lazy.core.util")
		local TS = require("nvim-treesitter")

		-- some quick sanity checks
		if not TS.get_installed then
			return LU.error("Please use `:Lazy` and update `nvim-treesitter`")
		elseif type(opts.ensure_installed) ~= "table" then
			return LU.error("`nvim-treesitter` opts.ensure_installed must be a table")
		end

		-- setup treesitter
		TS.setup(opts)
		Utils.treesitter:get_installed(true) -- initialize the installed langs

		-- install missing parsers
		local install = vim.tbl_filter(function(lang)
			return not Utils.treesitter:have(lang)
		end, opts.ensure_installed or {})
		if #install > 0 then
			Utils.treesitter:build(function()
				TS.install(install, { summary = true }):await(function()
					Utils.treesitter:get_installed(true) -- refresh the installed langs
				end)
			end)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
			callback = function(ev)
				local ft, _ = ev.match, vim.treesitter.language.get_lang(ev.match)
				if not Utils.treesitter:have(ft) then
					return
				end

				pcall(vim.treesitter.start, ev.buf)
			end,
		})
	end,
	-- If mason is enabled install the tree-sitter CLI tool
	specs = {
		"mason-org/mason.nvim",
		optional = true,
		opts_extend = { "ensure_installed" },
		opts = {
			ensure_installed = { "tree-sitter-cli" },
		},
	},
}
