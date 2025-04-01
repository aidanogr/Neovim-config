require("basic_setup")
require("c_configs")
require("nvim-treesitter.configs").setup({
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
  -- enable syntax highlighting
  highlight = {
      enable = true
  }
})


