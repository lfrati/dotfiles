" vim: set foldmethod=marker foldlevel=999 nomodeline:
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

" ============================================================================
" Leader {{{
" ============================================================================
" Set space as leader
" Space acts as a fucking step to the right so we need to unmap it
noremap <Space> <Nop>
sunmap <Space>

" mapleader has to be up here because it works only on what comes after
let mapleader=' '
let maplocalleader=' '

" }}}
" ============================================================================
" Plugins {{{
" ============================================================================

" needed by various plugins
set nocompatible
filetype plugin on
syntax on

call plug#begin('~/.vim/plugged')

Plug 'qpkorr/vim-bufkill'

Plug 'tpope/vim-unimpaired'

Plug 'ajh17/VimCompletesMe'

Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1

" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  nmap <Leader>p <Nop>
  augroup prettiercmds
    autocmd! prettiercmds
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
  augroup end


Plug 'psf/black', { 'branch': 'stable' , 'for' : 'python'}
augroup pycmds
  autocmd! pycmds
  autocmd BufWritePre *.py execute ':Black'
  " autocmd BufWritePre *.py call s:SafeFormat()
  " I've found a bug where sometimes black messes up Semshi's highlighting
  " this is a horrible fix. God have mercy.
  autocmd BufWritePost *.py execute ':Semshi highlight'
augroup end

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
  function MySemshiColors()
      hi semshiGlobal          ctermfg=red
      hi semshiLocal           ctermfg=209
      hi semshiGlobal          ctermfg=214
      hi semshiImported        ctermfg=180
      hi semshiParameter       ctermfg=75
      hi semshiParameterUnused ctermfg=117  cterm=underline
      hi semshiFree            ctermfg=218
      hi semshiBuiltin         ctermfg=207
      hi semshiAttribute       ctermfg=49
      hi semshiSelf            ctermfg=249
      hi semshiUnresolved      ctermfg=226  cterm=underline
      hi semshiSelected        ctermfg=40 ctermbg=bg
      hi semshiErrorSign       ctermfg=231  ctermbg=160
      hi semshiErrorChar       ctermfg=231  ctermbg=160
      sign define semshiError text=E> texthl=semshiErrorSign
  endfunction
  function GoSemshi()
      nmap <buffer> <silent> <leader>rn :Semshi rename<CR>
      nmap <buffer> <silent> <leader>er :Semshi goto error<CR>
  endfunction
  augroup semshicmds
    autocmd! semshicmds
    autocmd FileType python call GoSemshi()
    autocmd ColorScheme * call MySemshiColors()
  augroup end

" God this plugin is good. Live rendering, cursor syncing
" Makes previewing my vimkikis hella easy
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for':['markdown','vimwiki'] }
  " nmap <leader>md <Plug>MarkdownPreviewToggle
  nmap <leader>m <Plug>MarkdownPreviewToggle

" The third component of the holy trinity of plugins
" (fzf + vimwiki + easymotion)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'junegunn/fzf.vim'
  " Always enable preview window on the right with 60% width
  " let g:fzf_preview_window = 'right:60%'
  let g:fzf_layout = {'window': {'height':0.8, 'width':0.8, 'border':'sharp'}}
  let $FZF_DEFAULT_OPTS='--reverse --preview-window noborder' " hide broken rounded corners in the inner preview
  let $FZF_DEFAULT_OPTS.=' --bind ctrl-a:select-all,ctrl-d:deselect-all'
  function! RipgrepFZF(query, fullscreen)
    " line-number is needed for the preview
    " '|| true' prevents showing 'command failed ...' when nothing is matched
    let command_fmt = 'rg --line-number --with-filename --no-heading --sortr=modified -T jupyter --color=always --smart-case %s %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query),'')
    let reload_command = printf(command_fmt, '{q}', '')
    let spec = {
             \ 'source' : initial_command,
             \ 'options':[ '--bind', 'change:reload:' . reload_command,
                         \ '--phony',
                         \ '--ansi',
                         \ '--multi'],
             \ 'dir':expand('%:p:h')
             \ }
    call fzf#run(fzf#wrap(fzf#vim#with_preview(spec)))
  endfunction
  command! -nargs=* -bang MyRg call RipgrepFZF(<q-args>, <bang>0)
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fl :Lines<CR>
  nnoremap <leader>frg :MyRg<CR>
  " fzf.vim Rg uses fuzzy matching
  nnoremap <leader>frf :Rg<CR>

