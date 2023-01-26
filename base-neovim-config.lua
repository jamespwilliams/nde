local treesitter_parser_install_dir = '/var/tmp/nvim-treesitter/parser'

local lsp_attach_keymappings = {
    ['gD'] = 'vim.lsp.buf.declaration()',
    ['gd'] = 'vim.lsp.buf.definition()',
    ['K'] = 'vim.lsp.buf.hover()',
    ['gi'] = 'vim.lsp.buf.implementation()',
    ['<C-k>'] = 'vim.lsp.buf.signature_help()',
    ['<space>wa'] = 'vim.lsp.buf.add_workspace_folder()',
    ['<space>wr'] = 'vim.lsp.buf.remove_workspace_folder()',
    ['<space>wl'] = 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))',
    ['<space>D'] = 'vim.lsp.buf.type_definition()',
    ['<space>rn'] = 'vim.lsp.buf.rename()',
    ['<space>ca'] = 'vim.lsp.buf.code_action()',
    ['gr'] = 'vim.lsp.buf.references()',
    ['<space>f'] = 'vim.lsp.buf.formatting()'
}

local diagnostic_keymappings = {
    ['<space>e'] = 'vim.diagnostic.open_float()',
    ['[d'] = 'vim.diagnostic.goto_prev()',
    [']d'] = 'vim.diagnostic.goto_next()',
    ['<space>q'] = 'vim.diagnostic.setloclist()',
}

local lsp_document_format_augroup = vim.api.nvim_create_augroup('lsp_document_format', { clear = true })

-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------------ Utilities ------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
local buf_nnoremap_lua = function(bufnr, keys, command)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', keys, '<cmd>lua ' .. command .. '<CR>', { noremap = true, silent = true })
end

local nnoremap_cmd = function(keys, command)
    vim.api.nvim_set_keymap('n', keys, '<cmd>' .. command .. '<CR>', { noremap = true, silent = true })
end

local nnoremap_lua = function(keys, command)
    nnoremap_cmd(keys, 'lua ' .. command)
end
-----------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- End utilities -----------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

local set_up_treesitter = function()
    local treesitter_configs = require 'nvim-treesitter.configs'

    treesitter_configs.setup {
        parser_install_dir = treesitter_parser_install_dir,
        highlight = { enable = true }
    }
    vim.opt.runtimepath:append(treesitter_parser_install_dir)
end

local set_up_diagnostic_keybindings = function()
    for key, cmd in pairs(diagnostic_keymappings) do nnoremap_lua(key, cmd) end
end

local set_up_lsps = function()
    local lspconfig = require 'lspconfig'

    local on_lsp_attach = function(_, bufnr)
        -- Enable completion triggered by <c-x><c-o>:
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        for key, cmd in pairs(lsp_attach_keymappings) do buf_nnoremap_lua(bufnr, key, cmd) end
    end

    lspconfig.gopls.setup { on_attach = on_lsp_attach }
    lspconfig.perlpls.setup { on_attach = on_lsp_attach }
    lspconfig.pyright.setup { on_attach = on_lsp_attach }
    lspconfig.rnix.setup { on_attach = on_lsp_attach }
    lspconfig.vimls.setup { on_attach = on_lsp_attach, isNeovim = true }
    lspconfig.sumneko_lua.setup {
        on_attach = on_lsp_attach,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT'
                },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    -- Make the LSP aware of Neovim runtime files:
                    library = vim.api.nvim_get_runtime_file('', true)
                },
                format = {
                    enable = true,
                    defaultConfig = {
                        indent_style = 'space',
                        indent_size = '2',
                    }
                },
            }
        }
    }

    local rt = require("rust-tools")
    rt.setup({
        tools = {
            inlay_hints = {
                auto = true,
            },
        },
        server = {
            on_attach = on_lsp_attach,
        },
    })
end

local set_up_lsp_autoformatting = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*' },
        callback = vim.lsp.buf.formatting_sync,
        group = lsp_document_format_augroup,
    })
end

local set_up_go_autoimports = function()
    -- https://github.com/golang/tools/blob/1f10767725e2be1265bef144f774dc1b59ead6dd/gopls/doc/vim.md#imports
    local organise_imports = function(wait_ms)
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { 'source.organizeImports' } }

        local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)

        for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    vim.lsp.util.apply_workspace_edit(r.edit, 'UTF-8')
                else
                    vim.lsp.buf.execute_command(r.command)
                end
            end
        end
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.go' },
        callback = function()
            organise_imports(1000)
        end,
        group = lsp_document_format_augroup,
    })
end

local set_up_fzf = function()
    nnoremap_cmd('<C-p>', 'Files')
    nnoremap_cmd('<C-g>', 'Rg')
end

set_up_treesitter()
set_up_lsps()
set_up_diagnostic_keybindings()
set_up_fzf()
set_up_lsp_autoformatting()
set_up_go_autoimports()
