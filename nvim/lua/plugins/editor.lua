-- Editor enhancement plugins

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 500,
      preset = "modern",
    },
    config = function()
      local wk = require("which-key")
      wk.setup({
        delay = 500,
        preset = "modern",
      })

      -- Register keybinding groups
      wk.add({
        { "<leader>m", group = "Markdown" },
        { "<leader>w", desc = "Save file" },
        { "<leader>q", desc = "Quit" },
        { "<leader>e", desc = "Open file explorer" },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        -- Show hidden files by default
        view_options = {
          show_hidden = true,
        },
        -- Columns to display
        columns = {
          "icon",
        },
        -- Keymaps in oil buffer
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["g."] = "actions.toggle_hidden",
        },
      })

      -- Open oil in current directory
      vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "Open file explorer" })
    end,
  },
}
