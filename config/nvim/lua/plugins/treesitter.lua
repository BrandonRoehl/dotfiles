---@module "lazy"
---@return LazyPluginSpec[]
return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		event = { "BufRead", "BufNewFile", "VeryLazy" },
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		init = function(plugin)
			-- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
			-- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
			-- no longer trigger the **nvim-treesitter** module to be loaded in time.
			-- Luckily, the only things that those plugins need are the custom queries, which we make available
			-- during startup.
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		keys = {
			{ "<c-space>", desc = "Increment Selection" },
			{ "<bs>", desc = "Decrement Selection", mode = "x" },
		},
		opts_extend = { "ensure_installed" },
		---@type TSConfig
		---@diagnostic disable-next-line: missing-fields
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
		-- Sets main module to use for opts
		main = "nvim-treesitter.configs",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		version = false,
		event = "VeryLazy",
		lazy = true,
		config = function()
			-- When in diff mode, we want to use the default
			-- vim text objects c & C instead of the treesitter ones.
			local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
			local configs = require("nvim-treesitter.configs")
			for name, fn in pairs(move) do
				if name:find("goto") == 1 then
					move[name] = function(q, ...)
						if vim.wo.diff then
							local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
							for key, query in pairs(config or {}) do
								if q == query and key:find("[%]%[][cC]") then
									vim.cmd("normal! " .. key)
									return
								end
							end
						end
						return fn(q, ...)
					end
				end
			end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		version = false,
		event = "VeryLazy",
		dependencies = "nvim-treesitter/nvim-treesitter",
		--- @type TSContext.UserConfig
		opts = {
			line_numbers = true,
			trim_scope = "outer",
			mode = "topline",
			-- https://neovim.io/doc/user/lua.html#vim.opt%3Aget()
			max_lines = vim.opt.scrolloff:get(),
		},
		commands = { "TSContextToggle", "TSContextEnable", "TSContextDisable" },
		-- keys = {
		-- 	{
		-- 		"[c",
		-- 		function()
		-- 			require("treesitter-context").go_to_context()
		-- 		end,
		-- 		mode = "n",
		-- 		silent = true,
		-- 		desc = "Disable Context",
		-- 	},
		-- },
	},
}
