" ~/.vimrc — Farhabi Helal's Vim Configuration
" https://github.com/farhabihelal
" =============================================================================

" ===========================================================================
" General Settings
" ===========================================================================
set nocompatible            " Disable vi compatibility
filetype plugin indent on   " Enable file type detection
syntax enable               " Enable syntax highlighting

set encoding=utf-8          " Default encoding
set fileencoding=utf-8
set termencoding=utf-8

set history=1000            " Remember more commands
set undolevels=1000         " More undo levels
set undofile                " Persistent undo
set undodir=~/.vim/undodir  " Undo directory (create it: mkdir -p ~/.vim/undodir)

set autoread                " Reload files changed outside Vim
set hidden                  " Allow switching buffers without saving
set noswapfile              " Disable swap files
set nobackup                " Disable backup files

" ===========================================================================
" UI Settings
" ===========================================================================
set number                  " Show line numbers
set relativenumber          " Show relative line numbers
set cursorline              " Highlight current line
set showcmd                 " Show partial commands in status line
set showmode                " Show current mode
set ruler                   " Show cursor position
set laststatus=2            " Always show status line
set wildmenu                " Enhanced command line completion
set wildmode=list:longest   " Complete longest common string
set scrolloff=8             " Keep 8 lines visible above/below cursor
set sidescrolloff=8         " Keep 8 columns visible left/right of cursor
set signcolumn=yes          " Always show sign column
set colorcolumn=88          " Highlight column 88 (Black/PEP8 compatible)
set textwidth=0             " Don't auto-wrap text

" Splits
set splitbelow              " Horizontal splits open below
set splitright              " Vertical splits open to the right

" ===========================================================================
" Search
" ===========================================================================
set incsearch               " Incremental search
set hlsearch                " Highlight search results
set ignorecase              " Case-insensitive search...
set smartcase               " ...unless uppercase is used

" ===========================================================================
" Indentation
" ===========================================================================
set expandtab               " Use spaces instead of tabs
set tabstop=4               " Tab width
set softtabstop=4           " Soft tab width
set shiftwidth=4            " Indent width
set autoindent              " Copy indent from current line
set smartindent             " Smart indentation

" File-type specific indentation
autocmd FileType yaml,json,html,css,javascript,typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType go setlocal noexpandtab tabstop=4 shiftwidth=4

" ===========================================================================
" Key Mappings
" ===========================================================================
let mapleader = " "         " Space as leader key

" Clear search highlight
nnoremap <leader>/ :nohlsearch<CR>

" Save / Quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>

" Buffer navigation
nnoremap <leader>] :bnext<CR>
nnoremap <leader>[ :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Split navigation (Ctrl+hjkl)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Indent/unindent with Tab in visual mode
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ===========================================================================
" Statusline (simple, no plugins)
" ===========================================================================
set statusline=
set statusline+=\ %f          " File path
set statusline+=\ %m          " Modified flag
set statusline+=\ %r          " Read-only flag
set statusline+=%=            " Right align
set statusline+=\ %y          " File type
set statusline+=\ %{&encoding}
set statusline+=\ %l:%c       " Line:column
set statusline+=\ %p%%\       " Percentage through file

" ===========================================================================
" Miscellaneous
" ===========================================================================
set backspace=indent,eol,start  " Sensible backspace
set noerrorbells                " No error bells
set visualbell                  " Flash instead of beep
set t_vb=                       " No terminal visual bell

" Remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" ===========================================================================
" Plugin Settings (uncomment if using vim-plug or similar)
" ===========================================================================
" call plug#begin('~/.vim/plugged')
"   Plug 'tpope/vim-sensible'
"   Plug 'tpope/vim-fugitive'
"   Plug 'airblade/vim-gitgutter'
"   Plug 'preservim/nerdtree'
"   Plug 'ctrlpvim/ctrlp.vim'
"   Plug 'dense-analysis/ale'
"   Plug 'vim-airline/vim-airline'
"   Plug 'morhetz/gruvbox'
" call plug#end()

" Colour scheme (uncomment one once the plugin is installed)
" colorscheme gruvbox
" set background=dark
