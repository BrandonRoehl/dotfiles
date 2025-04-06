--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	-- NOTE: Plugins can specify dependencies.
	--
	-- The dependencies are proper plugin specifications as well - anything
	-- you do for a plugin at the top level, you can do for a dependency.
	--
	-- Use the `dependencies` key to specify the dependencies of a particular plugin
	-- INFO: `brew install ripgrep` if you are on macOS

	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		-- event = "VeryLazy",
		lazy = true,
		version = "*",
		-- branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		cmd = { "Telescope" },
		keys = {
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", mode = "n", desc = "[S]earch [H]elp" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", mode = "n", desc = "[S]earch [K]eymaps" },
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", mode = "n", desc = "[S]earch [F]iles" },
			{ "<leader>ss", "<cmd>Telescope builtin<cr>", mode = "n", desc = "[S]earch Telescope" },
			{ "<leader>sw", "<cmd>Telescope grep_string<cr>", mode = "n", desc = "[S]earch current [W]ord" },
			{ "<leader>sg", "<cmd>Telescope live_grep<cr>", mode = "n", desc = "[S]earch by [G]rep" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", mode = "n", desc = "[S]earch [D]iagnostics" },
			{ "<leader>sr", "<cmd>Telescope resume<cr>", mode = "n", desc = "[S]earch [R]esume" },
			{
				"<leader>s.",
				"<cmd>Telescope oldfiles<cr>",
				mode = "n",
				desc = '[S]earch Recent Files ("." for repeat)',
			},
			{ "<leader>sb", "<cmd>Telescope buffers<cr>", mode = "n", desc = "[S]earch existing [B]uffers" },

			-- Slightly advanced example of overriding default behavior and theme
			{
				"<leader>/",
				function()
					-- You can pass additional configuration to Telescope to change the theme, layout, etc.
					require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
						-- winblend = 10,
						border = vim.g.border ~= "none",
						previewer = false,
					}))
				end,
				mode = "n",
				desc = "[/] Fuzzily search in current buffer",
			},

			-- It's also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			{
				"<leader>s/",
				function()
					require("telescope.builtin").live_grep({
						grep_open_files = true,
						prompt_title = "Live Grep in Open Files",
					})
				end,
				mode = "n",
				desc = "[S]earch [/] in Open Files",
			},

			-- Shortcut for searching your Neovim configuration files
			{
				"<leader>sn",
				-- "Telescope find_files cwd=~/.config/nvim",
				function()
					require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
				end,
				mode = "n",
				desc = "[S]earch [N]eovim files",
			},
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use Telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of `help_tags` options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- Telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!

			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				-- defaults = {
				--  -- if you want borderless
				-- 	borderchars = { " ", "", " ", "", "", "", "", "" },
				-- },
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
		end,
	},
}
