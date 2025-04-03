return {
	{
		"smoka7/hop.nvim",
		event = "BufWinEnter",
		lazy = true,
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
		-- setting the keybinding for when to load it
		keys = {
			{ "<leader><leader>w", "<cmd>HopWordAC<cr>", desc = "Hop next word" },
			{ "<leader><leader>b", "<cmd>HopWordBC<cr>", desc = "Hop previous word" },
			{ "<leader><leader>s", "<cmd>HopChar1AC<cr>", desc = "Hop next search" },
			{ "<leader><leader>S", "<cmd>HopChar1BC<cr>", desc = "Hop prev search" },
			{ "<leader><leader>j", "<cmd>HopLineAC<cr>", desc = "Hop next line" },
			{ "<leader><leader>k", "<cmd>HopLineBC<cr>", desc = "Hop prev line" },
		},
	},
}
