local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  "nvim-lualine/lualine.nvim",
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  "williamboman/mason.nvim",
  "neovim/nvim-lspconfig",
  "nvim-telescope/telescope.nvim",
  "mfussenegger/nvim-dap", -- Debug Adapter Protocol client
  {
    "hrsh7th/nvim-cmp", -- Autocompletion plugin
    dependencies = {
      "L3MON4D3/LuaSnip", -- Snippet engine
      "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
      "hrsh7th/cmp-buffer", -- Buffer source for nvim-cmp
      "hrsh7th/cmp-path", -- Path source for nvim-cmp
      "hrsh7th/cmp-cmdline", -- Command line source for nvim-cmp
      "saadparwaiz1/cmp_luasnip", -- Snippet source for nvim-cmp
      "rafamadriz/friendly-snippets", -- Useful snippets
    },
  },
})
vim.cmd.colorscheme "catppuccin-mocha"

require("lualine").setup()
require("mason").setup()
require("lspconfig").clangd.setup ({
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
require("lspconfig").html.setup {}
require("lspconfig").cmake.setup {}

local dap = require("dap")

-- Adapter configuration for codelldb (installed via Mason)
dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
	command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
	args = { "--port", "${port}" },
    }
}


-- Configuration for C debugging
dap.configurations.c = {
    {
	name = "Launch with codelldb",
	type = "codelldb",
	request = "launch",
	program = function()
	    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/build_files', 'file')
	end,
	cwd = "${workspaceFolder}",
	stopOnEntry = false,
    },
}
vim.keymap.set('n', '<F5>', function() require("dap").continue() end, { desc = "Debug: Start/Continue" })
vim.keymap.set('n', '<F10>', function() require("dap").step_over() end, { desc = "Debug: Step Over" })
vim.keymap.set('n', '<F11>', function() require("dap").step_into() end, { desc = "Debug: Step Into" })
vim.keymap.set('n', '<F12>', function() require("dap").step_out() end, { desc = "Debug: Step Out" })
vim.keymap.set('n', '<Leader>db', function() require("dap").toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })


local cmp = require('cmp')

require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
    ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
    ["<C-e>"] = cmp.mapping.abort(), -- close completion window
    ["<CE>"] = cmp.mapping.confirm({ select = false }),
  }),
  -- sources for autocompletion
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- LSP
    { name = "luasnip" }, -- snippets
    { name = "buffer" }, -- text within the current buffer
    { name = "path" }, -- file system paths
  }),
})
