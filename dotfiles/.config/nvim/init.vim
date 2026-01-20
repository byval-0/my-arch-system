call plug#begin('~/.config/nvim/plugged')
" Theme
Plug 'folke/tokyonight.nvim'
Plug 'xiyaowong/transparent.nvim' "Transparent background colour

" Git
Plug 'f-person/git-blame.nvim' " Time to blame someone
Plug 'esmuellert/vscode-diff.nvim' "Run :CodeDiff install
Plug 'sindrets/diffview.nvim' " For seeing different between commit
Plug 'tpope/vim-fugitive' "For git control (require by vimflog)
Plug 'NeogitOrg/neogit'
Plug 'lewis6991/gitsigns.nvim' " Show changes in git

" LSP
Plug 'sheerun/vim-polyglot'
Plug 'neovim/nvim-lspconfig'      " LSP client
Plug 'nvimdev/lspsaga.nvim'       " lspsaga for UI
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax Highlight >>> npm install -g tree-sitter-cli

" Debugger
Plug 'mfussenegger/nvim-dap' " Install pacman -S delve
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'

" Enhance Nvim
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
Plug 'wurli/visimatch.nvim' " Highlight visual match
Plug 'winston0410/range-highlight.nvim' " Highlight selection
Plug 'nvim-lua/plenary.nvim' "Lua function improvement (require for some plugin)
Plug 'nvim-telescope/telescope.nvim' "telescope for fast switching or searching file
Plug 'nvim-tree/nvim-web-devicons' "icon plugin
Plug 'MunifTanjim/nui.nvim' "UI enhancement
Plug 'nvim-lualine/lualine.nvim' "Line enhancement
Plug 'romainl/vim-cool' " Remove highlight after search done (why would it require a plugin to do something this?)
Plug 'sphamba/smear-cursor.nvim' " Cursor animation
Plug 'ya2s/nvim-cursorline' " Cursor line highlight
Plug 'kevinhwang91/nvim-ufo' " Fold/Unfold scope
Plug 'kevinhwang91/promise-async' " dependency for nvim-ufo
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' } " Prettier auto format
Plug 'folke/snacks.nvim'
Plug 'lewis6991/satellite.nvim' " Satellite to displays decorated scrollbars (easier to find error)

" Ease of use
Plug 'nvim-neo-tree/neo-tree.nvim' "File Explorer as tree
Plug 'phaazon/hop.nvim' " For hopping around the code
Plug 'numToStr/Comment.nvim' "Comment line
Plug 'famiu/bufdelete.nvim' "Easily Buffer controller
Plug 'akinsho/bufferline.nvim', { 'tag': '*' } "Bufferline
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'} "Toggle terminal
Plug 'gelguy/wilder.nvim' " Cmd hint
Plug 'roxma/nvim-yarp' " yarp for cmd hint
Plug 'roxma/vim-hug-neovim-rpc' " for cmd hint
Plug 'romgrk/fzy-lua-native' " for fuzzy search work with wilder

call plug#end()

"Setup vim
set number
set hlsearch
set nocompatible
set autoindent
set encoding=UTF-8
set ambiwidth=single
set termguicolors
syntax on
colorscheme tokyonight-night
set signcolumn=yes:1 " Fix glitch when moving cursor through file (icon rendering at line number make it glitch)

" auto set title with current directory
set title
set titlestring=💻%{fnamemodify(getcwd(),':t')}

" Global config

" Minimap
let g:minimap_git_colors = 1
let g:minimap_highlight_search = 1

" Lua config
lua << EOF
-- initial
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"

-- Plugin Setup
local hop = require('hop')
hop.setup()
require("range-highlight").setup()
require("Comment").setup()
require("transparent").setup()
require('smear_cursor').enabled = true

-- cursor line highlight
require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 500,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

require('lualine').setup({
  options = {
    disabled_filetypes = {
      statusline = { 'neo-tree' },
      tabline = { 'neo-tree' },
    }
  },
 sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'lsp_status', 'location'},
    lualine_z = {"os.date('%X %a')"},
 }
})

