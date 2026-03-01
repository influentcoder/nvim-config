return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      require("nvim-treesitter.install").prefer_git = true
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "javascript", "html", "go", "python", "yaml" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },
        })
    end
}
