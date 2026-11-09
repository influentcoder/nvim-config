local ui_hidden = false

local function toggle_ui()
  ui_hidden = not ui_hidden
  vim.opt.number = not ui_hidden
  vim.opt.relativenumber = not ui_hidden
  vim.opt.signcolumn = ui_hidden and "no" or "yes"
end

vim.keymap.set("n", "<leader>tu", toggle_ui, { desc = "Toggle UI (left gutter, line numbers)" })

vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change directory to current file's directory" })
vim.keymap.set(
  "n",
  "<leader>cp",
  ":cd ..<CR>:pwd<CR>",
  { desc = "Change directory to current file's parent directory" }
)
