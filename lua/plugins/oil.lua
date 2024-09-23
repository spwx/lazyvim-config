return {
  "stevearc/oil.nvim",
  opts = {},
  dependencies = { "echasnovski/mini.icons" },
  config = function()
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    require("oil").setup({})
  end,
}
