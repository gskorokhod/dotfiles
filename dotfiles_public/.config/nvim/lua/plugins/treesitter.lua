return { -- parses language AST's and provides syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					-- Common UNIX tools
					"bash",
					"awk",
					"make",
					"gitignore",
					-- Common programming languages
					"c",
					"cpp",
					"rust",
					"java",
					"python",
					"lua",
					"haskell",
					"go",
					"php",
					-- Other development stuff
					"sql",
					-- Typesetting
					"markdown",
					"latex",
					"dot",
					-- Common formats for config files and data
					"xml",
					"json",
					"yaml",
					"toml",
					-- Vim-related stuff
					"query",
					"vim",
					-- Web development
					"javascript",
					"typescript",
					"tsx",
					"svelte",
					"css",
					"html",
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn",
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.inner",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.inner",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
}
