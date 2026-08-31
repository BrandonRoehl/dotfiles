-- Neovide Configuration
-- https://neovide.dev/configuration.html

vim.g.have_nerd_font = true
vim.g.neovide_pixel_geometry = "RGBH"

-- [font] normal = ["JetBrainsMono Nerd Font"], size = 13.0
vim.o.guifont = "JetBrainsMono Nerd Font:h13:#e-subpixelantialias:#h-none"

vim.g.neovide_text_gamma = 0.0
vim.g.neovide_text_contrast = 0.5
-- idle = true (redraw only when needed)
-- vim.g.neovide_no_idle = false

-- NOTE: The rest of ~/.config/neovide/config.toml cannot be moved here.
-- Those are startup/window-creation options that Neovide reads before nvim
-- boots, so they have no `vim.g.neovide_*` equivalent and must stay in
-- config.toml (or be passed on the command line):
--   fork, frame, grid/size, maximized, icon, mouse-cursor-icon, neovim-bin,
--   no-multigrid, opengl, server, srgb, startup-message-capture, tabs,
--   title-hidden, vsync, wayland-app-id, wsl, x11-wm-class*, chdir,
--   backtraces-path
--   system-native-tabs and all system-*-hotkey settings (macOS)
--   [font.features] (e.g. all = ["-calt", "-liga", "-dlig"])
--   [box-drawing] mode and [box-drawing.sizes]