-- uifloatup for lsp (Might not use)
local lspsaga = require("lspsaga")
lspsaga.setup({
  ui = {
    border = "rounded"
  }
})

-- Neo Tree setup
require("neo-tree").setup({
  close_if_last_window = true,
  enable_git_status = true,
  enable_diagnostics = true,
  filesystem = {
    filtered_items = {
      visible = true
    },
    follow_current_file = {
      enabled = true
    },
    use_libuv_file_watcher = true
  },
  window = {
    width = 25
  },
  default_component_configs = {
    diagnostics = {
      symbols = {
        hint = "󰌶",
        info = "󰋽",
        warn = "󰀪",
        error = "󰅚",
      },
    },
  },
})
local events = require("neo-tree.events")
events.fire_event(events.GIT_EVENT)

-- UFO Fold/unfold setup
require('ufo').setup()
vim.o.foldcolumn = '0' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('gitsigns').setup({})

-- Cmd Hint
local wilder = require('wilder')
wilder.setup({modes = {':', '?'}})

wilder.set_option("pipeline", {
  wilder.branch(
    wilder.cmdline_pipeline({
      fuzzy = 1,
      fuzzy_filter = wilder.lua_fzy_filter(), -- IMPORTANT
    }),
    wilder.search_pipeline()
  ),
})

require("wilder").set_option(
  "renderer",
  require("wilder").popupmenu_renderer(
    wilder.popupmenu_border_theme({
      highlighter = wilder.lua_fzy_highlighter(),
      highlights = {
        border = 'Normal',
      },
      pumblend = 20,
      border = 'rounded',
      left = {' ', wilder.popupmenu_devicons()},
      right = {' ', wilder.popupmenu_scrollbar()},
    })
  )
)


-- Toggleterm
require("toggleterm").setup{
  open_mapping = [[<c-j>]]
}

-- Mini repository
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.indentscope").setup()
require("mini.trailspace").setup()
--require("mini.animate").setup({
--  cursor = { enable = true },
--  scroll = { enable = false },
--  resize = { enable = true },
--  open = { enable = true },
--  close = { enable = true },
--})


-- Comment
require("Comment").setup({
  mappings = {
    basic = false,
    extra = false,
  },
})
-- Line comment (normal + visual)
vim.keymap.set("n", "<leader>/", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle line comment" })

vim.keymap.set("v", "<leader>/", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { desc = "Toggle line comment" })

-- Bufferline
require("bufferline").setup{
  options = {
    mode="buffers",
    separator_style = "slant", -- Customize tab separator style
    offsets = {
      {
        filetype = "neo-tree",
        text="File Explorer",
        separator= true,
        text_align = "left",
      }
    },
    hover = {
        enabled = true,
        delay = 200,
        reveal = {'close'}
    },
    diagnostics = "cmp",
    modified_icon = '●',
    show_close_icon = true,
    show_buffer_close_icons = false,
    always_show_bufferline = true,
  }
}

-- CodeDiff
require("vscode-diff").setup({
  -- Highlight configuration
  highlights = {
    -- Line-level: accepts highlight group names or hex colors (e.g., "#2ea043")
    line_insert = "DiffAdd",      -- Line-level insertions
    line_delete = "DiffDelete",   -- Line-level deletions

    -- Character-level: accepts highlight group names or hex colors
    -- If specified, these override char_brightness calculation
    char_insert = nil,            -- Character-level insertions (nil = auto-derive)
    char_delete = nil,            -- Character-level deletions (nil = auto-derive)

    -- Brightness multiplier (only used when char_insert/char_delete are nil)
    -- nil = auto-detect based on background (1.4 for dark, 0.92 for light)
    char_brightness = nil,        -- Auto-adjust based on your colorscheme
  },

  -- Diff view behavior
  diff = {
    disable_inlay_hints = true,         -- Disable inlay hints in diff windows for cleaner view
    max_computation_time_ms = 5000,     -- Maximum time for diff computation (VSCode default)
  },

  -- Keymaps in diff view
  keymaps = {
    view = {
      quit = "q",                    -- Close diff tab
      toggle_explorer = "<leader>b",  -- Toggle explorer visibility (explorer mode only)
      next_hunk = "]c",   -- Jump to next change
      prev_hunk = "[c",   -- Jump to previous change
      next_file = "]f",   -- Next file in explorer mode
      prev_file = "[f",   -- Previous file in explorer mode
    },
    explorer = {
      select = "<CR>",    -- Open diff for selected file
      hover = "K",        -- Show file diff preview
      refresh = "R",      -- Refresh git status
    },
  },
})

-- Snack Setup
require("snacks").setup({
  notifier = {
    enabled = true,
    timeout = 3000, -- default timeout in ms
    width = { min = 40, max = 0.4 },
    height = { min = 1, max = 0.6 },
    margin = { top = 0, right = 1, bottom = 0 },
    padding = true,
    sort = { "level", "added" },
    level = vim.log.levels.INFO,
    style = "compact", -- "minimal", "compact", or "fancy"
  },
})

vim.api.nvim_create_autocmd("LspProgress", {
  ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
  callback = function(ev)
    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(vim.lsp.status(), "info", {
      id = "lsp_progress",
      title = "LSP Progress",
      opts = function(notif)
        notif.icon = ev.data.params.value.kind == "end" and " "
          or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})


-- Optional: Set as the default notify function
vim.notify = require("snacks").notifier.notify

-- LSP Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "ts_ls",
    "lua_ls",
    "rust_analyzer",
  },
})

