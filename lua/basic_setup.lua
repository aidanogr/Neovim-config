
--basic editor settings
local opt = vim.opt
opt.cursorline = true
opt.number = true
opt.softtabstop = 4
opt.shiftwidth = 4




--key mapping
vim.g.mapleader = " "
vim.keymap.set('n', "<leader>tt", "<cmd>Telescope<cr>")
vim.keymap.set('n', "<leader>tw", "<cmd>Telescope lsp_workspace_symbols<cr>")
vim.keymap.set('n', "<leader>we", "<cmd>w<cr><cmd>Ex<cr>")
vim.keymap.set('n', "<leader>e", "<cmd>Ex<cr>")
--set makeprg=cmake\ --build\ build

-- Keybindings for debugging
