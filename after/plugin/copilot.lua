vim.keymap.set('n', '<Leader>cco', function()
  require('CopilotChat').open()
end, { desc = 'Open Copilot Chat' })
