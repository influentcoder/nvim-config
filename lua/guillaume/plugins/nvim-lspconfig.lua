local function set_lsp_keymaps(event)
  local function map(mode, lhs, rhs, desc, opts)
    opts = vim.tbl_extend("force", { buffer = event.buf, desc = "LSP - " .. desc }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
  map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
  map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
  -- Without nowait, Neovim's built-in grn/grr/gra/... mappings delay gr by 'timeoutlen'
  map("n", "gr", vim.lsp.buf.references, "Go to references", { nowait = true })
  map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
  map("n", "<F2>", vim.lsp.buf.rename, "Rename")
  map({ "n", "x" }, "<F3>", function()
    vim.lsp.buf.format({ async = true })
  end, "Format")
  map("n", "<F4>", vim.lsp.buf.code_action, "Code action")
end

local function lua_ls_on_init(client)
  if client.workspace_folders then
    local path = client.workspace_folders[1].name
    local has_own_luarc = vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")
    if path ~= vim.fn.stdpath("config") and has_own_luarc then
      return
    end
  end

  client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
    runtime = {
      version = "LuaJIT",
      path = { "lua/?.lua", "lua/?/init.lua" },
    },
    workspace = {
      checkThirdParty = false,
      library = { vim.env.VIMRUNTIME },
    },
  })
end

return {
  "neovim/nvim-lspconfig",
  dependencies = { "hrsh7th/cmp-nvim-lsp" },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", { callback = set_lsp_keymaps })

    vim.diagnostic.config({ virtual_text = true })
    vim.keymap.set("n", "<M-q>", vim.diagnostic.setloclist, { desc = "Set location list with diagnostics" })
    vim.keymap.set("n", "<leader>dv", function()
      vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
    end, { desc = "Toggle diagnostics virtual text" })

    vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })

    vim.lsp.config("pylsp", {
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = { enabled = true },
            pyflakes = { enabled = true },
            pylint = { enabled = true },
            mccabe = { enabled = true },
          },
        },
      },
    })

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          imports = {
            granularity = { group = "module" },
            prefix = "self",
          },
          cargo = { buildScripts = { enable = true } },
          procMacro = { enable = true },
        },
      },
    })

    vim.lsp.config("lua_ls", {
      on_init = lua_ls_on_init,
      settings = { Lua = {} },
    })

    vim.lsp.enable({ "clangd", "pylsp", "gopls", "yamlls", "ts_ls", "rust_analyzer", "lua_ls" })
  end,
}
