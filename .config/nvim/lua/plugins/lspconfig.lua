return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_lines = {
          current_line = true,
        },
      },
      inlay_hints = {
        enabled = false,
      },

      servers = {
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand("~/.rbenv/shims/ruby-lsp") },
        },
        rubocop = {
          mason = false,
          cmd = { vim.fn.expand("~/.rbenv/shims/rubocop") },
        },
        harper_ls = {
          settings = {
            ["harper-ls"] = {
              linters = {
                SentenceCapitalization = false,
                SpellCheck = false,
              },
            },
          },
        },
      },
    },
  },
}
