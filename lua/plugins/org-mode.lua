return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  ft = { "org" },
  dependencies = {
    {
      "akinsho/org-bullets.nvim",
      config = function()
        require("org-bullets").setup()
      end,
    },
  },
  config = function()
    -- Setup orgmode
    require("orgmode").setup({
      org_agenda_files = "~/org/**/*",
      org_default_notes_file = "~/org/refile.org",
      org_startup_indented = true,
      -- make org-mode work with nvim-ufo
      org_startup_folded = "inherit",
      mappings = {
        prefix = "<leader>n",
      },
    })

    -- NOTE: If you are using nvim-treesitter with ~ensure_installed = "all"~ option
    -- add ~org~ to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
  init = function()
    -- Add an autocommand to set linebreak and textwidth for Markdown files
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("OrgmodeSettings", { clear = true }),
      pattern = "org",
      callback = function()
        vim.opt_local.linebreak = true
        vim.opt_local.textwidth = 80
        vim.opt_local.colorcolumn = "80"
        vim.opt_local.conceallevel = 2
        vim.opt.concealcursor = "nc"
        vim.opt_local.wrap = false
        vim.opt_local.spell = true
      end,
    })
  end,
}
