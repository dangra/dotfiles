return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- add caddyfile support
    require("nvim-treesitter.parsers").get_parser_configs().caddy = {
      install_info = {
        url = "https://github.com/Samonitari/tree-sitter-caddy",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
      },
      filetype = "caddy",
    }
    vim.filetype.add({
      pattern = {
        ["Caddyfile"] = "caddy",
      },
    })

    vim.list_extend(opts.ensure_installed, {
      "c",
      "bash",
      "eex",
      "elixir",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "caddy",
      "cmake",
      "css",
      "devicetree",
      "gitcommit",
      "gitignore",
      "glsl",
      "go",
      "graphql",
      "http",
      "html",
      "javascript",
      "just",
      "kconfig",
      "scss",
      "sql",
    })
  end,
}
