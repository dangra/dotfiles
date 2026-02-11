return {
  {
    "yetone/avante.nvim",
    --lazy = true,
    event = "VeryLazy",
    build = "make",

    opts = {
      provider = "copilot",
      --cursor_applying_provider = "copilot",
      behaviour = {
        --enable_cursor_planning_mode = true,
      },
      providers = {
        copilot = {
          --model = "claude-3.7-sonnet-thought"
          --model = "claude-3.7-sonnet",
          --model = "gemini-2.5-pro",
          --model = "gpt-4.1",
          --model = "claude-sonnet-4",
        },
      },
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
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      sources = {
        default = { "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {},
          },
        },
      },
    },
  },
}
