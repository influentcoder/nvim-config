return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "if [ -f ${HOME}/.local/share/nvim/tiktoken_core-linux-x86_64-luajit.so ]; then mkdir build && cp ${HOME}/.local/share/nvim/tiktoken_core-linux-x86_64-luajit.so build/; else make tiktoken; fi", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      mappings = {
        reset = {
          normal = "<C-q>",
          insert = "<C-q>",
        },
      },
      window = {
        width = 80,
      },
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
