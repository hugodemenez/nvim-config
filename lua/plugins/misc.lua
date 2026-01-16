return {
  -- Which-key for keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 200,
      icons = { mappings = false },
    },
  },

  -- Detect tabstop/shiftwidth automatically
  { "tpope/vim-sleuth" },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- nvim-treesitter does not support lazy loading
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
      -- Install parsers (async, runs in background)
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "query",
        "javascript", "typescript", "tsx",
        "html", "css", "json", "yaml", "toml",
        "python", "go", "rust", "c",
        "bash", "markdown", "markdown_inline",
        "gitcommit", "gitignore", "diff",
        "regex", "dockerfile", "sql",
      })
    end,
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Surround text objects
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- Comment toggling
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n",          desc = "Comment line" },
      { "gc",  mode = { "n", "v" }, desc = "Comment" },
    },
    opts = {},
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = false },
    },
  },

  -- Floating terminal
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { "<C-\\>", "<cmd>ToggleTerm direction=float<CR>", desc = "Toggle terminal" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "rounded" },
    },
  },

  -- Wakatime (optional - remove if not needed)
  { "wakatime/vim-wakatime", event = "VeryLazy" },

  -- Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
    -- Tab will accept Copilot suggestions (default behavior)
  },

  -- Hide/mask sensitive values in .env files
  {
    "laytan/cloak.nvim",
    config = function()
      require("cloak").setup({
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        patterns = {
          {
            file_pattern = {
              ".env*",
              "*.env",
              "*.env.local",
            },
            cloak_pattern = "=.+",
          },
        },
      })
    end,
  },

  -- Conform.nvim for formatting (supports both LSP and external formatters)
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
      },
    },
  },
}
