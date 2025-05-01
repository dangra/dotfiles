return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "bundled_build.lua",
    opts = {
      use_bundled_binary = true,
      auto_approve = true,
    },
  },
  {
    "yetone/avante.nvim",
    opts = {
      -- The system_prompt type supports both a string and a function that returns a string.
      system_prompt = function()
        local mcphub = require("mcphub")
        local hub = mcphub.get_hub_instance()
        if hub then
          return hub:get_active_servers_prompt()
        else
          return "I'm an AI assistant. How can I help you today?"
        end
      end,
      -- The custom_tools type supports both a list and a function that returns a list.
      custom_tools = function()
        local ok, mcphub_ext = pcall(require, "mcphub.extensions.avante")
        if ok then
          return { mcphub_ext.mcp_tool() }
        else
          return {}
        end
      end,
    },
  },
}
