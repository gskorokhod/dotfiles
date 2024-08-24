return {
	{
		"quarto-dev/quarto-nvim",
		ft = { "quarto" },
		dev = false,
		opts = {
			lspFeatures = {
				languages = { "python", "julia", "bash", "lua", "html", "dot", "javascript", "typescript", "ojs" },
			},
			codeRunner = {
				enabled = true,
				default_method = "slime",
			},
		},
		dependencies = {
			{
				"jmbuhr/otter.nvim",
				dev = false,
				dependencies = {
					{ "neovim/nvim-lspconfig" },
				},
				opts = {
					buffers = {
						set_filetype = true,
					},
					handle_leading_whitespace = true,
				},
			},
		},
	},
}
