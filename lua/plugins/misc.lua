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
      { "gcc", mode = "n", desc = "Comment line" },
      { "gc", mode = { "n", "v" }, desc = "Comment" },
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

  -- Markdown rendering in buffer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      code = {
        sign = false,
      },
      restart_highlighter = true,
    },
  },

  -- Copilot
  {
    "github/copilot.vim",
    event = "InsertEnter",
  },
}