Plug 'itchyny/lightline.vim'        " lightweight status line
  let g:lightline = {
      \ 'mode_map': {
      \    'n' : 'N',
      \    'i' : 'I',
      \    'R' : 'R',
      \    'v' : 'V',
      \    'V' : 'VL',
      \    "\<C-v>": 'VB',
      \    'c' : 'C',
      \    's' : 'S',
      \    'S' : 'SL',
      \    "\<C-s>": 'SB',
      \    't': 'T',
      \ },
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [
      \             [ 'mode', 'paste','readonly'],
      \             [ 'mymodified','modified' ],
      \             [ 'absolutepath' ]
      \           ],
      \   'right': [
      \              [ 'lineinfo' ],
      \            ]
      \ },
      \ 'inactive': {
      \ 'left': [ [ 'absolutepath'] ],
      \ 'right': [ ['modified'] ]
      \ },
      \ 'component_expand':{
      \   'mymodified' : 'ModifiedFlag',
      \ },
      \ 'component_type':{
      \   'mymodified' : 'error',
      \ }
      \ }
  function! SetupLightlineColors() abort
    " transparent background in statusbar
    let l:palette = lightline#palette()
    "                                  guibg,     guifg,    ctermbg ctermfg"
    let l:palette.normal.middle = [ [ '#ABB2BF', '#282C34', '235', '174' ] ]
    let l:palette.inactive.middle = [ [ '#ABB2BF', '#282C34', '145', '146' ] ]
    let l:palette.inactive.right = [ [ '#ABB2BF', '#282C34', '235', '204' ] ]
    " let l:palette.tabline.middle = l:palette.normal.middle
    call lightline#colorscheme()
  endfunction
  autocmd! VimEnter * call SetupLightlineColors()

Plug 'easymotion/vim-easymotion' " THE GOD PLUGIN
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
  " Disable mappings
  let g:EasyMotion_do_mapping = 0

Plug 'mbbill/undotree'           " More easily navigate vim's poweful undo tree
  if has("persistent_undo")
      set undodir=~/.local/share/nvim/undodir//
      set undofile
      set backupdir=~/.local/share/nvim/backupdir// " Don't put backups in current dir
      set backup
      set directory=~/.local/share/nvim/swapdir//
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
  augroup change_triggers
    autocmd! change_triggers
    " update the file whenever I switch to a new buffer or get back to nvim
    " NEEDED BECAUSE WE DON'T USE SWAP FILES!!!!
    autocmd FocusGained * checktime
    autocmd BufEnter * checktime
  augroup END

Plug 'tpope/vim-surround'
  " cs surrounding capabilities eg. cs)]
  " 'Hello world'  -> cs']  -> [Hello  world]
  " 'Hello world'  -> ds'   ->  Hello  world
  "  H(e)llo world -> ysiw' -> 'Hello' world
  "  H(e)llo world -> csw'  -> 'Hello' world  # bug or intended?
  "yss" works on a line"

Plug 'christoomey/vim-system-copy'   " cp/cv for copy paste e.g. cvi = paste inside '

Plug 'tpope/vim-commentary'          " gc code away

Plug 'tpope/vim-repeat'          " Allows repeating some plugins operations using .

Plug 'ryanoasis/vim-devicons'       " DevIcons for some plugins

Plug 'preservim/nerdtree'
  map <C-n> :NERDTreeToggle<CR>

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'joshdick/onedark.vim'         " atom inpspired true color theme

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" }}}
" ============================================================================
" Basic settings {{{
" ============================================================================

syntax on                              " Enable syntax highlighting
set updatetime=300                     " Default 4000ms = 4s
set encoding=utf8
set smarttab                           " Be smart when using tabs ;)
set expandtab                          " Replace tabs with spaces
set shiftwidth=2                       " 1 tab == 2 spaces
set tabstop=2                          " 1 tab == 2 spaces
set clipboard=unnamedplus              " send yanks to clipboard
set showcmd                            " Show partial commands in the last line of the screen
set number                             " Set both types of NUmbering to get hybrid Relative NUmbering"
set relativenumber
set title                              " Set the terminal title
set ruler                              " Display the cursor position
" set cursorline                         " Highlight current line to find the cursor more easily
" set cursorcolumn                       " Highlight current column to find the cursor more easily
set laststatus=2                       " Always display the status line, even if only one window is displayed
set cmdheight=2                        " Set the command window height to 2 lines to avoid press <Enter> to continue"
" set list                               " Show newlines and tabs
" set listchars=tab:▸\ ,eol:¬            " Use the same symbols as TextMate for tabstops and EOLs
set incsearch                          " Find the next match as we type the search
set ignorecase                         " Ignore case when searching...
set smartcase                          " ...unless we type a capital
set history=1000                       " Remember more commands and search history
set undolevels=1000                    " Use many muchos levels of undo
set mouse=a                            " Enable use of the mouse for all modes
" set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings
set completeopt=longest,menuone,noselect,noinsert,preview " show popup menu when at least one match but don't insert stuff
set complete=.,w,b,u,t,kspell        " Check file -> window -> buffer -> hidden buffers -> tags -> spelling if enabled
set omnifunc=syntaxcomplete#Complete " On <c-x><c-o> use the file syntax to guess possible completions
set autoread                           " Reload files changed outside vim
set lazyredraw                         " Don't redraw while executing macros (good performance setting)
set linebreak                          " Stop annoying 80 chars line wrapping
set scrolloff=4                        " Leave some space above and below the cursor while scrolling
set signcolumn=yes                     " Show the gutter for git info, errors...

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path=.,,,**

