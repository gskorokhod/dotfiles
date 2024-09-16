return {
	{
		"mrcjkb/rustaceanvim",
		version = "^4", -- Recommended
		ft = { "rust" },
		config = function()
			vim.g.rustaceanvim = {
				-- Plugin configuration
				tools = {},
				-- LSP configuration
				server = {
					on_attach = function(client, bufnr)
						-- you can also put keymaps in here
					end,

					default_settings = {
						-- rust-analyzer language server configuration
						["rust-analyzer"] = {},
					},

					settings = function(project_root)
						local ra = require("rustaceanvim.config.server")
						return ra.load_rust_analyzer_settings(project_root, {
							settings_file_pattern = "rust-analyzer.json",
						})
					end,
				},
				-- DAP configuration
				dap = {},
			}
		end,
	},
}
