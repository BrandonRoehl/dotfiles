--- @module 'lazy'
--- @return LazyPluginSpec[]
return {
	{ -- File tree
		"nvim-neo-tree/neo-tree.nvim",
		version = "*",
		-- branch = "v3.x",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "\\", "<cmd>Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
			{
				"<leader>nb",
				"<cmd>Neotree toggle show buffers right<CR>",
				desc = "[N]eoTree show [B]uffers",
				silent = true,
			},
			{ "<leader>ns", "<cmd>Neotree float git_status<CR>", desc = "[N]eoTree Git [S]tatus", silent = true },
		},
		-- NOTE: Neotree configuration here is not the full config.
		opts = {
			sources = {
				"filesystem",
				"git_status",
				"buffers",
				-- "document_symbols",
			},
			source_selector = {
				winbar = false,
				statusline = false,
				separator_active = "",
				show_scrolled_off_parent_node = true,
				padding = 1,
				sources = {
					{ source = "filesystem", display_name = nil },
					{ source = "git_status", display_name = nil },
					{ source = "buffers", display_name = nil },
					-- { source = "document_symbols" },
				},
				tabs_layout = "start",
			},
			filesystem = {
				window = {
					mappings = {
						["\\"] = "close_window",
					},
				},
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false, -- only works on Windows for hidden files/directories
				},
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--               -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
			},
			buffers = {
				follow_current_file = {
					enabled = true, -- This will find and focus the file in the active buffer every time
					--              -- the current file is changed while the tree is open.
					leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
				},
			},
			default_component_configs = {
				container = {
					enable_character_fade = true,
				},
				indent = {
					indent_size = 2,
					padding = 1, -- extra padding on left hand side
					-- indent guides
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
					-- expander config, needed for nesting files
					with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = ">",
					expander_expanded = "v",
					expander_highlight = "NeoTreeExpander",
				},
				-- Set the icons to ASCII if you don't have a nerd font otherwise use
				-- the default icons provided by nvim-web-devicons and unicode characters
				icon = vim.g.have_nerd_font and {} or {
					folder_closed = ">",
					folder_open = "v",
					folder_empty = "-",
					provider = function(icon, node, _) -- default icon provider utilizes nvim-web-devicons if available
						if node.type == "file" or node.type == "terminal" then
							local success, web_devicons = pcall(require, "nvim-web-devicons")
							if success then
								local name = node.type == "terminal" and "terminal" or node.name
								local _, hl = web_devicons.get_icon(name)
								icon.highlight = hl or icon.highlight
							end
						end
					end,
					-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
					-- then these will never be used.
					default = "*",
					highlight = "NeoTreeFileIcon",
				},
				modified = {
					symbol = "[+]",
					highlight = "NeoTreeModified",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
					highlight = "NeoTreeFileName",
				},
				-- Set the icons to ASCII if you don't have a nerd font otherwise use
				-- the default icons provided by nvim-web-devicons and unicode characters
				git_status = vim.g.have_nerd_font and {} or {
					symbols = {
						-- Change type
						added = "+", -- or "", but this is redundant info if you use git_status_colors on the name
						modified = "*", -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = "-", -- this can only be used in the git_status source
						renamed = "~", -- this can only be used in the git_status source
						-- Status type
						untracked = "-",
						ignored = "?",
						unstaged = "x",
						staged = "✔",
						conflict = "@",
					},
				},
			},
		},
	},
}
