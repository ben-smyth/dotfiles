-- nvim-treesitter `main` branch (the rewrite).
-- The old `master` branch was archived and is incompatible with Nvim 0.12+.
-- `main` has no `nvim-treesitter.configs` module — parsers are installed via
-- `require('nvim-treesitter').install({...})` and highlighting must be started
-- per-buffer with `vim.treesitter.start()`.

local ensure_parsers = {
  'bash',
  'c',
  'cpp',
  'go',
  'groovy',
  'hcl',
  'html',
  'javascript',
  'lua',
  'markdown',
  'markdown_inline',
  'puppet',
  'python',
  'query',
  'rust',
  'tsx',
  'typescript',
  'vim',
  'vimdoc',
}

-- Filetypes that should get treesitter highlighting on entry.
local highlight_filetypes = {
  'bash',
  'c',
  'cpp',
  'go',
  'groovy',
  'hcl',
  'html',
  'javascript',
  'javascriptreact',
  'lua',
  'markdown',
  'puppet',
  'python',
  'query',
  'rust',
  'sh',
  'terraform',
  'typescript',
  'typescriptreact',
  'vim',
  'help',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = function()
      require('nvim-treesitter').install(ensure_parsers):wait(300000)
    end,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    config = function()
      require('nvim-treesitter').setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = highlight_filetypes,
        callback = function(args)
          local ok = pcall(vim.treesitter.start, args.buf)
          if ok then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
