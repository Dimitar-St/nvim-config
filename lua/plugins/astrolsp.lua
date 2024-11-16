-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = function(plugin, opts) 
    opts.servers = opts.servers or {}
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    
    -- CDS LSP
    -- First we add our custom LSP server to the configs registry
    -- We do this such that our client even knows that it exists and that it is possible to set it up
    local configs = require("lspconfig.configs")
    if not configs.cds_lsp then
        configs.cds_lsp = {
            default_config = {
                cmd = {
                    -- Since we installed cds-lsp globally, we can refer to it using this command
                    vim.fn.expand("cds-lsp"),
                    -- And then remembering to kindly ask it to be ready for some sweet stdio communication
                    "--stdio",
                },
                -- Also remember to tell it which files it actually works with!
                filetypes = { "cds" },
                root_dir = lspconfig.util.root_pattern(".git", "package.json"),
                settings = {},
            },
        }
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()
    local on_attach = function(client, bufnr)
         -- Other configs goes here...
    
        -- Our CDS setup
        if lspconfig["cds_lsp"].setup then
            lspconfig["cds_lsp"].setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
        end
    end
  end
}
