---@module "lazy"
---@type LazyPluginSpec
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	version = false, -- Latest release is way too old and doesn't work on Windows
	build = function()
		local TS = require("nvim-treesitter")
		if not TS.get_installed then
			Utils.error("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.")
			return
		end
		Utils.treesitter.build(function()
			TS.update(nil, { summary = true })
		end)
	end,
	event = { "BufReadPost", "BufNewFile", "VeryLazy" },
	cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
	opts_extend = { "ensure_installed" },
	---@alias TSFeat { enable?: boolean, disable?: string[] }
	opts = {
		highlight = { enable = true }, ---@type TSFeat
		ensure_installed = {},
	},
	---@param opts TSConfig
	config = function(_, opts)
		local TS = require("nvim-treesitter")

		setmetatable(require("nvim-treesitter.install"), {
			__newindex = function(_, k)
				if k == "compilers" then
					vim.schedule(function()
						Utils.error({
							"Setting custom compilers for `nvim-treesitter` is no longer supported.",
							"",
							"For more info, see:",
							"- [compilers](https://docs.rs/cc/latest/cc/#compile-time-requirements)",
						})
					end)
				end
			end,
		})

		-- some quick sanity checks
		if not TS.get_installed then
			return Utils.error("Please use `:Lazy` and update `nvim-treesitter`")
		elseif type(opts.ensure_installed) ~= "table" then
			return Utils.error("`nvim-treesitter` opts.ensure_installed must be a table")
		end

		-- setup treesitter
		TS.setup(opts)
		Utils.treesitter.get_installed(true) -- initialize the installed langs

		-- install missing parsers
		local install = vim.tbl_filter(function(lang)
			return not Utils.treesitter.have(lang)
		end, opts.ensure_installed or {})
		if #install > 0 then
			Utils.treesitter.build(function()
				TS.install(install, { summary = true }):await(function()
					Utils.treesitter.get_installed(true) -- refresh the installed langs
				end)
			end)
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
			callback = function(ev)
				local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
				if not Utils.treesitter.have(ft) then
					return
				end

				---@param feat string
				---@param query string
				local function enabled(feat, query)
					local f = opts[feat] or {} ---@type lazyvim.TSFeat
					return f.enable ~= false
						and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
						and Utils.treesitter.have(ft, query)
				end

				-- highlighting
				if enabled("highlight", "highlights") then
					pcall(vim.treesitter.start, ev.buf)
				end
			end,
		})
	end,
}
