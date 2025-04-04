return {
	{
		-- easymotion was last updated in 2022 and that was the README. The last
		-- piece of code was changed in 2020 so for now I will use hop.nvim
		-- and now a fork of hop since the original is not being maintained
		"smoka7/hop.nvim",
		lazy = true,
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
		-- setting the keybinding for when to load it
		keys = {
			-- The easy motion binds
			{ "<leader><leader>s", "<cmd>HopChar1<cr>", desc = "Search character" },
			{ "<leader><leader>f", "<cmd>HopChar1AC<cr>", desc = "Find character forwards" },
			{ "<leader><leader>F", "<cmd>HopChar1BC<cr>", desc = "Find character backwards" },
			{ "<leader><leader>t", "<cmd>HopChar1CurrentLineAC<cr>", desc = "Til character forwards" },
			{ "<leader><leader>T", "<cmd>HopChar1CurrentLineBC<cr>", desc = "Til character backwards" },
			{ "<leader><leader>w", "<cmd>HopWordAC<cr>", desc = "Start of word forwards" },
			{ "<leader><leader>b", "<cmd>HopWordBC<cr>", desc = "Start of word backwards" },
			-- <leader><leader> l	Matches beginning & ending of word, camelCase, after _, and after # forwards
			{ "<leader><leader>l", "<cmd>HopAnywhereAC<cr>", desc = "Hop forward" },
			-- <leader><leader> h	Matches beginning & ending of word, camelCase, after _, and after # backwards
			{ "<leader><leader>h", "<cmd>HopAnywhereBC<cr>", desc = "Hop backwards" },
			-- <leader><leader> e	End of word forwards
			-- <leader><leader> ge	End of word backwards
			{ "<leader><leader>j", "<cmd>HopLineStartAC<cr>", desc = "Start of line forwards" },
			{ "<leader><leader>k", "<cmd>HopLineStartBC<cr>", desc = "Start of line backwards" },
			{ "<leader><leader>/", "<cmd>HopPattern<cr>", desc = "Search n-character" },
			-- <leader><leader><leader> bdt	Til character
			-- <leader><leader><leader> bdw	Start of word
			-- <leader><leader><leader> bde	End of word
			-- <leader><leader><leader> bdjk	Start of line
			{ "<leader><leader><leader>j", "<cmd>HopAnywhere<cr>", desc = "JumpToAnywhere motion" },

			-- Custom stuff I have added
			{ "<leader><leader>0", "<cmd>HopLine<cr>", desc = "Hop begining of line" },
		},
	},
}
