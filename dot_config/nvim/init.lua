-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("lualine")
return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      rust_analyzer = function()
        return true
      end,
    },
  },
}
