"""
""" CONFIG FLAGS
"""
set termguicolors

set background=dark

colorscheme nordic

set cursorline                                                                          " highlight current line
set shortmess=a                                                                         " abbreviate some of the stuff shown in cmd line
set shortmess+=t                                                                        " abbreviate file name in cmd line if too long
set shortmess+=I                                                                        " hide startup message
set number                                                                              " hide normal line numbers
set relativenumber                                                                      " show relative line numbers
set numberwidth=3                                                                       " minimum width of line number column
set hidden                                                                              " allow unsaved buffers
set textwidth=120                                                                       " set the textwidth to be 120 chars
set diffopt+=iwhite                                                                     " ignore whitespace in diffs
set diffopt+=vertical                                                                   " split diffs vertically
set splitright                                                                          " show splits to the right
set formatoptions+=c,q,r,t,l                                                            " configure auto-formatting
set showmatch                                                                           " when a bracket is inserted, briefly jump to the matching one.
set copyindent
set tabstop=4                                                                           " the amount of spaces a tab counts for
set shiftwidth=4                                                                        " number of spaces to use for each step of indent
set softtabstop=4                                                                       " number of spaces a tab counts for while performing edits
set shiftround                                                                          " Round indents to multiples of shiftwidth.
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
set list                                                                                " show whitespace characters
set scrolloff=5                                                                         " minimal number of screen lines to keep above and below the cursor
set ruler                                                                               " show row/col pos and % file position in status bar
set nowrap                                                                              " do not wrap long lines
set nobackup
set noswapfile
set lazyredraw
set synmaxcol=3000
set noshowmode                                                                          " mode is already visible in status bar

if filereadable('/usr/share/dict/words')
    set dictionary+=/usr/share/dict/words
end

set spelllang=en_us
set nospell

"""
""" GLOBALS
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
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lint_on_text_changed = 'never'

let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

let g:vimwiki_list = [{'path': '~/Documents/vimwiki/',
            \ 'syntax': 'markdown', 'ext': '.md'}]

let g:rainbow_active = 1

let g:fzf_preview_window = ['right:hidden', 'ctrl-/']
let g:fzf_layout = { 'down': '40%' }


"""
""" KEYBINDINGS
"""
let mapleader = ","                                                                     " set leader key to comma

nnoremap <leader><space> :nohlsearch<CR>                                                " set key to turn off search highlighting

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nmap <silent><leader>ev :edit ~/.vimrc<CR>                                             " set key to quickly open vimrc in new buffer
nmap <silent><leader>sv :source ~/.vimrc<CR>                                           " set key to source vimrc

noremap <leader>W :w !sudo tee % > /dev/null<CR>                                       " set key to save file as root

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
augroup general
    autocmd!
    " When editing a git commit, DO NOT jump to the last cursor position
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
augroup END

augroup ft_ansible
    autocmd!
    autocmd BufRead,BufNewFile */playbooks/*.yml set filetype=yaml.ansible
    autocmd BufRead,BufNewFile */ansible/*/*.yml set syntax=yaml.ansible
    autocmd BufRead,BufNewFile */ansible/*/hosts set syntax=ansible_hosts
    autocmd FileType yaml.ansible setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup END

augroup ft_groovy
    autocmd!
    autocmd BufRead,BufNewFile Jenkinsfile set ft=groovy
augroup END


"""
""" NVIM LUA
"""
lua require('plugins')
lua require('config')
