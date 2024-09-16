return {
	-- debug adapter protocol
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"nvim-neotest/nvim-nio",
				"rcarriga/nvim-dap-ui",
				config = function()
					vim.fn.sign_define("DapBreakpoint", { text = "🦆", texthl = "", linehl = "", numhl = "" })
					require("dapui").setup()
				end,
			},
			{
				"mfussenegger/nvim-dap-python",
				config = function()
					require("dap-python").setup()
					require("dap.ext.vscode").load_launchjs("launch.json")
				end,
			},
		},
		keys = {
			{ "<leader>db", ":lua require'dap'.toggle_breakpoint()<cr>", desc = "debug breakpoint" },
			{ "<leader>dc", ": lua require'dap'.continue()<cr>", desc = "debug" },
			{ "<leader>do", ": lua require'dap'.step_over()<cr>", desc = "debug over" },
			{ "<leader>dO", ": lua require'dap'.step_out()<cr>", desc = "debug out" },
			{ "<leader>di", ": lua require'dap'.step_into()<cr>", desc = "debug into" },
			{ "<leader>dr", ": lua require'dap'.repl_open()<cr>", desc = "debug repl" },
			{ "<leader>du", ": lua require'dapui'.toggle()<cr>", desc = "debug ui" },
		},
	},
}
