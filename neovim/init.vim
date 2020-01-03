" vim: fdm=marker
" 
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

" ============================================================================
" Leader {{{1
" ============================================================================
" Set space as leader
" Space acts as a fucking step to the right so we need to unmap it
noremap <Space> <Nop>
sunmap <Space>

" mapleader has to be up here because it works only on what comes after
let mapleader=' '
let maplocalleader=' '

" ============================================================================
" Plugins {{{1
" ============================================================================
call plug#begin('~/.vim/plugged')

" Syntax highlighting
Plug 'sheerun/vim-polyglot'          " better syntax highlight

" Editing
Plug 'tpope/vim-surround'            " cs surrounding capabilities eg. cs)], csw'  
Plug 'christoomey/vim-system-copy'   " cp/cv for copy paste e.g. cvi = paste inside '
Plug 'junegunn/vim-easy-align'       " sounds super cool, never used so far
Plug 'sbdchd/vim-shebang'            " automatically add #! stuff to files
Plug 'tpope/vim-commentary'          " gc code away
Plug 'tmhedberg/SimpylFold'          " Better folding
Plug 'Konfekt/FastFold'              " Suggested by SimplyFold to improve speed
" Plug 'terryma/vim-multiple-cursors'  " very cool but seems kinda buggy

" Tags management
Plug 'universal-ctags/ctags'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" Organization
Plug 'vimwiki/vimwiki'
Plug 'itchyny/calendar.vim'

" Appearance
Plug 'joshdick/onedark.vim'         " atom inpspired true color theme
Plug 'itchyny/lightline.vim'        " lightweight status line
Plug 'ap/vim-buftabline'            " Show open buffers
Plug 'ryanoasis/vim-devicons'       " DevIcons for some plugins
Plug 'dominikduda/vim_current_word' " highlight current word and other occurrences

" Navigation
" Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'        " For git-awareness (used by fzf commands) 
Plug 'easymotion/vim-easymotion' " THE GOD PLUGIN
Plug 'scrooloose/nerdtree'       " better netrw vim navigation
Plug 'mbbill/undotree'           " More easily navigate vim's poweful undo tree

Plug 'tpope/vim-repeat'          " Allows repeating some plugins operations using .
Plug 'kassio/neoterm'            " easier terminal management in vim
Plug 'SirVer/ultisnips'          " custom snippets
" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" ============================================================================
" Lightline {{{2
" ============================================================================
set noshowmode " Not needed since the mode is shown in lighline
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'filename': 'LightlineFilename',
      \ },
      \ }

" Show file path relative to git root or absolutepath
" https://github.com/itchyny/lightline.vim/issues/293h
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" ============================================================================
" BufTabLine {{{2
" ============================================================================
let g:buftabline_numbers=2      " Show ordinal tab numbers (not the vim buffer ones)
" Doesn't display correct with CascadiaCode Nerd Font
" let g:buftabline_separators=1   " Add vertical bars beween tabs

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

" ============================================================================
" tagbar {{{2
" ============================================================================

nmap <F6> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" ============================================================================
" CtrlP {{{2
" ============================================================================
" if executable('rg')
"   set grepprg=rg\ --color=never
"   let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
"   let g:ctrlp_use_caching = 0
" endif

" ============================================================================
" UltiSnips {{{2
" ============================================================================

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/neovim/UltiSnips']

" ============================================================================
" vimwiki {{{2
" ============================================================================
set nocompatible
filetype plugin on
syntax on

augroup vimwikibynds
    autocmd FileType vimwiki imap <buffer><silent> <c-t> <Plug>VimwikiIncreaseLvlWholeItem
    autocmd FileType vimwiki imap <buffer><silent> <c-d> <Plug>VimwikiDecreaseLvlWholeItem
augroup end

let $VIMWIKI_DIR = $HOME . "/Dropbox/vimwiki"

function! s:QuickNote()
  py import uuid
  let l:id = pyeval('str(uuid.uuid4())')
  let l:path = $VIMWIKI_DIR . "/note.". l:id . ".wiki"
  execute "e " . l:path
  startinsert
endfunction

nmap <leader>no :call <SID>QuickNote()<CR>

let g:vimwiki_folding='expr'
let g:vimwiki_table_mappings=0 " Prevent conflict with UltiSnips tab completion
let g:vimwiki_list = [{'auto_tags': 1, 'auto_diary_index': 1}]
let g:tagbar_type_vimwiki = {
          \   'ctagstype':'vimwiki'
          \ , 'kinds':['h:header:1']
          \ , 'sro':'&&&'
          \ , 'kind2scope':{'h':'header'}
          \ , 'sort':0
          \ , 'ctagsbin':'/home/lapo/dotfiles/neovim/vwtags.py'
          \ , 'ctagsargs': 'default'
          \ }

