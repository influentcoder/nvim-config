vim.keymap.set('n', '<Leader>cco', function()
  require('CopilotChat').open()
end, { desc = 'Open Copilot Chat' })

local proxy_file = os.getenv("HOME") .. "/.config/nvim/copilot_proxy"
local f = io.open(proxy_file, "r")
if f then
  local proxy = f:read("*l")
  f:close()
  if proxy and proxy ~= "" then
    vim.g.copilot_proxy = proxy
  end
end
