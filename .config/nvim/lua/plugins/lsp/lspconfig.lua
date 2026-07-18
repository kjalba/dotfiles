-- NOTE: LSP Keybinds
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings
		local opts = { buffer = ev.buf, silent = true }
		-- keymaps moved to snacks.lua
	end,
})

-- NOTE: Diagnostic Setup
-- Define sign icons for each severity
local signs = {
	[vim.diagnostic.severity.ERROR] = " ",
	[vim.diagnostic.severity.WARN] = " ",
	[vim.diagnostic.severity.HINT] = "󰠠 ",
	[vim.diagnostic.severity.INFO] = " ",
}

-- update diagnostic config function
vim.diagnostic.config({
	signs = { text = signs },
	virtual_text = true,
	underline = true, -- Always on
	update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = true,
	},
})

-- <leader>lx toggle for virtual text (no hover changes)
vim.keymap.set("n", "<leader>lx", function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
end, { desc = "Toggle LSP virtual text" })

-- NOTE: Setup servers
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Native LSP capabilities (if dropping cmp_nvim_lsp)
-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Global LSP settings (applied to all servers)
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- A Pico-8 project is any directory (or ancestor) holding a .p8 cart.
-- Used to route its .lua sources to pico8_ls instead of lua_ls.
local function pico8_project_root(path)
	for dir in vim.fs.parents(path) do
		if #vim.fn.glob(dir .. "/*.p8", true, true) > 0 then
			return dir
		end
	end
end

-- Configure and enable LSP servers
-- lua_ls
vim.lsp.config("lua_ls", {
	-- Stay off Pico-8 projects; those buffers belong to pico8_ls
	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		if pico8_project_root(fname) then
			return
		end
		local root = vim.fs.root(bufnr, {
			{ ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
			{ ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
			{ ".git" },
		})
		on_dir(root or vim.fs.dirname(fname))
	end,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			completion = {
				callSnippet = "Replace",
			},
			-- workspace = {
			--     library = {
			--         [vim.fn.expand("$VIMRUNTIME/lua")] = true,
			--         [vim.fn.stdpath("config") .. "/lua"] = true,
			--     },
			-- },
		},
	},
})

-- emmet_language_server
vim.lsp.config("emmet_language_server", {
	filetypes = {
		"css",
		"html",
		"javascript",
		"javascriptreact",
		"less",
		"typescriptreact",
	},
	init_options = {
		includeLanguages = {},
		excludeLanguages = {},
		extensionsPath = {},
		preferences = {},
		showAbbreviationSuggestions = true,
		showExpandedAbbreviation = "always",
		showSuggestionsAsSnippets = false,
		syntaxProfiles = {},
		variables = {},
	},
})

-- emmet_ls
vim.lsp.config("emmet_ls", {
	filetypes = {
		"astro",
		"html",
		"typescriptreact",
		"javascriptreact",
		"css",
		"sass",
		"scss",
		"less",
		"svelte",
	},
})

-- ts_ls (TypeScript/JavaScript)
vim.lsp.config("ts_ls", {
	workspace_required = false,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	single_file_support = true,
	init_options = {
		preferences = {
			includeCompletionsForModuleExports = true,
			includeCompletionsForImportStatements = true,
		},
	},
	settings = {
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayVariableTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
			},
		},
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "none",
				includeInlayVariableTypeHints = false,
				includeInlayFunctionParameterTypeHints = false,
			},
		},
	},
})

-- gopls
vim.lsp.config("gopls", {
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

-- css
vim.lsp.config("cssls", {
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true },
	single_file_support = true,
	settings = {
		css = {
			lint = {
				unknownAtRules = "ignore",
			},
			validate = true,
		},
		scss = {
			lint = {
				unknownAtRules = "ignore",
			},
			validate = true,
		},
		less = {
			lint = {
				unknownAtRules = "ignore",
			},
			validate = true,
		},
	},
})

-- tailwind
vim.lsp.config("tailwindcss", {
	filetypes = {
		"html",
		"css",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"svelte",
		"vue",
		"astro",
	},
	init_options = {
		userLanguages = {
			astro = "html",
		},
	},
})

vim.lsp.config("astro", {
	filetypes = { "astro" },
	init_options = {
		typescript = {
			tsdk = vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules/typescript/lib",
		},
	},
})

-- pico8_ls (Pico-8 dialect of Lua, installed through mason)
vim.lsp.config("pico8_ls", {
	cmd = { "pico8-ls", "--stdio" },

	-- Covers .p8 carts plus .lua sources #include'd from a cart
	filetypes = { "pico8", "lua" },

	-- Only attach inside a Pico-8 project so plain Lua stays with lua_ls
	root_dir = function(bufnr, on_dir)
		local root = pico8_project_root(vim.api.nvim_buf_get_name(bufnr))
		if root then
			on_dir(root)
		end
	end,
})

vim.lsp.config("tinymist", {

	settings = {
		exportPdf = "never",
		formatterMode = "typstyle",
	},
})

-- Instead of using mason enable all configured LSP via `automatic_enable=true`
-- Prefer more control, enable manual server call below via vim.lsp.enable("")
vim.lsp.enable({
	"lua_ls",
	"cssls",
	"emmet_language_server",
	"emmet_ls",
	"ts_ls",
	"gopls",
	"astro",
	"tailwindcss",
	"marksman",
    "tinymist",
	"pico8_ls",
})
