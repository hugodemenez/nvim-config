return {
  -- Blink.cmp for completion (modern, fast)
  {
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      keymap = {
        preset = "default",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-Space>"] = { "show", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        -- Tab removed from LSP completion to allow Copilot to use it
        -- Arrow keys and Ctrl+j/k can be used for navigation
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      completion = {
        menu = {
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
  },

  -- Mason for LSP server management
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Mason-lspconfig bridge (just for auto-installing servers)
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "pyright",
      },
      automatic_installation = true,
    },
  },

  -- LSP Configuration using Neovim 0.11 native API
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    config = function()
      -- Ensure mason is set up first
      require("mason").setup()
      require("mason-lspconfig").setup()

      local blink_capabilities = require("blink.cmp").get_lsp_capabilities()
      -- Ensure formatting is enabled in capabilities
      -- Merge with default LSP capabilities to ensure formatting is available
      local capabilities = vim.tbl_deep_extend("force", 
        vim.lsp.protocol.make_client_capabilities(),
        blink_capabilities
      )
      -- Explicitly enable formatting capabilities
      if not capabilities.textDocument then
        capabilities.textDocument = {}
      end
      if not capabilities.textDocument.formatting then
        capabilities.textDocument.formatting = { dynamicRegistration = true }
      end

      -- Diagnostic config
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.HINT] = "󰌶",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      -- LSP keymaps (set on attach)
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buf = args.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map("n", "gr", vim.lsp.buf.references, "References")
          map("n", "gi", vim.lsp.buf.implementation, "Implementation")
          map("n", "gy", vim.lsp.buf.type_definition, "Type definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>cf", function()
            -- Try conform.nvim first (supports both LSP and external formatters)
            local conform_ok, conform = pcall(require, "conform")
            if conform_ok then
              conform.format({ async = true, lsp_fallback = true })
            else
              -- Fallback to LSP formatting if conform not available
              local formatting_clients = {}
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
                local caps = client.server_capabilities or {}
                if caps.documentFormattingProvider or caps.documentRangeFormattingProvider then
                  table.insert(formatting_clients, client)
                end
              end
              
              if #formatting_clients > 0 then
                vim.lsp.buf.format({
                  async = true,
                  filter = function(client)
                    local caps = client.server_capabilities or {}
                    return caps.documentFormattingProvider or caps.documentRangeFormattingProvider
                  end,
                })
              else
                vim.notify("[LSP] No formatter available. Install conform.nvim for external formatters.", vim.log.levels.WARN)
              end
            end
          end, "Format")
          map("n", "<leader>cs", vim.lsp.buf.signature_help, "Signature help")
        end,
      })

      -- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("html", {
        capabilities = capabilities,
      })

      vim.lsp.config("cssls", {
        capabilities = capabilities,
      })

      vim.lsp.config("tailwindcss", {
        capabilities = capabilities,
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      -- Enable configured servers
      vim.lsp.enable({ "ts_ls", "html", "cssls", "tailwindcss", "pyright", "lua_ls" })
    end,
  },
}
