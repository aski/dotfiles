local use = require('packer').use
local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({
        'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path
    })
    execute 'packadd packer.nvim'
end

return require('packer').startup(function()
use 'wbthomason/packer.nvim'
use 'tpope/vim-sensible'
use 'tpope/vim-commentary'
use 'tpope/vim-endwise'
use 'tpope/vim-fugitive'
use 'tpope/vim-git'
use 'tpope/vim-surround'
use 'tpope/vim-unimpaired'

use 'dense-analysis/ale'

use 'vimwiki/vimwiki'

use 'andersevenrud/nordic.nvim'

use 'itchyny/lightline.vim'
use 'luochen1990/rainbow'
use 'junegunn/fzf.vim'
use 'junegunn/vim-easy-align'
use 'pearofducks/ansible-vim'
use 'vim-ruby/vim-ruby'
use 'vim-scripts/groovyindent-unix'
use 'pedrohdz/vim-yaml-folds'
use 'rust-lang/rust.vim'

use 'nvim-treesitter/nvim-treesitter'
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'
use 'neovim/nvim-lspconfig'
use 'kyazdani42/nvim-tree.lua'

use 'towolf/vim-helm'
use 'christoomey/vim-tmux-navigator'
end)