local lspconfig = require("lspconfig")
local servers = {
  gopls = {},
  ts_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
      },
    },
  },
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
}

local capabilities = require("cmp_nvim_lsp")
  .default_capabilities(vim.lsp.protocol.make_client_capabilities())

for name, cfg in pairs(servers) do
  cfg.capabilities = capabilities
  vim.lsp.config(name, cfg)
end

-- dap debugger setup
local dap, dapui = require("dap"), require("dapui")
dapui.setup()
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN]  = "󰀪",
      [vim.diagnostic.severity.INFO]  = "󰋽",
      [vim.diagnostic.severity.HINT]  = "󰌶",
    },
  },
})
vim.fn.sign_define("DapBreakpoint", {
  text = "●",
  texthl = "DapBreakpoint",
  linehl = "",
  numhl = ""
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = "◉",
  texthl = "DapBreakpointCondition",
})
vim.api.nvim_set_hl(0, "DapBreakpoint", {
  fg = "#e06c75",
})
vim.fn.sign_define("DapStopped", {
  text = "▶",
  texthl = "DapStopped",
  linehl = "DapStoppedLine",
  numhl = ""
})
vim.api.nvim_set_hl(0, "DapStopped", {
  fg = "#50fa7b", -- green arrow
})
vim.api.nvim_set_hl(0, "DapStoppedLine", {
  bg = "#2a2f3a", -- subtle background
})

require('dap-go').setup()

-- Syntax Tree-sitter
require('nvim-treesitter').install({ 'rust', 'javascript', 'typescript','go'  })
-- might not need setup?
require('nvim-treesitter').setup({
  highlight = {
    enable = true,
  },
})
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("EnableTreesitterHighlighting", { clear = true }),
  desc = "Try to enable tree-sitter syntax highlighting",
  pattern = "*", -- run on *all* filetypes
  callback = function()
    pcall(function() vim.treesitter.start() end)
  end,
})
-- For auto import on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports", "source.fixAll" } },
      apply = true
    })
  end,
})

-- Create an Autocmd group for managing format-on-save events
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    -- Only run if the buffer is attached to an LSP that supports formatting
    if vim.diagnostic.get(0) then
      vim.lsp.buf.format({ async = false }) -- 'async = false' ensures formatting completes before saving
    end
  end,
  desc = "Auto format on save",
})

-- Git
require("neogit").setup({
  filewatcher = {
    enabled = true,
    interval = 100,
  },
  auto_refresh = true,
  graph_style = "kitty",
  mappings = {
    status = {
      ["<c-j>"] = false,
    }
 }
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "Neogit*",
  callback = function()
    local ok, neogit = pcall(require, "neogit")
    if ok then
      neogit.refresh()
    end
  end,
})

