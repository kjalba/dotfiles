-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- vim ui2
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd", -- options: cmd(classic), msg(similar to noice)
		pager = { height = 1 },
		msg = { height = 0.5, timeout = 4500 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
	},
})

require("keymaps")
require("options")
require("pack")
require("current-theme")
