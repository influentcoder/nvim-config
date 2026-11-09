-- Also excluded when a project's .gitignore doesn't cover them
local excluded_globs = {
  "--glob=!**/.git/*",
  "--glob=!**/.idea/*",
  "--glob=!**/.vscode/*",
  "--glob=!**/build/*",
  "--glob=!**/dist/*",
  "--glob=!**/yarn.lock",
  "--glob=!**/package-lock.json",
}

local function rg(args)
  return vim.list_extend(vim.list_extend({ "rg" }, args), excluded_globs)
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<M-Left>"] = "preview_scrolling_left",
            ["<M-Right>"] = "preview_scrolling_right",
            ["<M-D>"] = "delete_buffer",
          },
          n = {
            ["<M-D>"] = "delete_buffer",
          },
        },
        vimgrep_arguments = rg({
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        }),
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = rg({ "--files", "--hidden" }),
        },
      },
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope - Find Files" })
    vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope - Live Grep" })
    vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope - Buffers" })
    vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope - Help Tags" })
    vim.keymap.set("n", "<leader>fd", builtin.lsp_definitions, { desc = "Telescope - Definitions" })
    vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols, { desc = "Telescope - Find Document Symbols" })
    vim.keymap.set(
      "n",
      "<leader>fc",
      builtin.current_buffer_fuzzy_find,
      { desc = "Telescope - Current Buffer Fuzzy Find" }
    )
    vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope - Keymaps" })
  end,
}
