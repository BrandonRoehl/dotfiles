-- Detect what terminal we are using
local program = vim.fn.getenv("TERM_PROGRAM")
-- Order is important here
if vim.g.neovide then
	require("config.program.neovide")
elseif program == "iTerm.app" then
	require("config.program.iterm")
elseif program == "Apple_Terminal" then
	require("config.program.apple")
elseif program == "ghostty" then
	require("config.program.ghostty")
elseif program == "tmux" then
	require("config.program.tmux")
elseif vim.fn.has_key(vim.fn.environ(), "KITTY_WINDOW_ID") == 1 then
	require("config.program.kitty")
else
	require("config.program.unknown")
end
