require("custom.todofloat").setup({
    target_file = "~/Zettelkasten/todo.md",
})

-- Keymap for TodoFloat
vim.keymap.set("n", "<leader>td", "<cmd>Td<CR>", { desc = "Toggle Todo Float Window" })
