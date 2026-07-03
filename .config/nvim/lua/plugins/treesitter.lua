local treesitter = require("nvim-treesitter")

treesitter.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local ensure_installed = {
	"json",
	"javascript",
	"typescript",
	"tsx",
	"go",
	"yaml",
	"html",
	"css",
	"python",
	"http",
	"prisma",
	"markdown",
	"markdown_inline",
	"svelte",
	"graphql",
	"bash",
	"lua",
	"vim",
	"dockerfile",
	"gitignore",
	"query",
	"vimdoc",
	"c",
	"java",
	"rust",
	"ron",
}

treesitter.install(ensure_installed)

local function start_treesitter(buf)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
		return
	end

	local ft = vim.bo[buf].filetype
	if ft == "" then
		return
	end

	local lang = vim.treesitter.language.get_lang(ft)
	if not lang then
		return
	end

	local ok_add = pcall(vim.treesitter.language.add, lang)
	if not ok_add then
		vim.bo[buf].syntax = ft
		return
	end

	local ok_start = pcall(vim.treesitter.start, buf, lang)
	if not ok_start then
		vim.bo[buf].syntax = ft
		return
	end

	if ft ~= "yaml" and ft ~= "markdown" then
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		vim.bo[buf].smartindent = false
		vim.bo[buf].cindent = false
	end
end

local treesitter_group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true })

vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
	group = treesitter_group,
	pattern = "*",
	callback = function(args)
		start_treesitter(args.buf)
	end,
})

for _, buf in ipairs(vim.api.nvim_list_bufs()) do
	start_treesitter(buf)
end

-- NOTE: js,ts,jsx,tsx Auto Close Tags
-- Independent nvim-ts-autotag setup
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true, -- Auto-close tags
		enable_rename = true, -- Auto-rename pairs
		enable_close_on_slash = false, -- Disable auto-close on trailing `</`
	},
	per_filetype = {
		["html"] = {
			enable_close = true, -- Disable auto-closing for HTML
		},
		["typescriptreact"] = {
			enable_close = true, -- Explicitly enable auto-closing (optional, defaults to `true`)
		},
	},
})
