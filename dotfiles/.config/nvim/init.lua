vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install `lazy.nvim` plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("custom.config")

-- Load lazy plugins
require("lazy").setup({
  { import = "custom.lazyPlugins" },
  { import = "custom.lazyPlugins.lsp.init" },
}, {
    defaults = { lazy = false },
    checker = { enabled = true , notify = false },
    ui = { border = "rounded" },
    performance = {
      cache = {
	enabled = true,
      },
    },
    debug = false,
  })

vim.cmd 'colorscheme material'
vim.g.material_style = "deep ocean"

require("custom.scripts")
require("custom.keymaps")
