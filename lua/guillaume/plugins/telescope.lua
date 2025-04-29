return {
  'nvim-telescope/telescope.nvim',
--  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-Left>"] = "preview_scrolling_left",
          ["<C-Right>"] = "preview_scrolling_right",
        },
      },
    },
  },
}
