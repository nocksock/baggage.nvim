local setup = require 'baggage'.from {
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/williamboman/mason-lspconfig.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/j-hui/fidget.nvim/tree/legacy',
}

setup('mason')

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

vim.api.nvim_create_autocmd('LspAttach', { -- {{{
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    local nmap = function(keys, func, desc)
      if desc then
        desc = 'LSP: ' .. desc
      end

      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    if not client then
      return;
    end

    if client.server_capabilities.completionProvider then
      vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
      vim.bo.tagfunc = "v:lua.vim.lsp.tagfunc"
      vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders')

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    nmap('<leader>ca' , vim.lsp.buf.code_action, 'show Code Action')
    nmap('gK'         , vim.lsp.buf.signature_help)
    nmap('<leader>j'  , vim.diagnostic.goto_next, 'next diagnostic')
    nmap('<leader>k'  , vim.diagnostic.goto_prev, 'previous diagnostic')
    nmap("<leader>J"  , function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, 'next error')
    nmap("<leader>K"  , function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, 'previous error')
    nmap(']d'         , vim.diagnostic.goto_next)
    nmap('[d'         , vim.diagnostic.goto_prev)
    nmap("]D"         , function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end)
    nmap("[D"         , function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end)
    nmap('<leader>e'  , vim.diagnostic.open_float)

    nmap('<leader>q'  , ':Diagnostics<cr>', 'show diagnostics in [q]uickfix')
    nmap('<leader>Q'  , ':Diagnostics error<cr>', 'show error diagnostics in [Q]uickfix')
    nmap('<leader>rn' , vim.lsp.buf.rename, '[r]e[n]ame')

    nmap('gr'         , require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
    nmap('gd'         , ':Telescope lsp_definitions<CR>', '[g]oto [d]efinition')
    nmap('gy'         , ':Telescope lsp_type_definitions<cr>', '[g]oto t[y]pe definition')
    nmap('gI'         , ':Telescope lsp_type_implementations<cr>', '[g]oto [I]mplementation')
    nmap('gD'         , ':lua vim.lsp.buf.declaration<cr>', '[g]oto [D]eclaration')
    nmap('<c-w>d'     , ':vs<cr>:lua vim.lsp.buf.definition()<cr>zt', '[g]oto [D]efinition in a split')
    nmap('<c-w>D'     , ':vs<cr>:lua vim.lsp.buf.declaration()<cr>zt', '[g]oto [d]eclaration in a split')
    nmap('<c-w>y'     , ':vs<cr>:lua vim.lsp.buf.type_definition()<cr>zt', '[g]oto t[y]pe definition in a split')
    nmap('<c-w>i'     , ':vs<cr>:lua vim.lsp.buf.implementation()<cr>zt', '[g]oto [i]mplementation in a split')

    vim.keymap.set('i', '<c-]>', vim.lsp.buf.signature_help)
  end
}) -- }}}
