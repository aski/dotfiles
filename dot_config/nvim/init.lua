--             _                              __ _
--  _ ____   _(_)_ __ ___     ___ ___  _ __  / _(_) __ _
-- | '_ \ \ / / | '_ ` _ \   / __/ _ \| '_ \| |_| |/ _` |
-- | | | \ V /| | | | | | | | (_| (_) | | | |  _| | (_| |
-- |_| |_|\_/ |_|_| |_| |_|  \___\___/|_| |_|_| |_|\__, |
--                                                 |___/

-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters
-- in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 500

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

if vim.fn.has 'win32' == 1 then
  vim.opt.shellslash = true
end

vim.opt.winborder = 'rounded'

vim.opt.confirm = true

vim.o.conceallevel = 2

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
}

-- [[ Basic Keymaps ]]

-- Clear highlighted search on <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

for key, dir in pairs { left = 'h', right = 'l', up = 'k', down = 'j' } do
  vim.keymap.set('n', '<' .. key .. '>', ('<cmd>echo "Use %s to move!!"<CR>'):format(dir))
end

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('aski/highlight-yank', { clear = true }),
  callback = function()
    -- TODO: on_yank is deprecated after 0.12, use vim.hl.hl_op()
    vim.hl.on_yank()
  end,
})

-- disable remote plugin providers to stop warnings in :checkhealth
for _, p in ipairs { 'node', 'perl', 'python3', 'ruby' } do
  vim.g['loaded_' .. p .. '_provider'] = 0