" ============================================================================
" EasyMotion {{{2
" ============================================================================
set nohlsearch " easymotion will do the highlighting
" Use easymotion to search 
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
" map  n <Plug>(easymotion-next)
" map  N <Plug>(easymotion-prev)
map  <C-w> <Plug>(easymotion-next)
map  <C-e> <Plug>(easymotion-prev)
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" ============================================================================
" FZF {{{2
" ============================================================================
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

" Use FZF to search in current file dir with preview
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
nnoremap <c-s> :Files<CR>

" Offload interactive search to Rg, use FzF only as a wrapper around it, also
" add preview
" USES FUGITIVE FOR HANDLING GIT
function! GitAwarePath()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p:h')
  if path[:len(root)-1] ==# root
    return root
  endif
  return path
endfunction
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let path = GitAwarePath() 
  echo path
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command],'dir':path}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction
" Original from https://github.com/junegunn/fzf.vim#example-advanced-rg-command
" function! RipgrepFzf(query, fullscreen)
"   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
"   let initial_command = printf(command_fmt, shellescape(a:query))
"   let reload_command = printf(command_fmt, '{q}')
"   let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
"   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
" endfunction
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
" Use RipGrep to search inside files
nnoremap <c-g> :Rg<CR>


" When fzf starts in a terminal buffer, the file type of the buffer is set to fzf. So you can set up FileType fzf autocmd to 
" customize the settings of the window.For example, if you use the default layout ({'down': '~40%'}) on Neovim, you might 
" want to temporarily disable the statusline for a cleaner look.
if has('nvim') && !exists('g:fzf_layout')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
endif

" ============================================================================
" vim-easy-align {{{2
" ============================================================================
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ============================================================================
" gutentags {{{2
" ============================================================================
" augroup MyGutentagsStatusLineRefresher
"     autocmd!
"     autocmd User GutentagsUpdating call lightline#update()
"     autocmd User GutentagsUpdated call lightline#update()
" augroup END
" Do not pollute projects with tag files, keep them all in one place.
let g:gutentags_cache_dir = '~/.tags_dir'

" ============================================================================
" NeoTerm {{{2
" ============================================================================
let g:neoterm_direct_open_repl=1
let g:neoterm_repl_python='/home/lapo/miniconda3/envs/deep/bin/ipython --no-autoindent --pylab'

let g:neoterm_default_mod=':vertical'
let g:neoterm_size=80
let g:neoterm_autoscroll=1

function! IPythonLoadCurrentFile()
  " Get absolute path of current file
  let path = expand('%:p')
  " Send ipython magic to load current file, . does string concatenation
  execute "T %load " . path
  " I have no idea how to send the final newline, I'll use another magic as a
  " hack, people like seeing time and shit anyways.
  execute "T %time"
endfunction

function! IPythonLoadCurrentLine()
  " yank current line to clipboard
  normal! "+yy
  " paste in python REPL from clipboard using %paste magic
  execute "T %paste"
  " move down a line to chain multiple calls easily
  normal! j
endfunction

