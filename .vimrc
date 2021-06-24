" if vim-plug is not installed, get it from github
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'arcticicestudio/nord-vim'

Plug 'itchyny/lightline.vim'

Plug 'godlygeek/tabular'
Plug 'w0rp/ale'
Plug 'vimwiki/vimwiki'

Plug 'pearofducks/ansible-vim'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/groovyindent-unix'
Plug 'aklt/plantuml-syntax'
Plug 'weirongxu/plantuml-previewer.vim'
Plug 'tyru/open-browser.vim'
Plug 'luochen1990/rainbow'
Plug 'pedrohdz/vim-yaml-folds'
call plug#end()

filetype plugin indent on
syntax enable

runtime macros/matchit.vim

set termguicolors
set background=dark
silent! colorscheme nord

set encoding=utf-8                                                                      " unicode is mean
set cursorline                                                                          " highlight current line
set shortmess=a                                                                         " abbreviate some of the stuff shown in cmd line
set shortmess+=t                                                                        " abbreviate file name in cmd line if too long
set shortmess+=I                                                                        " hide startup message
set number                                                                              " show line numbers
set numberwidth=3                                                                       " minimum width of line number column
set hidden                                                                              " allow unsaved buffers
set textwidth=120                                                                       " set the textwidth to be 120 chars
set diffopt+=iwhite                                                                     " ignore whitespace in diffs
set diffopt+=vertical                                                                   " split diffs vertically
set backspace=indent,eol,start                                                          " sane backspace behaviour
set splitright                                                                          " show splits to the right
set formatoptions+=c,q,r,t,l                                                            " configure auto-formatting
set complete-=i
set showmatch                                                                           " when a bracket is inserted, briefly jump to the matching one.
set smartindent                                                                         " do smart autoindenting when starting a new line
set autoindent                                                                          " auto-indent new lines
set copyindent
set tabstop=4                                                                           " the amount of spaces a tab counts for
set shiftwidth=4                                                                        " number of spaces to use for each step of indent
set shiftround
set expandtab                                                                           " insert spaces instead of tabs
set smarttab                                                                            " very smart behaviour with tabs and spaces?
set ignorecase                                                                          " ignore case while searching
set visualbell                                                                          " don't beep
set incsearch                                                                           " show matches incrementally while typing
set hlsearch                                                                            " highlight all matches of a search
set wildmenu                                                                            " fancy menu for completions
set wildmode=list:longest,list:full
set wildignorecase
set wildignore=*.swp,*.class,*.pyc
set foldlevelstart=99                                                                   " open most folds by default
set clipboard^=unnamedplus,unnamed                                                      " use clipboard as default register
set guioptions-=m                                                                       " remove menu bar
set guioptions-=T                                                                       " remove toolbar
set guioptions-=r                                                                       " remove right-hand scroll bar
set guioptions-=L                                                                       " remove left-hand scroll bar
set list                                                                                " show whitespace characters
set listchars=tab:>\ ,trail:.,extends:>,precedes:<,nbsp:+
set scrolloff=5
set sidescrolloff=5
set autoread                                                                            " reload (unchanged) files when file system change is detected
set display+=lastline
set laststatus=2                                                                        " always show a status line
set ruler                                                                               " show row/col pos and % file position in status bar
set formatoptions+=j                                                                    " Delete comment char when joining commented lines
set history=1000                                                                        " Max length of search and command history
set tabpagemax=50                                                                       " Max number of open tab pages
set nrformats-=octal
set ttimeout
set ttimeoutlen=100
set nowrap
set nobackup
set noswapfile
" set mouse=a
set lazyredraw
set synmaxcol=3000
set noshowmode
set dictionary+=/usr/share/dict/words
set spelllang=en_us
set nospell

"""
"""
"""

let g:sql_type_default='sqloracle'                                                      " set default sql dialect to oracle

let g:netrw_altv=1
let g:netrw_banner=0                                                                    " hide stupid netrw banner
let g:netrw_browse_split=2
let g:netrw_keepdir=0
let g:netrw_liststyle=3                                                                 " set netrw default list style to tree style
let g:netrw_preview=1
let g:netrw_winsize=25

let g:ale_linter_aliases = { 'maven': 'xml' }

let g:lightline = {}
let g:lightline.colorscheme = 'nord'

let g:vimwiki_list = [{'path': '~/vimwiki/',
            \ 'syntax': 'markdown', 'ext': '.md'}]

let g:plantuml_executable_script='~/bin/plantuml.sh'

let g:rainbow_active = 1

"""
""" KEYBINDINGS
"""

let mapleader = ','                                                                     " set leader key to comma

nnoremap <leader><space> :nohlsearch<CR>                                                " set key to turn off search highlighting
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>w :Windows<CR>

nmap     <silent><leader>ev :e ~/.vimrc<CR>                                             " set key to quickly open vimrc in new buffer
nmap     <silent><leader>sv :source ~/.vimrc<CR>                                        " set key to source vimrc

noremap  <leader>W :w !sudo tee % > /dev/null<CR>                                       " set key to save file as root

nnoremap <up>    <nop>
nnoremap <down>  <nop>
nnoremap <left>  <nop>
nnoremap <right> <nop>
inoremap <up>    <nop>
inoremap <down>  <nop>
inoremap <left>  <nop>
inoremap <right> <nop>

set pastetoggle=<F2>

noremap <C-h> <C-w>h
noremap <C-i> <C-w>i
noremap <C-l> <C-w>l
noremap <C-j> <C-w>j

"""
""" AUTOCOMMANDS
"""
augroup ft_xml
    autocmd!
    autocmd BufRead,BufNewFile pom.xml set filetype=maven
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType maven setlocal syntax=xml
augroup END

augroup ft_latex
    autocmd!
    autocmd BufRead *.tex setlocal spell spelllang=en_nz
augroup END

augroup ft_javascript
    autocmd!
    autocmd fileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd fileType vue setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

augroup ft_yaml
    autocmd!
    autocmd FileType yml,yaml setlocal ts=2 sts=2 sw=2 foldlevel=2 expandtab
augroup END

augroup ft_ruby
    autocmd!
    autocmd BufRead,BufNewFile *.erb set filetype=eruby
    autocmd BufRead,BufNewFile */cookbooks/*/*.rb set filetype=ruby.chef
    autocmd FileType ruby,ruby.chef setlocal ts=2 sts=2 sw=2 expandtab
augroup END

augroup ft_markdown
    autocmd!
    autocmd BufNewFile,BufReadPost *.md set ft=markdown
    autocmd FileType markdown setlocal ts=4 sts=4 sw=4 wrap
augroup END

augroup ft_git
    autocmd!
    autocmd BufRead,BufNewFile *gitconfig* set ft=dosini
    autocmd FileType gitcommit setlocal tw=72
augroup END

augroup ft_ansible
    autocmd!
    autocmd BufRead,BufNewFile */ansible/*/hosts set syntax=ansible_hosts
    autocmd BufRead,BufNewFile */ansible/*/*.yml set syntax=ansible
    autocmd FileType ansible setlocal ts=2 sts=2 sw=2 expandtab
augroup END

augroup ft_groovy
    autocmd!
    autocmd BufRead,BufNewFile Jenkinsfile set ft=groovy
augroup END
