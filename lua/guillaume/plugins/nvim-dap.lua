return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")
    local widgets = require("dap.ui.widgets")

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { desc = desc })
    end

    map("n", "<F5>", dap.continue, "DAP - Start Debugging")
    map("n", "<F8>", dap.step_over, "DAP - Step Over")
    map("n", "<F9>", dap.step_into, "DAP - Step Into")
    map("n", "<F10>", dap.step_out, "DAP - Step Out")
    map("n", "<Leader>b", dap.toggle_breakpoint, "DAP - Toggle Breakpoint")
    map("n", "<Leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, "DAP - Set Conditional Breakpoint")
    map("n", "<Leader>lp", function()
      dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end, "DAP - Set Log Point")
    map("n", "<Leader>dr", dap.repl.open, "DAP - Open REPL")
    map("n", "<Leader>dl", dap.run_last, "DAP - Run Last")
    map("n", "<Leader>dx", dap.terminate, "DAP - Terminate")
    map("n", "<Leader>du", dap.up, "DAP - Up the callstack")
    map("n", "<Leader>dd", dap.down, "DAP - Down the callstack")
    map({ "n", "v" }, "<Leader>dh", widgets.hover, "DAP UI - Hover Variables")
    map({ "n", "v" }, "<Leader>dp", widgets.preview, "DAP UI - Preview Variables")
    map("n", "<Leader>df", function()
      widgets.centered_float(widgets.frames)
    end, "DAP UI - Show Frames")
    map("n", "<Leader>ds", function()
      widgets.centered_float(widgets.scopes)
    end, "DAP UI - Show Scopes")
  end,
}
