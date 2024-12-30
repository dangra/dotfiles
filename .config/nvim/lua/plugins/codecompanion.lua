return {
  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "saghen/blink.cmp",
        opts = function(_, opts)
          opts.sources.default = vim.list_extend(opts.sources.default or {}, { "codecompanion" })
          opts.sources.providers.codecompanion = {
            name = "CodeCompanion",
            module = "codecompanion.providers.completion.blink",
            enabled = true,
          }
        end,
      },
    },
    opts = {},
    --config = true,
  },
}
