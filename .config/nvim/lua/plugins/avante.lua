return {
  {
    "yetone/avante.nvim",
    lazy = true,
    event = "VeryLazy",
    build = "make",

    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      copilot = { model = "claude-3.5-sonnet" },
      hints = { enabled = false },
      file_selector = {
        provider = "fzf",
        provider_opts = {},
      },
    },

    dependencies = {
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = function(_, ft)
          vim.list_extend(ft, { "Avante" })
        end,
      },
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            { "<leader>a", group = "ai" },
          },
        },
      },
    },
  },

  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = function(_, opts)
      opts.input.enabled = false
      opts.select.enabled = false
    end,
  },

  {
    "saghen/blink.compat",
    lazy = true,
    opts = {},
    config = function()
      -- monkeypatch cmp.ConfirmBehavior for Avante
      require("cmp").ConfirmBehavior = {
        Insert = "insert",
        Replace = "replace",
      }
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = true,
    opts = function(_, opts)
      opts.sources.compat =
        vim.list_extend(opts.sources.compat, { "avante_commands", "avante_mentions", "avante_files" })
    end,
  },
}
