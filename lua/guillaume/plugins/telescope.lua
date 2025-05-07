return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<M-Left>"] = "preview_scrolling_left",
          ["<M-Right>"] = "preview_scrolling_right",
          ["<M-D>" ] = "delete_buffer",
        },
        n = {
          ["<M-D>" ] = "delete_buffer",
        },
      },
    },
  },
}
