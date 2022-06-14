" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on

" Set space as leader
" " Space acts as a fucking step to the right so we need to unmap it
noremap <Space> <Nop>
sunmap <Space>

let mapleader = " "
nnoremap <Leader>s :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <leader><leader>a <C-^>
nnoremap <leader>- :bd<Cr>

" Security (arbirary code execution >_>)
set modelines=0

" Show line numbers
set number
set relativenumber

" Show file stats
set ruler

" allow mouse scroll
set mouse=a

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=79
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search


" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
" set list " To enable by default
" Or use your leader key + l to toggle on/off
map <leader>l :set list!<CR> " Toggle tabs and EOL

"" Color scheme (terminal)
set t_Co=256
set background=dark
colorscheme peachpuff
