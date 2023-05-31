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

require('lazy').setup("plugins")

-- [[ Set options ]]

-- Show cursor line
vim.o.cursorline = true

-- Enable line numbers
vim.o.number = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Show tabs and trailing spaces
vim.o.list = true

-- Do not wrap long lines by default
vim.o.wrap = false

-- Break lines at 120 characters
vim.o.textwidth = 120

-- Tab counts for 4 spaces
vim.o.tabstop = 4

-- Number of spaces to use for each step of indent
vim.o.shiftwidth = 4

-- Tab counts for 4 spaces while performing editing operations
vim.o.softtabstop = 4

-- In insert mode: use spaces to insert a tab
vim.o.expandtab = true

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

-- vim: ts=2 sts=2 sw=2 et
