return {
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    config = function()
      require("render-markdown").setup({})
    end,
  },
  -- {
  --   "OXY2DEV/markview.nvim",
  --   lazy = false, -- Recommended
  --   -- ft = "markdown" -- If you decide to lazy-load anyway
  --
  --   dependencies = {
  --     -- You will not need this if you installed the
  --     -- parsers manually
  --     -- Or if the parsers are in your $RUNTIMEPATH
  --     "nvim-treesitter/nvim-treesitter",
  --
  --     "nvim-tree/nvim-web-devicons",
  --   },
  -- },
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    keys = {
      -- normal mode maps
      { "<leader>oo", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
      { "<leader>of", "<cmd>ObsidianQuickSwitch<cr>", desc = "Find note" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Show backlinks" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Show tags" },
      { "<leader>oi", "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },
      { "<leader>og", "<cmd>ObsidianSearch<cr>", desc = "Grep notes" },
      { "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Show all links in file" },
      { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch to another workspace" },
      { "<leader>op", "<cmd>ObsidianPasteImg<cr>", desc = "Paste image from clipboard" },
      { "<leader>or", "<cmd>ObsidianRename<cr>", desc = "Rename this note" },
      { "<leader>os", "<cmd>ObsidianTOC<cr>", desc = "Pick a Symbol" },
      -- dailies
      { "<leader>odt", "<cmd>ObsidianToday<cr>", desc = "Open today" },
      { "<leader>ody", "<cmd>ObsidianYesterday<cr>", desc = "Open yesterday" },
      { "<leader>odf", "<cmd>ObsidianTomorrow<cr>", desc = "Open tomorrow" },
      { "<leader>odd", "<cmd>ObsidianDailies<cr>", desc = "Open dailies" },

      -- visual mode maps
      -- these work on ranges, so use `:` instead of `<cmd>`
      { "<leader>oe", ":ObsidianExtractNote<cr>", desc = "Extract selected to new note", mode = "v" },
      { "<leader>ol", ":ObsidianLink<cr>", desc = "Create link to existing note" },
      { "<leader>on", ":ObsidianLinkNew<cr>", desc = "Create link to new note", mode = "v" },
      -- remove line breaks
      {
        "<leader>ox",
        ":w<Home>silent <End> !pandoc -f gfm+wikilinks_title_after_pipe -t gfm --wrap=none | pbcopy<cr>",
        desc = "Export to GFM",
        mode = "v",
      },
    },
    -- ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
      "BufReadPre "
        .. vim.fn.expand("~")
        .. "Documents/vault/**.md",
      "BufNewFile " .. vim.fn.expand("~") .. "Documents/vault/**.md",
    },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- install `markdown` and `markdown_inline` grammars
      "nvim-treesitter/nvim-treesitter",
      "folke/which-key.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Documents/vault",
        },
      },
      daily_notes = {
        folder = "Daily",
      },

      notes_subdir = "Incoming",
      -- Where to put new notes. Valid options are
      --  * "current_dir" - put new notes in same directory as the current buffer.
      --  * "notes_subdir" - put new notes in the default notes subdirectory.
      new_notes_location = "notes_subdir",

      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        local new_title = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          new_title = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        end
        return title or new_title
      end,

      templates = {
        folder = "Templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({ "open", url }) -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,

      -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
      open_app_foreground = true,
      ui = { enable = false },

      wiki_link_func = "use_alias_only",
      disable_frontmatter = true,
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("MarkdownSettings", { clear = true }),
        pattern = "markdown",
        callback = function()
          vim.opt_local.linebreak = true
          vim.opt_local.textwidth = 80
          vim.opt_local.colorcolumn = "80"
          vim.opt_local.conceallevel = 2
          vim.opt.concealcursor = "nc"
          vim.opt_local.spell = true
          vim.opt_local.wrap = false
        end,
      })
    end,
    -- config = function(_, opts)
    --   require('obsidian').setup(opts)
    --
    --   -- reload the current color scheme to override obsidians.nvim's colors
    --   local colorscheme = vim.g.colors_name
    --   vim.cmd.colorscheme(colorscheme)
    -- end,
  },
}
