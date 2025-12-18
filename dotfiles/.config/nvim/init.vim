call plug#begin('~/.config/nvim/plugged')
" Theme
Plug 'folke/tokyonight.nvim'
Plug 'xiyaowong/transparent.nvim' "Transparent background colour

" Git
Plug 'f-person/git-blame.nvim'
Plug 'esmuellert/vscode-diff.nvim' "Run :CodeDiff install
Plug 'tpope/vim-fugitive' "For git control (require by vimflog)
Plug 'rbong/vim-flog' " For git tree

" LSP
Plug 'sheerun/vim-polyglot'
Plug 'neovim/nvim-lspconfig'      " LSP client
Plug 'nvimdev/lspsaga.nvim'       " lspsaga for UI
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'


" Enhance Nvim
Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
Plug 'wurli/visimatch.nvim' " Highlight visual match
Plug 'winston0410/range-highlight.nvim' " Highlight selection
Plug 'nvim-lua/plenary.nvim' "Lua function improvement (require for some plugin)
Plug 'nvim-telescope/telescope.nvim' "telescope for fast switching or searching file
Plug 'nvim-tree/nvim-web-devicons' "icon plugin
Plug 'MunifTanjim/nui.nvim' "UI enhancement
Plug 'nvim-lualine/lualine.nvim' "Line enhancement

" Ease of use
Plug 'nvim-neo-tree/neo-tree.nvim' "File Explorer as tree
Plug 'phaazon/hop.nvim' " For hopping around the code
Plug 'lewis6991/gitsigns.nvim'
Plug 'numToStr/Comment.nvim' "Comment line
Plug 'famiu/bufdelete.nvim' "Easily Buffer controller
Plug 'akinsho/bufferline.nvim', { 'tag': '*' } "Bufferline
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'} "Toggle terminal
Plug 'gelguy/wilder.nvim' " Cmd hint
Plug 'roxma/nvim-yarp' " yarp for cmd hint
Plug 'roxma/vim-hug-neovim-rpc' " for cmd hint


" Auto Complete
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

"Setup vim
set number
set hlsearch
set nocompatible
set autoindent
set encoding=UTF-8
set termguicolors
syntax on
colorscheme tokyonight

" Global config



" Lua config
lua << EOF
-- initial p
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
require("gitsigns").setup()
require("Comment").setup()
require("transparent").setup()
require('lualine').setup()

-- uifloatup for lsp (Might not use)
require("lspsaga").setup({
  ui = {
    border = "rounded"
  }
})


-- Cmd Hint
local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})
require("wilder").set_option(
  "renderer",
  require("wilder").popupmenu_renderer(
    wilder.popupmenu_border_theme({
      hilights = {
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
require("mini.animate").setup({
  cursor = { enable = true },
  scroll = { enable = false },
  resize = { enable = true },
  open = { enable = true },
  close = { enable = true },
})


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
    diagnostics = "coq",
    modified_icon = '●',
    show_close_icon = false,
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


-- LSP Setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "typescript-language-server",
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
-- vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
-- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Key Setup
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
vim.keymap.set("n", "<C-p>",
function()
  builtin.find_files({
    hidden = true,
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
vim.keymap.set('n', '<leader>x', '<Cmd>Bdelete<CR>', { silent = true })
-- Save
vim.keymap.set('n', '<leader>s', ':w<CR>', { silent = true })

EOF

" Keymap for hover (uses lspsaga hover_doc)
nnoremap K <cmd>Lspsaga hover_doc<CR>



