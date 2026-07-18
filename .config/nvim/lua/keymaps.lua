-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- restart
vim.keymap.set("n", "<leader>re", "<cmd>restart<cr>", {
    desc = "Restart Neovim (:restart)",
})

-- Go back to last visited buffer
vim.keymap.set("n", "<leader>tab", "<C-^>", { desc = "Toggle alternate file" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- vim: ts=2 sts=2 sw=2 et

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", opts)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", opts)

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", opts)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", opts)
-- vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
-- vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', vim.tbl_extend('force', opts, { desc = 'Close current buffer' }))
vim.keymap.set("n", "<leader>b", "<cmd> enew <CR>", vim.tbl_extend("force", opts, { desc = "Open new buffer" }))

-- Toggle line wrapping
vim.keymap.set("n", "<leader>lw", "<cmd>set wrap!<CR>", opts)

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', opts)

local function create_tmux_project()
	local project_name = vim.trim(vim.fn.input("New project name: "))

	if project_name == "" then
		return
	end

	local result = vim.fn.jobstart({ vim.fn.expand("~/scripts/new-tmux-project"), project_name }, { detach = true })

	if result <= 0 then
		vim.notify("Failed to start new tmux project flow", vim.log.levels.ERROR)
	end
end

--Starts new tmux session from in here
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>pn", create_tmux_project, vim.tbl_extend("force", opts, { desc = "Create new project in ~/dev" }))

-- Window management
vim.keymap.set("n", "<leader>wv", "<C-w>v", opts) -- split window vertically
vim.keymap.set("n", "<leader>wi", "<C-w>s", opts) -- split window horizontally
vim.keymap.set("n", "<leader>we", "<C-w>=", opts) -- make split windows equal width & height
vim.keymap.set("n", "<leader>wx", ":close<CR>", opts) -- close current split window

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
vim.keymap.set("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

-- Unmaps s in normal mode so that I can use it for surround (mini surround) instead of substitute
vim.keymap.set("n", "s", "<Nop>")

vim.keymap.set(
	"n",
	"<leader>zx",
	"<cmd>!chmod +x %<CR>",
	vim.tbl_extend("force", opts, { desc = "Makes file executable" })
)

-- Sources entire file and allows me to execute single line in Lua
vim.keymap.set("n", "<leader>xf", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>xl", ":.lua<CR>")
vim.keymap.set("v", "<leader>xl", ":lua<CR>")

-- Easier navigation in Quickfix list
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- [J]ump directly to files
vim.keymap.set({ "n", "v", "x" }, "<leader>jv", "<Cmd>edit $MYVIMRC<CR>", { desc = "Edit " .. vim.fn.expand("$MYVIMRC") })
vim.keymap.set({ "n", "v", "x" }, "<leader>jz", "<Cmd>e ~/.config/zsh/.zshrc<CR>", { desc = "Edit .zshrc" })
-- Jump to Pico-8 config
vim.keymap.set({ "n", "v", "x" }, "<leader>jp", "<Cmd>e ~/Library/Application\\ Support/pico-8/config.txt<CR>", { desc = "Edit Pico-8 config" })
-- Open the Sioyek directory (Since it has multiple files like keys_user.config and prefs_user.config)
-- This will open the folder in Neovim's file explorer (like netrw, oil, or nvim-tree)
vim.keymap.set({ "n", "v", "x" }, "<leader>js", "<Cmd>e ~/Library/Application\\ Support/sioyek/<CR>", { desc = "Open Sioyek config folder" })
vim.keymap.set({ "n", "v", "x" }, "<leader>jt", "<Cmd>e ~/.config/tmux/tmux.conf<CR>", { desc = "Edit Tmux config" })
vim.keymap.set({ "n", "v", "x" }, "<leader>jg", "<Cmd>e ~/.config/ghostty/config<CR>", { desc = "Edit Ghostty config" })
vim.keymap.set({ "n", "v", "x" }, "<leader>ja", "<Cmd>e ~/.config/aerospace/aerospace.toml<CR>", { desc = "Edit Aerospace config" })
vim.keymap.set({ "n", "v", "x" }, "<leader>jk", "<Cmd>e ~/.config/karabiner/karabiner.json<CR>", { desc = "Edit Aerospace config" })
