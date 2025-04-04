return {
	{
		-- lazy motion hasn't been updated in 7 years as of the time of running
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
			{ "<leader><leader>j", "<cmd>HopVerticalAC<cr>", desc = "Hop next line" },
			{ "<leader><leader>k", "<cmd>HopVerticalBC<cr>", desc = "Hop prev line" },
			{ "<leader><leader>^", "<cmd>HopLineStart<cr>", desc = "Hop line first non-blank" },
			{ "<leader><leader>0", "<cmd>HopLine<cr>", desc = "Hop begining of line" },
		},
	},
}
