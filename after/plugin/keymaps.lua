-- show/hide ui
local ui_hidden = false

function ToggleUI()
  ui_hidden = not ui_hidden
  if ui_hidden then
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.signcolumn = "no"
    -- Uncomment if using folds
    -- vim.opt.foldcolumn = "0"
  else
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.signcolumn = "yes"
    -- Uncomment if using folds
    -- vim.opt.foldcolumn = "1"
  end
end

vim.keymap.set("n", "<leader>tu", ":lua ToggleUI()<CR>", { desc = "Toggle UI (left gutter, line numbers)" })

vim.keymap.set("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change directory to current file's directory" })
vim.keymap.set("n", "<leader>cp", ":cd ..<CR>:pwd<CR>", { desc = "Change directory to current file's parent directory" })
