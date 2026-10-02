return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  cmd = "Obsidian",
  keys = {
    { "<leader>oo", "<cmd>Obsidian quick_switch<CR>", desc = "Obsidian quick switch" },
    { "<leader>os", "<cmd>Obsidian search<CR>", desc = "Obsidian search" },
    { "<leader>on", "<cmd>Obsidian new<CR>", desc = "Obsidian new note" },
    { "<leader>ot", "<cmd>Obsidian today<CR>", desc = "Obsidian today" },
    { "<leader>ob", "<cmd>Obsidian backlinks<CR>", desc = "Obsidian backlinks" },
    { "<leader>ol", "<cmd>Obsidian links<CR>", desc = "Obsidian links" },
    { "<leader>oc", "<cmd>Obsidian toggle_checkbox<CR>", desc = "Obsidian toggle checkbox" },
  },
  event = {
    "BufReadPre /Users/bensmyth/Documents/bens_literal_everything/*.md",
    "BufNewFile /Users/bensmyth/Documents/bens_literal_everything/*.md",
    "BufReadPre /Users/bensmyth/Documents/bens_literal_everything/**/*.md",
    "BufNewFile /Users/bensmyth/Documents/bens_literal_everything/**/*.md",
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "bens_literal_everything",
        path = "/Users/bensmyth/Documents/bens_literal_everything",
      },
    },
    picker = {
      name = "telescope.nvim",
    },
    statusline = {
      enabled = false,
    },
    callbacks = {
      enter_note = function()
        vim.keymap.set("n", "gd", "<cmd>Obsidian follow_link<CR>", {
          buffer = true,
          desc = "Obsidian follow link/definition",
        })
      end,
    },
  },
}
