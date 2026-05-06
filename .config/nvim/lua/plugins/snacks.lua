-- HACK: docs @ https://github.com/folke/snacks.nvim/blob/main/docs
-- lua/sethy/plugins/snacks.lua

require("snacks").setup({
    styles = {
        input = {
            keys = {
                n_esc = { "<C-c>", { "cmp_close", "cancel" }, mode = "n", expr = true },
                i_esc = { "<C-c>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
            },
        }
    },

    -- Snacks Modules
    input = { enabled = true },
    quickfile = {
        enabled = true,
        exclude = { "latex" },
    },

    picker = {
        enabled = true,
        matchers = {
            frecency = true,
            cwd_bonus = false,
        },
        exclude = {
            ".git",
            "node_modules",
            "dist",
            "build",
        },
        formatters = {
            file = {
                filename_first = true,
                filename_only = false,
                icon_width = 2,
            },
        },
        layout = {
            preset = "telescope", -- defaults to this layout unless overridden
            cycle = false,
        },
        layouts = {
            select = {
                preview = false,
                layout = {
                    backdrop = false,
                    width = 0.6,
                    min_width = 80,
                    height = 0.4,
                    min_height = 10,
                    box = "vertical",
                    border = "rounded",
                    title = "{title}",
                    title_pos = "center",
                    { win = "input", height = 1, border = "bottom" },
                    { win = "list", border = "none" },
                    { win = "preview", title = "{preview}", width = 0.6, height = 0.4, border = "top" },
                }
            },
            telescope = {
                reverse = true, -- set to false for search bar on top
                layout = {
                    box = "horizontal",
                    backdrop = false,
                    width = 0.8,
                    height = 0.9,
                    border = "none",
                    {
                        box = "vertical",
                        { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
                        { win = "input", height = 1, border = "rounded", title = "{title} {live} {flags}", title_pos = "center" },
                    },
                    {
                        win = "preview",
                        title = "{preview:Preview}",
                        width = 0.50,
                        border = "rounded",
                        title_pos = "center",
                    },
                },
            },
            ivy = {
                layout = {
                    box = "vertical",
                    backdrop = false,
                    width = 0,
                    height = 0.4,
                    position = "bottom",
                    border = "top",
                    title = " {title} {live} {flags}",
                    title_pos = "left",
                    { win = "input", height = 1, border = "bottom" },
                    {
                        box = "horizontal",
                        { win = "list", border = "none" },
                        { win = "preview", title = "{preview}", width = 0.5, border = "left" },
                    },
                },
            },
        }
    },

    image = {
        enabled = function()
            return vim.bo.filetype == "markdown"
        end,
        doc = {
            float = false,
            inline = false,
            max_width = 50,
            max_height = 30,
            wo = { wrap = false },
        },
        convert = {
            notify = true,
            command = "magick"
        },
        img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments", "Archives/All-Vault-Images/", "~/Library", "~/Downloads" },
    },

    dashboard = {
        enabled = false,
        sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            {
                text = {
                    { " " },
                    { "󰒲  Loaded with vim.pack • Neovim 0.12", hl = "SnacksDashboardFooter" },
                },
                padding = 2,
            },
        },
    },
})

vim.keymap.set("n", "<leader>lg", function() require("snacks").lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>ll", function() require("snacks").lazygit.log() end, { desc = "Lazygit Logs" })
vim.keymap.set("n", "<leader>rN", function() require("snacks").rename.rename_file() end, { desc = "Fast Rename Current File" })
vim.keymap.set("n", "<leader>dB", function() require("snacks").bufdelete() end, { desc = "Delete or Close Buffer (Confirm)" })

-- Snacks Picker
vim.keymap.set( {"n","x"}, "<leader>pws", function() require("snacks").picker.grep_word() end, { desc = "Search Visual selection or Word" })
vim.keymap.set("n", "<leader>pk", function() require("snacks").picker.keymaps({ layout = "ivy" }) end, { desc = "Search Keymaps (Snacks Picker)" })

-- Git Stuff
vim.keymap.set("n", "<leader>gbr", function() require("snacks").picker.git_branches({ layout = "select" }) end, { desc = "Pick and Switch Git Branches" })

-- Other Utils
vim.keymap.set("n", "<leader>th", function() require("snacks").picker.colorschemes({ layout = "ivy" }) end, { desc = "Pick Color Schemes" })
vim.keymap.set("n", "<leader>vh", function() require("snacks").picker.help() end, { desc = "Help Pages" })

-- todo-comments w/ Snacks
vim.keymap.set("n", "<leader>pt", function() require("snacks").picker.todo_comments() end, { desc = "All" })
vim.keymap.set("n", "<leader>pT", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FORGETNOT", "FIXME", "!" } }) end, { desc = "mains" })

-- Top Pickers & Explorer
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Smart Find Files" })
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
-- vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "File Explorer" })

-- find
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sK", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
-- vim.keymap.set("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Projects" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.recent() end, { desc = "Recent" })

-- git
-- vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gb", function() require("snacks").picker.git_branches({ layout = "select" }) end, { desc = "Pick and Switch Git Branches" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })

-- gh
vim.keymap.set("n", "<leader>gi", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues (open)" })
vim.keymap.set("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.gh_pr() end, { desc = "GitHub Pull Requests (open)" })
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub Pull Requests (all)" })

-- Grep
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
-- vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Visual selection or word" })

-- search
vim.keymap.set("n", "<leader>s\"", function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "Search History" })
vim.keymap.set("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Autocmds" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer Lines" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Highlights" })
vim.keymap.set("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Icons" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Search for Plugin Spec" })
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

-- LSP
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References", nowait = true })
vim.keymap.set("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Goto T[y]pe Definition" })
vim.keymap.set("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, { desc = "C[a]lls Incoming" })
vim.keymap.set("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, { desc = "C[a]lls Outgoing" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "LSP Symbols" })
vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "LSP Workspace Symbols" })
