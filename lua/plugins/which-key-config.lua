return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>n", group = "org-mode", icon = { icon = "", hl = "WhichKeyGreen", color = "green" } },
        { "<leader>o", group = "obsidian", icon = { icon = "󰯂", hl = "WhichKeyPurple", color = "purple" } },
        {
          "<leader>fs",
          "<cmd>w<CR>",
          desc = "Save",
          icon = { icon = "󰆓", hl = "WhichKeyYellow", color = "yellow" },
        },
      },
    },
  },
}