" Open new split panes to right and bottom, which feels more natural than Vim’s default
set splitbelow
set splitright

" Wildmenu
if has("wildmenu")
    set wildignore+=*.a,*.o
    set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png
    set wildignore+=.DS_Store,.git,.hg,.svn
    set wildignore+=*~,*.swp,*.tmp
    set wildignore+=*/node_modules/*
    set wildmenu
    set wildmode=longest,list,full
endif

if executable("rg")
    set grepprg=rg\ --vimgrep\ --no-heading
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" set autochdir   " change path to current file, NOTE: SOME PLUGINS MIGHT NOT WORK WITH THIS ON!!!!!

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

let g:python3_host_prog="~/miniconda3/envs/neovim3/bin/python"
let g:python_host_prog="~/miniconda3/envs/neovim2/bin/python"

" }}}
" ============================================================================
" Mappings {{{
" ============================================================================

" https://salferrarello.com/vim-close-all-buffers-except-the-current-one/
command! Bonly execute '%bdelete|edit #|normal `"'


" ======================
" FREQUENTLY USED LEADER
" ======================
" Use capital W as a shortcut to save and quit
" nnoremap W :w<CR>
" nnoremap Q :q<CR>
" except... it prevents me to move by full words, let's try the Ctrl combo instead
" nnoremap <C-w> :w<CR>
" Sounded good except that now I have this musclememory <C-w> = Save
" Guess what? I keep closing tabs in firefox >_>
" Let's try using leader instead, obviously <Leader>w is already used by Vimwiki...
" Maybe... s as in Save?
nnoremap <Leader>s :w<CR>
nnoremap <Leader>q :q<CR>
" Vim's (d)elete is more like a cut.
" use leader d to really delete something, i.e. cut to blackhole register _
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
" easily close buffer (used constantly)
" nnoremap <leader>- :bd<Cr>
" use vim-buffkill's BD to preserve splits
nnoremap <leader>- :BD<Cr>

" ===================
" INFREQUENT MAPPINGS (use double leader)
" ===================
nnoremap <leader><leader>a <C-^>

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors)
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn

" open current file at current position in visual studio code, the double
" getpos is ugly as fuck but... na mindegy
nnoremap <silent> <leader><leader>vs :exec '! code --goto ' . expand('%:p') . ':' . getpos('.')[1] . ':' . getpos('.')[2]<CR>

" Easier split navigation
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>h <C-W><C-H>

" Use capital letters to create splits
nnoremap <leader>J :rightbelow sp<CR>
nnoremap <leader>K :aboveleft sp<CR>
nnoremap <leader>H :leftabove vsp<CR>
nnoremap <leader>L :rightbelow vsp<CR>

" DISABLE FUCKING EXMODE UNTIL I FIND A BETTER USE FOR Q
nmap Q <Nop>

" Remap VIM 0 to first non-blank character
map 0 ^

" }}}
" ============================================================================
" Custom colors {{{
" ============================================================================
" At the bottom to override themes and shit

" from https://github.com/junegunn/goyo.vim/issues/84#issuecomment-156299446
function s:PatchColors()
  " make the current word highlighting less of a punch in the eye
  hi CurrentWord ctermbg=236
  hi CurrentWordTwins ctermbg=236
  " Give VimWiki links a nice light blue colors
  hi VimwikiLink ctermfg=39 cterm=underline
  " Use terminal background color to customize (no more trying to match both
  " because of vim's uneven borders)
  " hi Normal guibg=NONE ctermbg=NONE
  " Hide the annoying ~ at the end of files
  hi EndOfBuffer ctermfg=bg ctermbg=bg
endfunction

autocmd! ColorScheme onedark call s:PatchColors()
colorscheme onedark
set background=dark " Because dark is cool
