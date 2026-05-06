local telescope = require("telescope")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

telescope.load_extension("themes")

telescope.setup({
	defaults = {
		path_display = { "smart" },
		mappings = {
			i = {
				["<C-k>"] = actions.move_selection_previous,
				["<C-j>"] = actions.move_selection_next,
			},
		},
	},
	extensions = {
		themes = {
			enable_previewer = true,
			enable_live_preview = true,
			persist = {
				enabled = true,
				path = vim.fn.stdpath("config") .. "/lua/colorscheme.lua",
			},
		},
	},
})

-- Keymaps
vim.keymap.set("n", "<leader>pr", "<cmd>Telescope oldfiles<CR>", { desc = "Fuzzy find recent files" })
vim.keymap.set("n", "<leader>pWs", function()
	local word = vim.fn.expand("<cWORD>")
	builtin.grep_string({ search = word })
end, { desc = "Find Connected Words under cursor" })

-- Telescope functionality in my Zettelkasten directory
vim.keymap.set("n", "<leader>zf", function()
	builtin.find_files({
		cwd = "~/Zettelkasten",
		file_ignore_patterns = { "__assets/" },
	})
end, { desc = "Find files in Zettelkasten" })

vim.keymap.set("n", "<leader>zg", function()
	builtin.live_grep({
		cwd = "~/Zettelkasten",
		file_ignore_patterns = { "__assets/" },
	})
end, { desc = "Grep in Zettelkasten" })
require("telescope.multigrep").setup()

vim.keymap.set(
	"n",
	"<leader>ths",
	"<cmd>Telescope themes<CR>",
	{ noremap = true, silent = true, desc = "Theme Switcher" }
)
