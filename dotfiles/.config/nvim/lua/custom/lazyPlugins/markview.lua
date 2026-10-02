local function apply_markview_highlights()
  local colors = {
    blue = "#89b4fa",
    green = "#a6e3a1",
    mauve = "#cba6f7",
    peach = "#fab387",
    red = "#f38ba8",
    yellow = "#f9e2af",
    text = "#cdd6f4",
    muted = "#6c7086",
  }

  local set = vim.api.nvim_set_hl

  set(0, "MarkviewCode", { fg = colors.text, bg = "NONE" })
  set(0, "MarkviewCodeInfo", { fg = colors.blue, bg = "NONE", italic = true })
  set(0, "MarkviewInlineCode", { fg = colors.green, bg = "NONE" })

  set(0, "MarkviewBlockQuoteDefault", { fg = colors.muted, bg = "NONE" })
  set(0, "MarkviewBlockQuoteNote", { fg = colors.blue, bg = "NONE" })
  set(0, "MarkviewBlockQuoteOk", { fg = colors.green, bg = "NONE" })
  set(0, "MarkviewBlockQuoteWarn", { fg = colors.yellow, bg = "NONE" })
  set(0, "MarkviewBlockQuoteError", { fg = colors.red, bg = "NONE" })
  set(0, "MarkviewBlockQuoteSpecial", { fg = colors.mauve, bg = "NONE" })

  set(0, "MarkviewHeading1", { fg = colors.blue, bg = "NONE", bold = true })
  set(0, "MarkviewHeading2", { fg = colors.mauve, bg = "NONE", bold = true })
  set(0, "MarkviewHeading3", { fg = colors.green, bg = "NONE", bold = true })
  set(0, "MarkviewHeading4", { fg = colors.peach, bg = "NONE", bold = true })
  set(0, "MarkviewHeading5", { fg = colors.yellow, bg = "NONE", bold = true })
  set(0, "MarkviewHeading6", { fg = colors.text, bg = "NONE", bold = true })

  set(0, "MarkviewHeading1Sign", { fg = colors.blue, bg = "NONE" })
  set(0, "MarkviewHeading2Sign", { fg = colors.mauve, bg = "NONE" })
  set(0, "MarkviewHeading3Sign", { fg = colors.green, bg = "NONE" })
  set(0, "MarkviewHeading4Sign", { fg = colors.peach, bg = "NONE" })
  set(0, "MarkviewHeading5Sign", { fg = colors.yellow, bg = "NONE" })
  set(0, "MarkviewHeading6Sign", { fg = colors.text, bg = "NONE" })
end

return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },

    init = function()
      local group = vim.api.nvim_create_augroup("CustomMarkviewHighlights", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = apply_markview_highlights,
      })
    end,

    opts = function()
      local presets = require("markview.presets")

      return {
        preview = {
          icon_provider = "devicons",
          modes = { "n", "no", "c" },
          hybrid_modes = {},
        },

        markdown = {
          block_quotes = {
            default = {
              border = "▏",
              hl = "MarkviewBlockQuoteDefault",
            },
          },

          code_blocks = {
            style = "simple",
            sign = false,
            min_width = 0,
            pad_amount = 0,
            border_hl = "MarkviewCode",
            info_hl = "MarkviewCodeInfo",
            label_hl = "MarkviewCodeInfo",

            default = {
              block_hl = "MarkviewCode",
              pad_hl = "MarkviewCode",
            },
          },

          headings = {
            enable = true,
            shift_width = 0,
            org_indent = false,

            heading_1 = {
              style = "icon",
              icon = "󰉫 ",
              icon_hl = "MarkviewHeading1Sign",
              hl = "MarkviewHeading1",
            },
            heading_2 = {
              style = "icon",
              icon = "󰉬 ",
              icon_hl = "MarkviewHeading2Sign",
              hl = "MarkviewHeading2",
            },
            heading_3 = {
              style = "icon",
              icon = "󰉭 ",
              icon_hl = "MarkviewHeading3Sign",
              hl = "MarkviewHeading3",
            },
            heading_4 = {
              style = "icon",
              icon = "󰉮 ",
              icon_hl = "MarkviewHeading4Sign",
              hl = "MarkviewHeading4",
            },
            heading_5 = {
              style = "icon",
              icon = "󰉯 ",
              icon_hl = "MarkviewHeading5Sign",
              hl = "MarkviewHeading5",
            },
            heading_6 = {
              style = "icon",
              icon = "󰉰 ",
              icon_hl = "MarkviewHeading6Sign",
              hl = "MarkviewHeading6",
            },

            setext_1 = {
              style = "simple",
              hl = "MarkviewHeading1",
            },
            setext_2 = {
              style = "simple",
              hl = "MarkviewHeading2",
            },
          },

          horizontal_rules = presets.horizontal_rules.thin,
          tables = presets.tables.none,
        },
      }
    end,

    config = function(_, opts)
      require("markview").setup(opts)
      apply_markview_highlights()
      vim.keymap.set("n", "<leader>mv", "<cmd>Markview Toggle<CR>", { desc = "Toggle Markview" })
    end,
  },
}