-- Satellite
require('satellite').setup({
  zindex = 40,            -- above most UI but below popups
  handlers = {
    cursor = {
      enable = false,     -- noisy, not useful
    },
    search = {
      enable = true,
    },
    diagnostic = {
      enable = true,
      signs = { "󰅚", "󰀪", "󰋽", "󰌶" },
      min_severity = vim.diagnostic.severity.HINT,
    },
    gitsigns = {
      enable = true,
      signs = { "+", "~", "-" },
    },
    marks = {
      enable = false,     -- usually clutter
    },
    fold = {
      enable = false,     -- redundant with foldcolumn
    },
  },
})

-- Auto diagnostic
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local diag = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
    if #diag > 0 then
      -- vim.cmd("Lspsaga show_line_diagnostics")
      vim.diagnostic.open_float(nil, {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "if_many",
        prefix = "",
        scope = "cursor",
      })
    end
  end,
})
-- set tim delay
vim.o.updatetime = 500
-- auto show error
vim.diagnostic.config({
  virtual_text = { severity = vim.diagnostic.severity.ERROR },
})

-- nvim-cmp setup
local cmp = require("cmp")
local luasnip = require("luasnip")
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

-- telescope finder
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-f>', builtin.live_grep, { desc = 'Telescope live grep' })

-- Key Setup
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
vim.keymap.set("n", "<C-p>",
function()
  builtin.find_files({
    hidden = false,
  })
end
-- builtin.find_files
, {
 desc = "Find files"
})
vim.keymap.set('', 'f', function()
	hop.hint_words()
end, {remap=true})
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>]", ":gcc<CR>")
-- Navigate to the next buffer
vim.keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { silent = true })
-- Navigate to the previous buffer
vim.keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { silent = true })
-- Close Buffer using bufdelete
vim.keymap.set('n', '<leader>w', '<Cmd>Bdelete<CR>', { silent = true })
-- New  [No Name] buffer
vim.keymap.set('n', '<leader>n', ':enew<CR>', { silent = true })
-- Save
vim.keymap.set('n', '<leader>s', ':w<CR>', { silent = true })
vim.keymap.set('n', '<leader>x', ':x<CR>', { silent = true })

-- Quit all
vim.keymap.set('n', '<leader>Q', ':qall<CR>')

-- Next Tab
vim.keymap.set('n', '<leader><Tab>', '<Cmd>tabnext<CR>', { silent = true })
-- Previous Tab
vim.keymap.set('n', '<leader><S-Tab>', '<Cmd>tabprevious<CR>', { silent = true })
-- New Tab
vim.keymap.set('n', '<leader>tn', '<Cmd>tabnew<CR>', { silent = true })
-- Close Tab
vim.keymap.set('n', '<leader>tq', '<Cmd>tabclose<CR>', { silent = true })

-- UFO controller
vim.keymap.set('n', '<leader>l','<Cmd>foldopen<CR>', { silent = true })
vim.keymap.set('n', '<leader>h', '<Cmd>foldclose<CR>', { silent = true })

-- LSP Control
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Show references" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Show code action"})
vim.keymap.set('n', '<leader>?', '<Cmd>Lspsaga hover_doc<CR>', { silent = true })
vim.keymap.set('n', '<F2>', '<Cmd>Lspsaga rename<CR>', { silent = true })

-- Neogit
vim.keymap.set('n', '<leader>G', '<Cmd>Neogit<CR>', { silent = true })
vim.keymap.set('n', '<leader>gl', function()
require('neogit').action("log", "log_all_branches", {"--graph", "--color", "--decorate", "--date-order"})()
end, { silent = true })

vim.keymap.set("n", "<leader>dv", function()
  -- This assumes you are in a Neogit buffer (Log or Status)
  local item = require("neogit.lib.git.status").get_at_cursor()
  if item and item.oid then
    vim.cmd("CodeDiff " .. item.oid)
  else
    print("No commit found under cursor")
  end
end, { desc = "Explore commit with vscode-diff" })

-- Dap Debugger
vim.keymap.set("n", "<leader><leader>", function()
  require("dap").toggle_breakpoint()
  vim.notify("Breakpoint toggled", vim.log.levels.INFO)
end)
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)


EOF

