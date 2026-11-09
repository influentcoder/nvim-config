return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- These parser names also match their filetype names
    local languages = { "c", "lua", "javascript", "html", "go", "python", "yaml" }
    require("nvim-treesitter").install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
