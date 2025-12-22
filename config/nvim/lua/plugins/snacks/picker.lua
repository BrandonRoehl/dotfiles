---@module "lazy"
---@type LazyPluginSpec
return {
	"folke/snacks.nvim",
	optional = true,
	--- @module 'snacks'
	--- @type snacks.Config
	opts = {
		explorer = {
			enabled = true,
			replace_netrw = true,
		},
		picker = {
			enabled = true,
			sources = {
				files = {
					hidden = true,
					ignored = true,
				},
				explorer = {
					hidden = true,
					ignored = true,
					win = {
						list = {
							keys = {
								["s"] = "edit_vsplit",
								["S"] = "edit_split",
								["\\"] = "close",
							},
						},
					},
				},
			},
		},
	},
	-- stylua: ignore
	keys = {
		-- Top Pickers & Explorer
		{ "\\", desc = "File Explorer", function()
			local explorer_pickers = Snacks.picker.get({ source = "explorer" })
			if #explorer_pickers == 0 then
				Snacks.picker.explorer()
				-- elseif explorer_pickers[1]:is_focused() then
				-- 	explorer_pickers[1]:close()
			else
				explorer_pickers[1]:focus()
			end
		end },
		{ "<leader>/", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
		{ "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
		-- find
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
		-- git
		{ "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
		{ "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
		{ "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
		{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
		{ "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
		{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
		{ "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
		-- Grep
		{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
		{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
		{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
		-- search
		{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
		{ '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
		{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
		{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
		{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
		{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
		{ "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
		{ "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
		{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
		{ "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
		{ "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
		{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
		{ "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
		{ "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
		{ "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
		{ "<leader>sf", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
	},
	specs = {
		{
			"neovim/nvim-lspconfig",
			optional = true,
			dependencies = { "folke/snacks.nvim" },
			opts_extend = { "servers.*.keys" },
			---@module "plugins.lsp"
			---@type LspOptions lsp options
			opts = {
				servers = {
					["*"] = {
                    -- stylua: ignore
					keys = {
                        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "[G]oto [D]efinition", method = "textDocument/definition" },
                        { "gD", function() Snacks.picker.lsp_declarations() end, desc = "[G]oto [D]eclaration" },
                        { "gr", function() Snacks.picker.lsp_references() end, desc = "[R]eferences", nowait = true },
                        { "gI", function() Snacks.picker.lsp_implementations() end, desc = "[G]oto [I]mplementation" },
                        { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "[G]oto T[y]pe Definition" },
                        { "<leader>cl", function() Snacks.picker.lsp_config() end, desc = "Lsp Info" },
                        { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP [S]ymbols" },
                        { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace [S]ymbols" },
                        -- { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", mode = {"n"}, method = { "workspace/didRenameFiles", "workspace/willRenameFiles" } },
                    },
					},
				},
			},
		},
		{
			"folke/which-key.nvim",
			optional = true,
			opts_extend = { "spec" },
			opts = {
				---@type wk.Spec
				spec = {
					{ "<leader>s", group = "[S]earch", icon = " " },
					{ "<leader>f", group = "[F]ind", icon = " " },
					{ "<leader>g", group = "[G]it", icon = " " },
				},
			},
		},
	},
}
