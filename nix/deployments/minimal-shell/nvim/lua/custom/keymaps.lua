--
-- BINDINGS
--

-- Telescope keymaps
local telescope = require('telescope.builtin')
local telescope_live_grep_args = require('telescope').extensions.live_grep_args
vim.keymap.set('n', '<leader>gf', function()
    telescope.find_files({ initial_mode = "insert", find_command = {'rg', '--files', '--hidden', '-g', '!.git' }}) -- Files in insert mode
end, { desc = "Find Files Insert Mode)" })

vim.keymap.set('n', 'T', function()
    telescope_live_grep_args.live_grep_args({ initial_mode = "insert" }) -- Grep in insert mode
end, { desc = "Live Grep (Normal Mode)" })

vim.keymap.set('n', '<S-Tab>', function()
    telescope.buffers({ initial_mode = "normal" }) -- Buffers in normal mode
end, { desc = "Buffers (Normal Mode)" })

vim.keymap.set('n', 'F', function()
    telescope.git_files({ show_untracked = true})
end, { desc = 'Search [G]it [F]iles' })

vim.keymap.set('n', 't', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.cmd('command! Bca BufferCloseAllButCurrent')
vim.cmd('command! Nvt NvimTreeToggle')
vim.cmd('command! Nvr NvimTreeRefresh')
vim.cmd('command! GIF GoIfErr')

vim.keymap.set("n", "<Tab>", ":NvimTreeOpen<CR>", { desc = "nvim-tree: toggle ", noremap = true, silent = true, nowait = true })