" Without range it will call the function for every line in the range
function! IPythonLoadCurrentVisualSelection() range
  " The range has been yanked to clipboard already
  execute "T %paste"
  " Move to the end of visual selection and then down a line, see :h `> for
  " info
  normal! `>j
endfunction

nnoremap <leader>t :call IPythonLoadCurrentLine()<CR>
vnoremap <leader>t "+y<CR>:call IPythonLoadCurrentVisualSelection()<CR>
nnoremap <leader>T :call IPythonLoadCurrentFile()<CR>

tnoremap <ESC> <C-\><C-n>

" ============================================================================
" NERDTree {{{2
" ============================================================================
silent! nmap <F7> :NERDTreeToggle<CR>

" let g:NERDTreeMapActivateNode="<F3>"
" let g:NERDTreeMapPreview="<F4>"

" ============================================================================
" vim-shebang {{{2
" ============================================================================
"
" Define my common Shebang
let g:shebang#shebangs = {
            \ 'julia': '#!/usr/bin/env julia',
            \ 'sh': '#!/usr/bin/env bash',
            \ 'python': '#!/usr/bin/env python',
            \ 'R': '#!/usr/bin/env Rscript'
            \}

" ============================================================================
" SimplyFold {{{2
" ============================================================================

let g:SimpylFold_docstring_preview=1
set foldmethod=indent
set foldlevel=99

" ============================================================================
" vim-undotree {{{2
" ============================================================================

if has("persistent_undo")
    set undodir=~/.local/share/nvim/undodir
    set undofile
    set backupdir=~/.local/share/nvim/backupdir " Don't put backups in current dir
    set backup
    set noswapfile
endif

nnoremap <F5> :UndotreeToggle<cr>

if !exists("*Undotree_CustomMap")
  " use lower case j/k to navigate
  function g:Undotree_CustomMap()
        nmap <buffer> k <plug>UndotreeNextState
        nmap <buffer> j <plug>UndotreePreviousState
  endfunc
endif

let g:undotree_SetFocusWhenToggle = 1

" ============================================================================
" vim_current_word {{{2
" ============================================================================

" Added some colors at the end of file
" hi CurrentWord ctermbg=236
" hi CurrentWordTwins ctermbg=237

" ============================================================================
" UI Layout {{{1
" ============================================================================

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

" Messes up stuff badly, seems to have started after switching from
" gnome-terminal to urxvt
" let t_Co = 256
" if (has("termguicolors"))
"     set termguicolors
" endif

set background=dark " Because dark is cool
set encoding=utf8
colorscheme onedark " Tomorrow-Night-Eighties

" ============================================================================
" Basic settings {{{1
" ============================================================================

syntax on                              " Enable syntax highlighting
set smarttab                           " Be smart when using tabs ;)
set expandtab                          " Replace tabs with spaces
set shiftwidth=2                       " 1 tab == 2 spaces
set tabstop=2                          " 1 tab == 2 spaces
set clipboard=unnamedplus              " send yanks to clipboard
set showcmd                            " Show partial commands in the last line of the screen
set nu                                 " Set both types of NUmbering to get hybrid Relative NUmbering"
set rnu
set title                              " Set the terminal title
" set ruler                              " Display the cursor position
" set cursorline                         " Highlight current line to find the cursor more easily
" set cursorcolumn                       " Highlight current column to find the cursor more easily
set laststatus=2                       " Always display the status line, even if only one window is displayed
set cmdheight=2                        " Set the command window height to 2 lines to avoid press <Enter> to continue"
set list                               " Show newlines and tabs
set listchars=tab:▸\ ,eol:¬            " Use the same symbols as TextMate for tabstops and EOLs
set incsearch                          " Find the next match as we type the search
set ignorecase                         " Ignore case when searching...
set smartcase                          " ...unless we type a capital
set history=1000                       " Remember more commands and search history
set undolevels=1000                    " Use many muchos levels of undo
set mouse=a                            " Enable use of the mouse for all modes
set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings
set completeopt+=menuone,noselect,noinsert,preview " show popup menu when at least one match but don't insert stuff
set complete=.,w,b,u,t,kspell        " Check file -> window -> buffer -> hidden buffers -> tabs -> spelling if enabled
set omnifunc=syntaxcomplete#Complete " On <c-x><c-o> use the file syntax to guess possible completions
set autoread                           " Reload files changed outside vim

" Wildmenu
if has("wildmenu")
    set wildignore+=*.a,*.o
    set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
    set wildignore+=.DS_Store,.git,.hg,.svn
    set wildignore+=*~,*.swp,*.tmp
    set wildmenu
    set wildmode=longest,list
endif

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Remove annoying beeping or visual bells
set visualbell
set noerrorbells

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

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

let g:python3_host_prog="/home/lapo/miniconda3/envs/neovim3/bin/python"
let g:python_host_prog="/home/lapo/miniconda3/envs/neovim2/bin/python"

" Allows you to save files you opened without write permissions via sudo
" cmap w!! w !sudo tee %

" ============================================================================
" Mappings {{{1
" ============================================================================

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Open new split panes to right and bottom, which feels more natural than Vim’s default
set splitbelow
set splitright

" Let's avoid typing :Q ever again
" Problem, my brain hates having to remember if I'm in a mode where this is
" remapped or not
" nnoremap ; :
" nnoremap : ;

" Use capital W as a shortcut to save
nnoremap W :w<CR>
nnoremap Q :q<CR>

" center current line after jumping to prev/next locations
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" not that hjkl is any better but it's a start
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" ============================================================================
" Custom colors {{{1
" ============================================================================
" At the bottom to override themes and shit

hi CurrentWord ctermbg=236
hi VimwikiLink ctermfg=39 cterm=underline
" Use terminal background color to customize (no more trying to match both
" because of vim's uneven borders)
hi Normal guibg=NONE ctermbg=NONE
