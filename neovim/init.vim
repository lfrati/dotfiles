
"vim: fdm=marker
"
" ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
" ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
" ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
" ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
" ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
" ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
"
"  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
" ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
" ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
" ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
" ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
"  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
"
"

" ================ Leader ========================== {{{1
" Set space as leader
" Space acts as a fucking step to the right so we need to unmap it
noremap <Space> <Nop>
sunmap <Space>

" mapleader has to be up here because it works only on what comes after
let mapleader=' '
let maplocalleader=' '

" ================ Plugins ========================== {{{1

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'tpope/vim-repeat'
Plug 'lervag/vimtex'


" Editing
Plug 'tpope/vim-surround'       
Plug 'tpope/vim-commentary'
Plug 'christoomey/vim-system-copy'
Plug 'terryma/vim-multiple-cursors'
Plug 'universal-ctags/ctags'
Plug 'ludovicchabant/vim-gutentags'
Plug 'ervandew/supertab'
Plug 'kassio/neoterm'

" Appearance
Plug 'joshdick/onedark.vim'     " atom inpspired true color theme
Plug 'itchyny/lightline.vim'    " lightweight status line
Plug 'ap/vim-buftabline'        " Show open buffers
Plug 'sheerun/vim-polyglot'     " better syntax highlight
Plug 'junegunn/vim-easy-align'

" Navigation
" PlugInstall and PlugUpdate will clone fzf in ~/.fzf and run the install script
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdTree'        " better netrw navigation

" List ends here. Plugins become visible to Vim after this call.
call plug#end()


set noshowmode " Not needed since the mode is shown in lighline
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch','gutentags', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'gutentags': 'gutentags#statusline'
      \ },
      \ }

" ============ Buftabline opts ============
let g:buftabline_numbers=2      " Show ordinal tab numbers (not the vim buffer ones)
let g:buftabline_separators=1   " Add vertical bars beween tabs

" Use leader+number to quickly change tab
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nnoremap <Leader>- :bd<Cr>

" ============ Easymotion opts ============
" <Leader>p{char}{char} to move to the pair {char}{char}
nmap <Leader>p <Plug>(easymotion-overwin-f2)

" Without this bindings <Leader>w behaves very strangely TODO: find out why.
map <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

set nohlsearch " easymotion will do the highlighting
" Use easymotion to search 
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" ============ FZF opts ============
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

nnoremap <leader>rg :Rg

" Use fzf to search in buffers
nnoremap <leader>l :Lines<CR>
nnoremap <leader>f :Files<CR>

" ============ nerdtree opts ============
nnoremap <leader>n :NERDTreeToggle<CR>
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1

" === multiple-cursors opts ===
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key = '<C-s>'
let g:multi_cursor_next_key       = '<C-s>'
let g:multi_cursor_skip_key       = '<C-x>'
let g:multi_cursor_quit_key       = '<Esc>'

" === prettier opts ===
let g:prettier#config#tab_width=4
" when running at every change you may want to disable quickfix
let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat = 0
autocmd BufWritePre *.js,*.json,*.css,*.scss,*.less,*.graphql PrettierAsync

" === vim-easy-align opts ===
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" === gutentags opts ===
" augroup MyGutentagsStatusLineRefresher
"     autocmd!
"     autocmd User GutentagsUpdating call lightline#update()
"     autocmd User GutentagsUpdated call lightline#update()
" augroup END
" Do not pollute projects with tag files, keep them all in one place.
let g:gutentags_cache_dir = '~/.tags_dir'

" === neoterm opts ===
let g:neoterm_repl_python= '/home/lapo/miniconda3/envs/deep/bin/ipython'
let g:neoterm_default_mod= ':vertical'
let g:neoterm_size=80
let g:neoterm_autoscroll=1

nnoremap <leader>t :TREPLSendLine<CR>
vnoremap <leader>t :TREPLSendSelection<CR>
tnoremap <ESC> <C-\><C-n>

" ================ Colors =========================== {{{1

""Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
""If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
""(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"if (empty($TMUX))
"  if (has("nvim"))
"  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"  endif
"  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"  if (has("termguicolors"))
"    set termguicolors
"  endif
"endif


" ================ Appearance  ====================== {{{1
set expandtab       " Use spaces instead of tabs
set smarttab        " Be smart when using tabs ;)
set shiftwidth=4    " 1 tab == 4 spaces
set tabstop=4
set clipboard=unnamedplus

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

syntax on           " Enable syntax highlighting
colorscheme         onedark "Tomorrow-Night-Eighties

set background=dark " Because dark is cool
set showcmd         " Show partial commands in the last line of the screen
set nu              " Set both types of NUmbering to get hybrid Relative NUmbering"
set rnu
set title           " Set the terminal title
set ruler           " Display the cursor position
set cursorline      " Highlight current line to find the cursor more easily
set cursorcolumn    " Highlight current column to find the cursor more easily
set laststatus=2    " Always display the status line, even if only one window is displayed
set cmdheight=2     " Set the command window height to 2 lines to avoid press <Enter> to continue"
set list                    " Show newlines and tabs
set listchars=tab:▸\ ,eol:¬ " Use the same symbols as TextMate for tabstops and EOLs

" Remove annoying beeping or visual bells
set visualbell
set noerrorbells

set incsearch  " Find the next match as we type the search
set ignorecase " Ignore case when searching...
set smartcase  " ...unless we type a capital


" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

set history=1000                       " Remember more commands and search history
set undolevels=1000                    " Use many muchos levels of undo
set mouse=a                            " Enable use of the mouse for all modes
set autoread                           " Reload files changed outside vim
set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline
set whichwrap+=<,>,h,l

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm


" let :s/:%s show incremental highlight of matches in a temporary split
set inccommand=split

" ================ Mappings ===========================  {{{1

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Open new split panes to right and bottom, which feels more natural than Vim’s default
set splitbelow
set splitright

" Let's avoid typing :Q ever again
nnoremap ; :
nnoremap : ;

" center current line after jumping to prev/next locations
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" not that hjkl is any better but it's a start
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
