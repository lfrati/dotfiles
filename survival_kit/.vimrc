" Don't try to be vi compatible. Seriously. Don't.
set nocompatible
" Turn on syntax highlighting
syntax on

" Set space as leader
" " Space acts as a fucking step to the right so we need to unmap it
noremap <Space> <Nop>
sunmap <Space>
let mapleader = " "
nnoremap <Leader>s :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <leader><leader>a <C-^>
nnoremap <leader>- :bd<Cr>
" Easier split navigation
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>h <C-W><C-H>
" Virmc tweaking
nnoremap <leader>init :e ~/.vimrc<CR>
nnoremap <leader>r :so ~/.vimrc<CR> :echo "Reloaded ~/.vimrc"<CR>

set modelines=0    " security (arbirary code execution >_>)
set hidden         " Allow hidden buffers
set ttyfast        " oh yeah send all those characters.. mmm
set timeoutlen=1000
set ttimeoutlen=5  " nobody ain't time for waiting to exit
set number         " show line number on current line
set relativenumber " show relative numbers on the rest
set scrolloff=5    " keep some lines in the bottom top of files
set ruler          " Show file stats
set mouse=a        " allow mouse scroll
set visualbell     " Blink cursor on error instead of beeping (grr)
set encoding=utf-8 " Encoding
set wrap
set textwidth=79   " very pep-8 compatible
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab      " nobody loves tabs
set noshiftround
set laststatus=2   " Always show statusline
set noshowmode     " already handled by the statusline
set showcmd        " see partial commands in the bottom right corner
set nohlsearch     " I hate turning off search hl more than not having them
set incsearch      " Show match as you type (I wish it showed all of them)
set ignorecase     " Don't care about case ...
set smartcase      " ... unless it is a capital leter
set splitbelow     " that's where I expect help buffer to open

" Make the cursor a vertical bar in insert mode (god bless nvim for ending this
" madness)
au InsertEnter * silent execute "!echo -en \<esc>[5 q"
au InsertLeave * silent execute "!echo -en \<esc>[2 q"

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Searching
nnoremap / /\v
vnoremap / /\v
" Use of "\v" means that in the pattern after it all ASCII characters except
" '0'-'9', 'a'-'z', 'A'-'Z' and '_' have a special meaning.  "very magic"

"" Color scheme (terminal)
set t_Co=256
set background=dark
colorscheme peachpuff
hi NormalColor ctermbg=76 ctermfg=0 cterm=bold
hi InsertColor ctermbg=75 ctermfg=0 cterm=bold
hi ReplaceColor ctermbg=168 ctermfg=0 cterm=bold
hi VisualColor ctermbg=176 ctermfg=0 cterm=bold
hi ModifiedColor ctermbg=1 ctermfg=0 cterm=bold
set statusline=
set statusline+=%#NormalColor#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#InsertColor#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#ReplaceColor#%{(mode()=='R')?'\ \ REPLACE\ ':''}
set statusline+=%#VisualColor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%#ModifiedColor#
set statusline+=%m " modified flag VERY IMPORTANT
set statusline+=%#StatusLineNC# 
set statusline+=\ %f " filename
set statusline+=%= " add spacing, reminds me of the screenrc syntax
set statusline+=\ %p%% " percentage of file
set statusline+=\ %l:%c " line/column
set statusline+=\ %y " filetype
