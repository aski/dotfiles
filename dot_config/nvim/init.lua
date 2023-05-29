vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- [[ Install plugin manager and plugins ]]

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  { 'shaunsingh/nord.nvim', priority = 1000, },
  { 'dense-analysis/ale', },
  { 'lewis6991/gitsigns.nvim', },
  { 'nvim-lualine/lualine.nvim', },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
  },
})

-- [[ Set options ]]

-- Configure and set colorscheme
vim.g.nord_italic = false
vim.g.nord_bold = false
require('nord').set()

-- Show cursor line
vim.wo.cursorline = true

-- Enable line numbers
vim.wo.number = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Show tabs and trailing spaces
vim.wo.list = true

-- Do not wrap long lines by default
vim.wo.wrap = false

-- Break lines at 120 characters
vim.bo.textwidth = 120

-- Tab counts for 4 spaces
vim.bo.tabstop = 4

-- Number of spaces to use for each step of indent
vim.bo.shiftwidth = 4

-- Tab counts for 4 spaces while performing editing operations
vim.bo.softtabstop = 4

-- In insert mode: use spaces to insert a tab
vim.bo.expandtab = true

--
vim.o.wildmode = 'list:longest,list:full'

-- Ignore case when completing file and directory names
vim.o.wildignorecase = true

-- Save undo history
vim.o.undofile = true

-- Make searches case insensitive by default
vim.o.ignorecase = true

-- Make searches case sensitive when patterns contain upper case characters
vim.o.smartcase = true

-- Write swap file to disk if nothing is typed for 250 ms
vim.o.updatetime = 250

-- Better completion
vim.o.completeopt = 'menuone,noselect'

-- Enable 24-bit RGB color in terminal
vim.o.termguicolors = true

-- Briefly highlight opening bracket when inserting a closing bracket
vim.o.showmatch = true

-- Use system clipboard
vim.o.clipboard = 'unnamedplus,unnamed'

-- Minimal number of screen lines to keep above and below the cursor
vim.o.scrolloff = 5

-- Do not show mode in command line
vim.o.showmode = false

-- When splitting a window, put the new one on the right
vim.o.splitright = true

-- [[ Configure Lualine ]]

require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'nord',
    component_separators = '|',
    section_separators = '',
  },
}

-- [[ Configure Treesitter ]]

require('nvim-treesitter.configs').setup {
  ensure_installed = 'all',
  auto_install = false,
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

-- [[ Configure Telescope ]]

require('telescope').setup {}
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').git_files, { desc = '[F]ind [G]it Files' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })

-- vim: ts=2 sts=2 sw=2 et
