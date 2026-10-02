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

-- Keep compatible parser directories ahead of stale parser artifacts that can be
-- left in lazy.nvim plugin checkouts after nvim-treesitter branch changes.
local function prefer_stable_treesitter_parsers()
  local parser_roots = { vim.fn.stdpath('data') .. '/site' }

  for _, parser in ipairs(vim.api.nvim_get_runtime_file('parser/lua.so', true)) do
    local root = vim.fs.dirname(vim.fs.dirname(parser))
    if root:match('/lib/nvim$') then
      table.insert(parser_roots, root)
    end
  end

  for index = #parser_roots, 1, -1 do
    vim.opt.runtimepath:remove(parser_roots[index])
    vim.opt.runtimepath:prepend(parser_roots[index])
  end
end

prefer_stable_treesitter_parsers()

vim.cmd 'colorscheme material'
vim.g.material_style = "deep ocean"
vim.treesitter.language.register('hcl', 'terraform')
vim.treesitter.language.register('hcl', 'tf')

require("custom.scripts")
require("custom.keymaps")
