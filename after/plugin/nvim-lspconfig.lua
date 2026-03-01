vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local bufnr = event.buf
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "LSP - Hover" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP - Go to definition" })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = bufnr, desc = "LSP - Go to declaration" })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = "LSP - Go to implementation" })
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { buffer = bufnr, desc = "LSP - Go to type definition" })
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = "LSP - Go to references" })
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { buffer = bufnr, desc = "LSP - Signature help" })
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { buffer = bufnr, desc = "LSP - Rename" })
    vim.keymap.set({ 'n', 'x' }, '<F3>', function() vim.lsp.buf.format({ async = true }) end, { buffer = bufnr, desc = "LSP - Format" })
    vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, { buffer = bufnr, desc = "LSP - Code action" })
  end,
})

vim.keymap.set('n', '<M-q>', vim.diagnostic.setloclist, { desc = "Set location list with diagnostics" })

vim.diagnostic.config({ virtual_text = true })

vim.keymap.set("n", "<leader>dv", function()
  vim.diagnostic.config({ virtual_text = not vim.diagnostic.config().virtual_text })
end, { desc = "Toggle diagnostics virtual text" })

local lsp_settings = {
  pylsp = {
    plugins = {
      pycodestyle = {
        enabled = true,
      },
      pyflakes = {
        enabled = true,
      },
      pylint = {
        enabled = true,
      },
      mccabe = {
        enabled = true,
      },
    }
  },
  rust_analyzer = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
          enable = true,
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

local ok_cmp_nvim_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
local capabilities = ok_cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- lua_ls is configured separately below, since it has a more complex configuration.
local servers = { 'clangd', 'pylsp', 'gopls', 'yamlls', 'ts_ls', 'rust_analyzer' }
for _, server in ipairs(servers) do
  vim.lsp.config(server, {
    capabilities = capabilities,
    settings = lsp_settings[server] or {},
  })
  vim.lsp.enable(server)
end

-- The lua_ls config is taken from https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
          path ~= vim.fn.stdpath('config')
          ---@diagnostic disable-next-line: undefined-field
          and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
  capabilities = capabilities,
})

vim.lsp.enable('lua_ls')

-- nvim-cmp setup
local ok_cmp, cmp = pcall(require, 'cmp')

if ok_cmp then
  local ok_luasnip, luasnip = pcall(require, 'luasnip')

  local sources = { { name = 'nvim_lsp' } }
  if ok_luasnip then
    table.insert(sources, { name = 'luasnip' })
  end


  cmp.setup {
    snippet = {
      expand = function(args)
        if ok_luasnip then
          luasnip.lsp_expand(args.body)
        else
          vim.snippet.expand(args.body)
        end
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = sources,
  }
end
