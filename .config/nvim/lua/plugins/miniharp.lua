local miniharp = require("miniharp")

-- Run the setup with the options you provided
miniharp.setup({
	autoload = true,
	autosave = true,
	show_on_autoload = false,
	ui = {
		position = "center",
		show_hints = true,
		enter = true,
	},
})

-- Helper function to recreate Harpoon's 1-4 selection behavior
local function select_mark(index)
	local marks = miniharp.list()
	if marks and marks[index] then
		vim.cmd("edit " .. vim.fn.fnameescape(marks[index].file))
		pcall(vim.api.nvim_win_set_cursor, 0, { marks[index].lnum, marks[index].col })
	else
		vim.notify("Miniharp: No mark at index " .. index, vim.log.levels.WARN)
	end
end

-- Miniharp Core API Keymaps
vim.keymap.set("n", "<leader>ma", miniharp.add_file, { desc = "Miniharp add file" })
vim.keymap.set("n", "<leader>mt", miniharp.toggle_file, { desc = "Miniharp toggle (add/remove) current file" })
vim.keymap.set("n", "<leader>mc", miniharp.clear, { desc = "Miniharp clear all marks" })
vim.keymap.set("n", "<C-e>", miniharp.show_list, { desc = "Miniharp show native list" })

-- Miniharp marked files (using our custom helper)
vim.keymap.set("n", "<leader>1", function()
	select_mark(1)
end, { desc = "Miniharp switch to 1st file" })
vim.keymap.set("n", "<leader>2", function()
	select_mark(2)
end, { desc = "Miniharp switch to 2nd file" })
vim.keymap.set("n", "<leader>3", function()
	select_mark(3)
end, { desc = "Miniharp switch to 3rd file" })
vim.keymap.set("n", "<leader>4", function()
	select_mark(4)
end, { desc = "Miniharp switch to 4th file" })

-- Toggle previous & next buffers stored within Miniharp list
vim.keymap.set("n", "<C-S-P>", miniharp.prev, { desc = "Miniharp prev file" })
vim.keymap.set("n", "<C-S-N>", miniharp.next, { desc = "Miniharp next file" })
