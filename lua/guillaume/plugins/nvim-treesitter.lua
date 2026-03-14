return {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function ()
      require'nvim-treesitter'.install { "c", "lua", "javascript", "html", "go", "python", "yaml" }
    end
}
