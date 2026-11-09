local opt = vim.opt

opt.relativenumber = true
opt.number = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

opt.wrap = false

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.termguicolors = true
-- Always shown, so text doesn't shift when signs appear
opt.signcolumn = "yes"

opt.mouse = ""
