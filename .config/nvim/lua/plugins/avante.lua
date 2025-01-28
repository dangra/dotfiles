return {
  {
    "yetone/avante.nvim",
    --lazy = true,
    event = "VeryLazy",
    build = "make",

    opts = {
      provider = "copilot",
      copilot = { model = "claude-3.5-sonnet" },
      hints = { enabled = false },
      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>a", group = "ai" },
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = true,
    -- disable to use vim.ui.input and vim.ui.select from Snacks.input
    opts = { input = { enabled = false }, select = { enabled = false } },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    ft = function(_, ft)
      vim.list_extend(ft, { "Avante" })
    end,
  },

  -- nvim-cmp compatibility layer for Avante
  {
    "saghen/blink.compat",
    lazy = true,
    opts = {},
    config = function()
      require("cmp").ConfirmBehavior = { Insert = "insert", Replace = "replace" }
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = true,
    opts = {
      sources = {
        default = { "avante_commands", "avante_mentions", "avante_files" },
        compat = {
          "avante_commands",
          "avante_mentions",
          "avante_files",
        },
        providers = {
          -- LSP is typically ~60
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 90, -- show at a higher priority than lsp
            opts = {},
          },
          avante_files = {
            name = "avante_files",
            module = "blink.compat.source",
            score_offset = 100, -- ~40 points higher than LSP ()
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000, -- show at a higher priority than lsp
            opts = {},
          },
        },
      },
    },
  },
}
