---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	optional = true,
	--- @module 'snacks'
	--- @type snacks.Config
	opts = {
		bigfile = { enabled = false },
		indent = {
			enabled = true,
			animate = { enabled = false },
		},
		input = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		dim = {
			animate = { enabled = false },
		},
		quickfile = { enabled = true },
		scope = { enabled = true },
		statuscolumn = { enabled = true },
		image = { enabled = true },
		-- Disabled modules
		scroll = { enabled = false },
		-- styles = {
		-- 	notification = {
		-- 		-- wo = { wrap = true } -- Wrap notifications
		-- 	},
		-- },
	},
	-- stylua: ignore
	keys = {
		-- Other
		{ "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
		{ "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
		{ "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
		{ "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
		{ "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
		{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
		{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
		{ "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
		{ "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
		{ "<leader>N", desc = "Neovim News", function()
			Snacks.win({
				file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
				width = 0.6,
				height = 0.6,
				wo = {
					spell = false,
					wrap = false,
					signcolumn = "yes",
					statuscolumn = " ",
					conceallevel = 3,
				},
			})
		end }
	},
	init = function()
		-- vim.g.snacks_animate = false
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				-- Override print to use snacks for `:=` command
				if vim.fn.has("nvim-0.11") == 1 then
					vim._print = function(_, ...)
						_G.dd(...)
					end
				else
					vim.print = _G.dd
				end

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")

				require("plugins.snacks.progress.notify").create_autocmd()
			end,
		})
	end,
}
