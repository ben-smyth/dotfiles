-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
-- the above link provides the name required for this list
local declared_servers = {
	-- "pyright",
	-- "gopls",
	-- "lua_ls",
	-- "html",
	-- -- "htmx",
	-- "cssls",
	-- -- "groovyls",
	-- "dockerls",
	-- "docker_compose_language_service",
	-- "ansiblels",
	-- "yamlls",
	-- "jsonls",
	-- "puppet",
	-- "ruby_lsp",
	-- "bashls"
}

return {
	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = 'rafamadriz/friendly-snippets',

		-- use a release tag to download pre-built binaries
		version = '*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' for mappings similar to built-in completion
			-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
			-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
			-- See the full "keymap" documentation for information on defining your own keymap.
			keymap = { preset = 'none', 
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<C-e>'] = { 'hide' },
				['<Tab>'] = {
					function(cmp)
						if cmp.snippet_active() then return cmp.accept()
						else return cmp.select_and_accept() end
					end,
					'snippet_forward',
					'fallback'
				},
				['<Up>'] = { 'select_prev', 'fallback' },
				['<Down>'] = { 'select_next', 'fallback' },
				['<C-p>'] = { 'select_prev', 'fallback' },
				['<C-n>'] = { 'select_next', 'fallback' },

				['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

				['<S-Tab>'] = { 'snippet_backward', 'fallback' },

				['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
			},

			appearance = {
				-- Sets the fallback highlight groups to nvim-cmp's highlight groups
				-- Useful for when your theme doesn't support blink.cmp
				-- Will be removed in a future release
				use_nvim_cmp_as_default = true,
				-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { 'lsp', 'path', 'snippets', 'buffer' },
			},
		},
		opts_extend = { "sources.default" }
	},
	{
		-- LSP Configuration with Mason
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			'saghen/blink.cmp',
		},
		-- version = "v1.6.0",
		config = function()
			-- Setup LSP servers with Mason
			require("mason").setup({
				ui = {
					border = "rounded",
					border_chars = {
						top = "─",
						bottom = "─",
						left = "│",
						right = "│",
						top_left = "╭",
						top_right = "╮",
						bottom_left = "╰",
						bottom_right = "╯",
					},
				},
			})
			require("mason-lspconfig").setup({
				ensure_installed = declared_servers,
				automatic_installation = true,
			})

			-- Define on_attach function
			local on_attach = function(client, bufnr)
				local nmap = function(keys, func, desc)
					if desc then desc = "LSP: " .. desc end
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
				end

				nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
				nmap("K", vim.lsp.buf.hover, "Hover Documentation")
				nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
			end

			local lspconfig = require('lspconfig')
			local servers = declared_servers

			for _, server in ipairs(servers) do
				lspconfig[server].setup {
					capabilities = require('blink.cmp').get_lsp_capabilities(), -- Get capabilities here
					on_attach = on_attach,
				}
			end
		end,
	},
}
