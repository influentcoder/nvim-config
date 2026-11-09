return {
  "leoluz/nvim-dap-go",
  config = function()
    local dap_go = require("dap-go")
    dap_go.setup()

    vim.keymap.set("n", "<Leader>dgt", dap_go.debug_test, { desc = "DAP GO - Debug Test" })
    vim.keymap.set("n", "<Leader>dgl", dap_go.debug_last_test, { desc = "DAP GO - Debug Last Test" })
  end,
}
