-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"
-- Color columns
vim.opt.colorcolumn = "81,121"

-- If this many milliseconds nothing is typed the swap file will be
-- written to disk (see |crash-recovery|). Also used for the
-- |CursorHold| autocommand event.
vim.opt.updatetime = 250

-- Disable swapfile for JamfProtect cause it causes lag cause we cannot handle
-- file events. So no recovery and no quick switching. Also no multiple
-- instances in the same file otherwise you are going to have a bad time.
if vim.fn.executable("protectctl") == 1 or vim.uv.fs_stat("/Applications/JamfProtect.app/") then
	vim.opt.swapfile = false
	-- Characters typed to schedule a swap file write
	-- 0 will disable the swap file feature even if the other flag is flipped
	vim.opt.updatecount = 0
end

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300
-- vim.opt.timeoutlen = 1000

-- No timeout for easymotion
-- vim.opt.timeout = false

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
-- vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5
-- Change the mouse scroll speed to enable smooth scrolling
-- vim.opt.mousescroll = "ver:1,hor:1"

-- Spacing
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.encoding = "utf-8"

-- Spellcheck
-- using harper_ls instead
vim.opt.spell = false
vim.opt.spelllang = "en_us"

-- Allow setting the title
vim.opt.title = true
