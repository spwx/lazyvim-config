-- from: https://github.com/linkarzu/dotfiles-latest/blob/d523789283b60d2cfcd12c9cd5d938ae7c321b1d/neovim/neobean/lua/config/keymaps.lua#L910
-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file
  vim.cmd("normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line
      vim.fn.cursor(line, 1)
      -- Fold the heading if it matches the level
      if vim.fn.foldclosed(line) == -1 then
        vim.cmd("normal! za")
      end
    end
  end
end

local function fold_markdown_headings(levels)
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
end, { desc = "[P]Fold all headings level 1 or above" })

-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
end, { desc = "[P]Fold all headings level 2 or above" })

-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
end, { desc = "[P]Fold all headings level 3 or above" })

-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
end, { desc = "[P]Fold all headings level 4 or above" })

return {
  { "jghauser/follow-md-links.nvim" },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
    -- reset defaults
    opts = {
      -- Mimic org-indent-mode behavior by indenting everything under a heading based on the
      -- level of the heading. Indenting starts from level 2 headings onward.
      sign = {
        -- Turn on / off sign rendering
        enabled = true,
        -- Applies to background of sign text
        highlight = "RenderMarkdownSign",
      },
      code = {
        sign = true,
      },
      heading = {
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("~/.config/nvim-mylazy/lua/plugins/markdownlint-cli2.yaml"), "--" },
        },
      },
    },
  },
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
  },
}
