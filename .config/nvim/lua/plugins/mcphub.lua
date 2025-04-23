return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
    },
    -- comment the following line to ensure hub will be ready at the earliest
    --cmd = "MCPHub", -- lazy load by default

    -- build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
    -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
    build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts (see Advanced configuration)

    opts = {
      use_bundled_binary = true, -- Set to true if you want to use the bundled mcp-hub binary
      extensions = {
        avante = {
          make_slash_commands = true, -- make /slash commands from MCP server prompts
        },
      },
    },
  },
  {
    "yetone/avante.nvim",
    opts = {
      -- other config
      -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
      system_prompt = function()
        local mcphub = require("mcphub")
        local hub = mcphub.get_hub_instance()
        if hub then
          return hub:get_active_servers_prompt()
        else
          return "I'm an AI assistant. How can I help you today?"
        end
      end,
      -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
      custom_tools = function()
        local ok, mcphub_ext = pcall(require, "mcphub.extensions.avante")
        if ok then
          return {
            mcphub_ext.mcp_tool(),
          }
        else
          return {}
        end
      end,
    },
  },
}
