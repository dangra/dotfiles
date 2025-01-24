return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["xml"] = { "xmlformatter" },
        -- ["toml"] = { "taplo" },
      },
      formatters = {
        taplo = {
          append_args = { "-o", "indent_tables=true", "-o", "indent_entries=true" },
        },
      },
    },
  },
}