end

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  { -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
  },

  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    opts = {
      spec = {
        { '<leader>f', group = '[F]ind' },
        { '<leader>c', group = '[C]ode' },
      },
    },
  },

  { -- FUZZY FINDER
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-mini/mini.nvim' },
    opts = {},
    -- needed in order to register ui select
    event = 'VeryLazy',
    config = function(_, opts)
      local fzf = require 'fzf-lua'

      fzf.setup(opts)
      fzf.register_ui_select()

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('aski/lsp-attach', { clear = true }),
        callback = function(args)
          local function map(keys, func, desc, mode)
            vim.keymap.set(mode or 'n', keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
          end

          map('grd', fzf.lsp_definitions, '[G]oto [D]efinition')
          map('grr', fzf.lsp_references, '[G]oto [R]eferences')
          map('gri', fzf.lsp_implementations, '[G]oto [I]mplementation')
          map('grt', fzf.lsp_typedefs, '[G]oto [T]ype definition')
          map('gO', fzf.lsp_document_symbols, 'Document symbols')
          map('grw', fzf.lsp_live_workspace_symbols, 'Workspace symbols')
          map('gra', fzf.lsp_code_actions, '[G]oto Code [A]ction', { 'n', 'x' })
        end,
      })
    end,
    keys = {
      {
        '<leader>ff',
        function()
          require('fzf-lua').files()
        end,
        desc = '[F]ind [F]iles in project directory',
      },
      {
        '<leader>fg',
        function()
          require('fzf-lua').live_grep()
        end,
        desc = '[F]ind by [G]repping in project directory',
      },
      {
        '<leader>fk',
        function()
          require('fzf-lua').keymaps()
        end,
        desc = '[F]ind [K]eymaps',
      },
      {
        '<leader>fc',
        function()
          require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[F]ind in Neovim [C]onfig',
      },
      {
        '<leader>fd',
        function()
          require('fzf-lua').diagnostics_document()
        end,
        desc = '[F]ind [D]iagnostic',
      },
      {
        '<leader>fh',
        function()
          require('fzf-lua').helptags()
        end,
        desc = '[F]ind [H]elp',
      },
      {
        '<leader>fo',
        function()
          require('fzf-lua').oldfiles()
        end,
        desc = '[F]ind [O]ld Files',
      },
      {
        '<leader>fr',
        function()
          require('fzf-lua').resume()
        end,
        desc = '[F]ind [R]esume',
      },
      {
        '<leader>fw',
        function()
          require('fzf-lua').grep_cword()
        end,
        desc = '[F]ind current [W]ord',
      },
      {
        '<leader>/',
        function()
          require('fzf-lua').lgrep_curbuf()
        end,
        desc = '[/] Live grep in current buffer',
      },
      {
        '<leader><leader>',
        function()
          require('fzf-lua').buffers()
        end,
        desc = 'Find existing buffers',
      },
    },
  },

  { -- AUTOFORMAT
    'stevearc/conform.nvim',
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format { async = true }
        end,
        mode = { 'n', 'x' },
        desc = '[C]ode [F]ormat',
      },
    },
    opts = {
      notify_on_error = false,
      default_format_opts = {
        lsp_format = 'fallback',
      },
      formatters_by_ft = {
        json = { 'prettier' },
        lua = { 'stylua' },
        python = { 'autopep8' },
        sh = { 'shfmt' },
        xml = { 'xmlformatter' },
        yaml = { 'prettier' },
        markdown = { 'prettier' },
        ['_'] = { 'trim_whitespace', 'trim_newlines' },
      },
    },
    init = function()
      vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },

  { -- COLORSCHEME
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  { -- TODO HIGHLIGHTS
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    'nvim-mini/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      require('mini.icons').setup()
      require('mini.bracketed').setup()
      require('mini.input').setup()

      local statusline = require 'mini.statusline'
      statusline.setup {
        use_icons = vim.g.have_nerd_font,
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install {
        'bash',
        'c',
        'html',
        'javascript',
        'jinja',
        'jinja_inline',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'ruby',
        'vim',
        'vimdoc',
        'xml',
        'yaml',
      }

      vim.treesitter.language.register('jinja', 'jinja2')

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('aski/treesitter', { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) and vim.bo[args.buf].filetype ~= 'ruby' then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    'mason-org/mason.nvim',
    config = function()
      require('mason').setup()
      local mr = require 'mason-registry'
      local packages = {
        'ansible-lint',
        'autopep8',
        'hadolint',
        'prettier',
        'shellcheck',
        'shfmt',
        'stylua',
        'xmlformatter',
      }
      mr.refresh(function()
        for _, package_name in ipairs(packages) do
          local ok, pkg = pcall(mr.get_package, package_name)
          if ok then
            if not pkg:is_installed() then
              pkg:install()
              vim.schedule(function()
                vim.notify('[Mason] Package installed: ' .. package_name, vim.log.levels.INFO)
              end)
            end
          else
            vim.schedule(function()
              vim.notify('[Mason] Package not found: ' .. package_name, vim.log.levels.WARN)
            end)
          end
        end
      end)
    end,
  },

  { -- LINTING
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    enabled = false,
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        -- sh = { 'shellcheck' },
      }

      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('aski/lint', { clear = true }),
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },

  { -- COMPLETION
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = 'rafamadriz/friendly-snippets',
    event = 'VimEnter',
    opts = {
      keymap = {
        preset = 'default',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          lua = { inherit_defaults = true, 'lazydev' },
          org = { inherit_defaults = true, 'org' },
        },
        providers = {
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
          org = { name = 'Org', module = 'org.completion.blink' },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },

  {
    'DrKJeff16/project.nvim',
    main = 'project',
    event = 'VeryLazy',
    dependencies = { 'ibhagwan/fzf-lua' },
    opts = {
      fzf_lua = {
        enabled = true,
      },
    },
    keys = {
      {
        '<leader>fp',
        '<cmd>Project fzf-lua<cr>',
        desc = 'Find Project (fzf-lua)',
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'saghen/blink.cmp',
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('mason').setup()

      local servers = { 'ansiblels', 'bashls', 'dockerls', 'lua_ls', 'marksman', 'yamlls' }

      require('mason-lspconfig').setup { ensure_installed = servers, automatic_enable = false }

      vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })
      vim.lsp.enable(servers)
    end,
  },

  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      picker = {
        name = 'fzf-lua',
      },
      workspaces = {
        {
          name = 'personal',
          path = '~/Documents/Obsidian Vault',
        },
      },
    },
    keys = {
      {
        '<leader>ot',
        function()
          vim.cmd 'Obsidian today'
        end,
        desc = "Obsidian: today's note",
      },
    },
  },

  {
    'NeogitOrg/neogit',
    lazy = true,
    dependencies = {
      'sindrets/diffview.nvim',
      'ibhagwan/fzf-lua',
    },
    cmd = 'Neogit',
    keys = {
      { '<leader>gg', '<cmd>Neogit<cr>', desc = 'Show Neogit UI' },
    },
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {},
  },
}, { rocks = { enabled = false } })

-- vim: ts=2 sts=2 sw=2 et
