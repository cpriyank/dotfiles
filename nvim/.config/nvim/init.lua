-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Options ]]
vim.opt.number = true -- show absolute line number on cursor line
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.showmode = false -- Don't show mode (status line shows it)
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true -- ...unless \C or capital letters
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.opt.splitright = true -- Open vertical splits to the right
vim.opt.splitbelow = true -- Open horizontal splits below
vim.opt.list = true -- Show whitespace characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- Preview substitutions live
vim.opt.cursorline = true -- Show which line cursor is on
vim.opt.scrolloff = 10 -- Min lines above/below cursor

-- Sync clipboard (scheduled to not slow startup)
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- [[ Basic Keymaps ]]
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", ";", ":")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("n", "<leader>fs", "<cmd>w<CR>", { desc = "Current [F]ile [S]ave" })
vim.keymap.set("n", "<leader>fq", "<cmd>wq<CR>", { desc = "Current [F]ile [Q]uit" })

-- Split navigation with CTRL+<hjkl>
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Enable treesitter highlight for bundled parsers (no plugin required)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "markdown", "vim", "vimdoc", "query" },
	group = vim.api.nvim_create_augroup("user-treesitter", { clear = true }),
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Enable spell-check for prose filetypes (avoid noise on code identifiers)
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "text", "gitcommit" },
	group = vim.api.nvim_create_augroup("user-spell", { clear = true }),
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

-- Retain cursor position when opening files (modern API)
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Retain cursor position when opening files",
	group = vim.api.nvim_create_augroup("kickstart-retain-cursor", { clear = true }),
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
		end
	end,
})

-- [[ LSP (Neovim 0.11+ built-in vim.lsp.config / vim.lsp.enable) ]]
-- Install servers via :MasonInstall <name>. No nvim-lspconfig/mason-lspconfig required.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user-lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		local builtin = require("telescope.builtin")
		map("gd", builtin.lsp_definitions, "[G]oto [D]efinition")
		map("gr", builtin.lsp_references, "[G]oto [R]eferences")
		map("gI", builtin.lsp_implementations, "[G]oto [I]mplementation")
		map("<leader>D", builtin.lsp_type_definitions, "Type [D]efinition")
		map("<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
		map("<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
			local hl_group = vim.api.nvim_create_augroup("user-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("user-lsp-detach", { clear = true }),
				callback = function(ev)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "user-lsp-highlight", buffer = ev.buf })
				end,
			})
		end

		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			map("<leader>th", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
			end, "[T]oggle Inlay [H]ints")
		end
	end,
})

-- Default capabilities: advertise snippet support so LSP returns rich completions
local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("*", { capabilities = lsp_capabilities })

vim.lsp.config("lua_ls", {
	settings = {
		Lua = { completion = { callSnippet = "Replace" } },
	},
})
vim.lsp.enable("lua_ls")

vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = {
		"pyrightconfig.json",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		".git",
	},
	settings = {
		python = {
			analysis = {
				autoImportCompletions = true,
			},
		},
	},
})
vim.lsp.enable("pyright")

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require("lazy").setup({
	-- Copilot (<Tab> is integrated through blink.cmp below)
	{
		"github/copilot.vim",
		lazy = false,
		init = function()
			vim.g.copilot_no_tab_map = true
		end,
		config = function()
			vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				silent = true,
			})
		end,
	},

	-- Git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},

	-- Which-key for pending keybinds (deferred loading)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>f", group = "[F]ormat" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	-- Telescope fuzzy finder (lazy loaded on keys/commands)
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>sh", "<cmd>Telescope help_tags<CR>", desc = "[S]earch [H]elp" },
			{ "<leader>sk", "<cmd>Telescope keymaps<CR>", desc = "[S]earch [K]eymaps" },
			{ "<leader>sf", "<cmd>Telescope find_files<CR>", desc = "[S]earch [F]iles" },
			{ "<leader>ss", "<cmd>Telescope builtin<CR>", desc = "[S]earch [S]elect Telescope" },
			{ "<leader>sw", "<cmd>Telescope grep_string<CR>", desc = "[S]earch current [W]ord" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "[S]earch [B]uffer" },
			{ "<leader>sg", "<cmd>Telescope live_grep<CR>", desc = "[S]earch by [G]rep" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<CR>", desc = "[S]earch [D]iagnostics" },
			{ "<leader>sr", "<cmd>Telescope resume<CR>", desc = "[S]earch [R]esume" },
			{ "<leader>s.", "<cmd>Telescope oldfiles<CR>", desc = '[S]earch Recent Files ("." for repeat)' },
			{ "<leader><leader>", "<cmd>Telescope buffers<CR>", desc = "[ ] Find existing buffers" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- Additional keymaps that need functions
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},

	-- Mason (LSP/tool installer UI only; install with :MasonInstall)
	{ "williamboman/mason.nvim", cmd = "Mason", opts = {} },

	-- Lua dev for editing this config (vim.uv types, runtime path)
	{
		"folke/lazydev.nvim",
		ft = "lua",
	},

	-- Autoformat
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>ff",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
			},
		},
	},

	-- Completion: blink.cmp (Rust-native fuzzy, single-plugin replacement for nvim-cmp stack).
	-- <Tab> accepts Copilot when visible, then falls back to blink completion/snippets.
	{
		"saghen/blink.cmp",
		version = "1.*",
		config = function(_, opts)
			require("blink.cmp").setup(opts)
			-- Re-register LSP capabilities with blink's richer set (snippet, resolve, etc.)
			vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
		end,
		opts = {
			keymap = {
				preset = "super-tab",
				["<Tab>"] = {
					function(cmp)
						local ok, suggestion = pcall(vim.fn["copilot#GetDisplayedSuggestion"])
						if ok and suggestion and suggestion.text ~= "" then
							return vim.fn["copilot#Accept"]("")
						end

						if cmp.snippet_active() then
							return cmp.accept()
						end
						return cmp.select_and_accept()
					end,
					"snippet_forward",
					"fallback",
				},
			},
			appearance = { nerd_font_variant = "mono" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
				list = { selection = { preselect = false, auto_insert = false } },
			},
			snippets = { preset = "default" }, -- uses vim.snippet
			sources = {
				default = { "lsp", "path", "buffer", "lazydev" },
				providers = {
					lsp = {
						score_offset = 10,
					},
					path = {
						score_offset = -5,
					},
					buffer = {
						score_offset = -8,
					},
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
	},

	-- Colorscheme
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
			vim.cmd.hi("Comment gui=none")
		end,
	},

	-- Todo comments (deferred)
	{
		"folke/todo-comments.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- Distraction-free writing (Goyo) + paragraph dimming (Limelight)
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		dependencies = {
			{
				"folke/twilight.nvim",
				cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
				opts = { context = 10, treesitter = true },
			},
		},
		keys = {
			{ "<leader>tz", "<cmd>ZenMode<CR>", desc = "[T]oggle [Z]en mode" },
			{ "<leader>tl", "<cmd>Twilight<CR>", desc = "[T]oggle [L]imelight (dim paragraphs)" },
		},
		opts = {
			window = { width = 80 },
			plugins = {
				options = { enabled = true, ruler = false, showcmd = false },
				twilight = { enabled = true },
				gitsigns = { enabled = false },
			},
		},
	},

	-- Mini.nvim collection (pairs, icons, ai, surround, statusline)
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			require("mini.pairs").setup()
			require("mini.icons").setup()
			MiniIcons.mock_nvim_web_devicons()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.statusline").setup({ use_icons = vim.g.have_nerd_font })
		end,
	},
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- vim: ts=2 sts=2 sw=2 et
