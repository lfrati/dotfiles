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

Plug 'terryma/vim-multiple-cursors'
  let g:multiple_cursors_support_imap = 0
  let g:multi_cursor_exit_from_visual_mode = 1
  let g:multi_cursor_exit_from_insert_mode = 1

Plug 'airblade/vim-gitgutter'
  let g:gitgutter_map_keys = 0 
  function! GitChunks()
    let [a,m,r] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', a, m, r)
  endfunction

Plug 'fisadev/vim-isort'
  let g:vim_isort_python_version = 'python3'
  let g:vim_isort_map = ''

" Plug 'dense-analysis/ale'
"   " let g:ale_fixers = {'python': ['isort']}
"   " let g:ale_fix_on_save = 1
"   let g:ale_linters = {'python':['flake8']}

" Python specific bindings from https://stackoverflow.com/a/54108005
augroup pybindings
  autocmd! pybindings
  autocmd Filetype python nmap <buffer> <silent> <leader>isort :Isort<CR>
augroup end

Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " TextEdit might fail if hidden is not set.
  set hidden
  " Some servers have issues with backup files, see #649.
  set nobackup
  set nowritebackup
  " Give more space for displaying messages.
  set cmdheight=2
  " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
  " delays and poor user experience.
  set updatetime=300
  " Don't pass messages to |ins-completion-menu|.
  set shortmess+=c
  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  set signcolumn=yes
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  " Use K to show documentation in preview window.
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  " GoTo code navigation.
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gtd <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nnoremap <silent> K :call <SID>show_documentation()<CR>
  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

Plug 'dominikduda/vim_current_word' " highlight current word and other occurrences
  hi CurrentWord ctermbg=236
  hi CurrentWordTwins ctermbg=237

" Very well made python aware plugin, I'm using it for semantig highlight
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
  function MyCustomSemshiHighlights()
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
      " hi semshiSelected        ctermfg=231  ctermbg=161
      hi semshiSelected        ctermfg=161  cterm=underline
      hi semshiErrorSign       ctermfg=231  ctermbg=160
      hi semshiErrorChar       ctermfg=231  ctermbg=160
      sign define semshiError text=E> texthl=semshiErrorSign
  endfunction
  autocmd FileType python call MyCustomSemshiHighlights()
  autocmd ColorScheme * call MyCustomSemshiHighlights()

" Editing
Plug 'tpope/vim-surround'            " cs surrounding capabilities eg. cs)], csw'
Plug 'christoomey/vim-system-copy'   " cp/cv for copy paste e.g. cvi = paste inside '
Plug 'junegunn/vim-easy-align'       " sounds super cool, never used so far
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)

Plug 'sbdchd/vim-shebang'            " automatically add #! stuff to files
  let g:shebang#shebangs = {
              \ 'julia': '#!/usr/bin/env julia',
              \ 'sh': '#!/usr/bin/env bash',
              \ 'python': '#!/usr/bin/env python',
              \ 'R': '#!/usr/bin/env Rscript'
              \}

Plug 'tpope/vim-commentary'          " gc code away
Plug 'tmhedberg/SimpylFold'          " Better Python folding
  let g:SimpylFold_docstring_preview=1
  set foldmethod=indent
  set foldlevel=99

Plug 'Konfekt/FastFold'              " Suggested by SimplyFold to improve speed

" Tags management
Plug 'universal-ctags/ctags'
Plug 'ludovicchabant/vim-gutentags'
  " Do not pollute projects with tag files, keep them all in one place.
  let g:gutentags_cache_dir = '~/.tags_dir'

Plug 'majutsushi/tagbar'
  let g:tagbar_autofocus = 1
  nmap <F6> :TagbarToggle<CR>

" Organization
Plug 'vimwiki/vimwiki', {'branch' : 'dev'}
  augroup vimwikicmds
      " the second autocmd is executed only for matching filetypes
      autocmd FileType vimwiki
          \ autocmd InsertLeave <buffer> :update
  augroup end
  let $VIMWIKI_DIR = $HOME . "/Dropbox/vimwiki"
  function! s:QuickNote ()
    py import uuid
    let l:id = pyeval('str(uuid.uuid4())[24:]')
    let l:path = $VIMWIKI_DIR . "/note.". l:id . ".md"
    execute "e " . l:path
    execute "normal! inote\<C-R>=UltiSnips#ExpandSnippet()\<CR>"
  endfunction
  let g:vimwiki_folding='expr'
  let g:vimwiki_table_mappings=0 " Prevent conflict with UltiSnips tab completion
  let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/',
                        \ 'syntax': 'markdown',
                        \ 'ext': '.md',
                        \ 'auto_tags': 1,
                        \ 'auto_diary_index': 1,
                        \ 'custom_wiki2html': '/home/lapo/dotfiles/neovim/wiki2html.sh'}]
  let g:tagbar_type_vimwiki = {
            \   'ctagstype':'vimwiki'
            \ , 'kinds':['h:header']
            \ , 'sro':'&&&'
            \ , 'kind2scope':{'h':'header'}
            \ , 'sort':0
            \ , 'ctagsbin':'/home/lapo/dotfiles/neovim/vwtags.py'
            \ , 'ctagsargs': 'markdown'
            \ }
  nmap <leader>no :call <SID>QuickNote()<CR>

Plug 'itchyny/calendar.vim'

Plug 'ryanoasis/vim-devicons'       " DevIcons for some plugins

Plug 'joshdick/onedark.vim'         " atom inpspired true color theme
Plug 'ap/vim-buftabline'            " Show open buffers
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

Plug 'itchyny/lightline.vim'        " lightweight status line
    let g:lightline = {
        \ 'colorscheme': 'onedark',
        \ 'active': {
        \   'left': [ 
        \             [ 'mode', 'paste','readonly','gitbranch','gitchunks','sync','modified'],
        \             [ 'cocstatus' ] 
        \           ],
        \   'right': [ 
        \              [ 'lineinfo' ],
        \              [ 'fileformat','fileencoding','filetype' ],
        \              [  'filename' ] 
        \            ]
        \ },
        \ 'component_function': {
        \   'gitbranch': 'GitStatus',
        \   'filename': 'LightlineFilename',
        \   'sync': 'SyncFlag',
        \   'cocstatus': 'coc#status'
        \ },
        \ 'component_type':{
        \   'modified' : 'error'
        \ },
        \ 'component_expand':{
        \   'modified' : 'ModifiedFlag'
        \ }
        \ }
  " Component expand is called only once every time the statusline is updated
  " To make our red modfied symbol work we update the statusline every time
  " there is a change. More info about the events in :help TextChanged
  augroup change_triggers
    autocmd!
    autocmd TextChanged,TextChangedI * call lightline#update()
  augroup END
  function! ModifiedFlag()
    " custom function that checks if the buffer has been modified
    return &modifiable && &modified ? '+' : ''
	endfunction
  function! SyncFlag()
    "check if the window has the scrollbind flag set
    return &scb == 0 ? '' : 'Syncd'  
  endfunction
  " scb has to be called on all the windows that we want to scrollbind
  function! GitStatus()
    " check the branch name and display it with a fancy symbol
    let l:head = FugitiveHead()
    if l:head == ''
      return ' - '
    else
      return ' ' . l:head . ' ' . GitChunks()
  endfunction
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
  function SetupLightlineColors() abort
    " transparent background in statusbar
    let l:palette = lightline#palette()
                                       "guibg,    guifg,   ctermbg, ctermfg"
    let l:palette.normal.middle = [ [ '#ABB2BF', '#282C34', '235', '174' ] ]
    " let l:palette.normal.middle = [ [ '#ABB2BF', '#282C34', '145', '235' ] ]
    let l:palette.inactive.middle = [ [ '#ABB2BF', '#282C34', '145', '146' ] ]
    " let l:palette.tabline.middle = l:palette.normal.middle
    call lightline#colorscheme()
  endfunction
  autocmd! VimEnter * call SetupLightlineColors()
  nmap <leader>sy :windo set scb!<CR>

" Zen mode
Plug 'junegunn/goyo.vim'
  function! s:goyo_enter()
    " keep the text in the middle of the page while in goyo
    set showtabline=0
    set noshowmode
    set noshowcmd
    Limelight
  endfunction
  function! s:goyo_leave()
    set showtabline=2
    set showmode
    set showcmd
    :call buftabline#update(0)
    Limelight!
  endfunction
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
  " autocmd! User GoyoEnter Limelight
  " autocmd! User GoyoLeave Limelight!
  nnoremap <leader>go :Goyo<CR>

" highlight the area where writing and fade out the rest
Plug 'junegunn/limelight.vim'
  let g:limelight_conceal_ctermfg = 237

" fuzzy finding for the win
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'junegunn/fzf.vim'
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
  " Offload interactive search to Rg, use FzF only as a wrapper around it, also add preview
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
    " Adapted from https://github.com/junegunn/fzf.vim#example-advanced-rg-command
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let path = GitAwarePath()
    echo path
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command],'dir':path}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction
  command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0) " Use RipGrep to search inside files
  " When fzf starts in a terminal buffer, the file type of the buffer is set to fzf. So you can set up FileType fzf autocmd to
  " customize the settings of the window.For example, if you use the default layout ({'down': '~40%'}) on Neovim, you might
  " want to temporarily disable the statusline for a cleaner look.
  if has('nvim') && !exists('g:fzf_layout')
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  endif
  nnoremap <leader>f :Files<CR>
  nnoremap <leader>rg :Rg<CR>
  nnoremap <leader>rw :Rg <C-R><C-W><CR>

Plug 'tpope/vim-fugitive'        " For git-awareness (used by fzf commands)

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

Plug 'scrooloose/nerdtree'       " better netrw vim navigation
  silent! nmap <F7> :NERDTreeToggle<CR>

" Nicer syntax highlight in NERDTree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'mbbill/undotree'           " More easily navigate vim's poweful undo tree
  if has("persistent_undo")
      set undodir=~/.local/share/nvim/undodir//
      set undofile
      set backupdir=~/.local/share/nvim/backupdir// " Don't put backups in current dir
      set backup
      set directory=~/.local/share/nvim/swapdir//
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

Plug 'tpope/vim-repeat'          " Allows repeating some plugins operations using .
Plug 'kassio/neoterm'            " easier terminal management in vim
  let g:neoterm_direct_open_repl=1
  let g:neoterm_repl_python='/home/lapo/miniconda3/envs/deep/bin/ipython --no-autoindent --pylab'
  let g:neoterm_default_mod=':vertical'
  let g:neoterm_size=80
  let g:neoterm_autoscroll=1
  " My own functions to try to run python code in an ipython terminal
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

Plug 'SirVer/ultisnips'          " custom snippets
  " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
  let g:UltiSnipsExpandTrigger="<C-u>"
  let g:UltiSnipsJumpForwardTrigger="<Down>"
  let g:UltiSnipsJumpBackwardTrigger="<Up>"
  let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/neovim/UltiSnips']

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" }}}
" ============================================================================
" UI Layout {{{
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
colorscheme onedark

" }}}
" ============================================================================
" Basic settings {{{
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
set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings
set completeopt=longest,menuone,noselect,noinsert,preview " show popup menu when at least one match but don't insert stuff
set complete=.,w,b,u,t,kspell        " Check file -> window -> buffer -> hidden buffers -> tags -> spelling if enabled
set omnifunc=syntaxcomplete#Complete " On <c-x><c-o> use the file syntax to guess possible completions
set autoread                           " Reload files changed outside vim
set lazyredraw                         " Don't redraw while executing macros (good performance setting)
set linebreak                          " Stop annoying 80 chars line wrapping
set textwidth=500                      "
set scrolloff=4

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

let g:python3_host_prog="/home/lapo/miniconda3/envs/neovim3/bin/python"
let g:python_host_prog="/home/lapo/miniconda3/envs/neovim2/bin/python"

" Allows you to save files you opened without write permissions via sudo
" cmap w!! w !sudo tee %

" }}}
" ============================================================================
" Mappings {{{
" ============================================================================

" easily open and source neovim config file
nmap <leader>conf :e $MYVIMRC<CR>

" execute current line in shell and paste results under it
" nmap <leader>e :exec 'r!'.getline('..')<CR>
" execute current line in shell and paste results above it
nmap <leader>ex !!bash<CR>

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

function! EchoWarning(msg)
  echohl WarningMsg
  echo  a:msg
  echohl None
endfunction

augroup vimrccmds     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC nested so % | call EchoWarning("Reloaded " . $MYVIMRC) | redraw
    autocmd! BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
augroup END

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Better navigation of long lines, when wrapping and pressing up/down
" you might want to that part of the line, not the line above
" http://bit-101.com/techtips/2018/02/23/Better-cursor-movement-in-vim/
nnoremap j gj
nnoremap k gk

" Use capital W as a shortcut to save and quit
" nnoremap W :w<CR>
" nnoremap Q :q<CR>
" except... it prevents me to move by full words, let's try the Ctrl combo instead
nnoremap <C-w> :w<CR>
nnoremap <C-Q> :q<CR>

" center current line after jumping to prev/next locations
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" DISABLE FUCKING EXMODE UNTIL I FIND A BETTER USE FOR Q
nmap Q <Nop>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Remap VIM 0 to first non-blank character
map 0 ^

" Take quick notes, with = so that is close to buffer close
map <leader>= :e ~/buffer.md<CR>

" }}}
" ============================================================================
" Custom colors {{{
" ============================================================================
" At the bottom to override themes and shit

hi CurrentWord ctermbg=236
hi VimwikiLink ctermfg=39 cterm=underline
" Use terminal background color to customize (no more trying to match both
" because of vim's uneven borders)
hi Normal guibg=NONE ctermbg=NONE

" }}}
" ============================================================================
" Experimental {{{
" ============================================================================

" Nice and minimal but for some reason never completes what I want it to...
" Plug 'ajh17/VimCompletesMe'
" Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" from https://github.com/amix/vimrc/blob/46195e4ca4d732b9e0c0cac1602f19fe1f5e9ea4/vimrcs/extended.vim#L57
" => Command mode related
" Smart mappings on the command line
" cno $h e ~/
" cno $d e ~/Desktop/
" cno $j e ./
" cno $c e <C-\>eCurrentFileDir("e")<cr>

" " $q is super useful when browsing on the command line
" " it deletes everything until the last slash
" cno $q <C-\>eDeleteTillSlash()<cr>

" " Bash like keys for the command line
" cnoremap <C-A>		<Home>
" cnoremap <C-E>		<End>
" cnoremap <C-K>		<C-U>

" cnoremap <C-P> <Up>
" cnoremap <C-N> <Down>

" from https://github.com/amix/vimrc/blob/46195e4ca4d732b9e0c0cac1602f19fe1f5e9ea4/vimrcs/basic.vim#L256
" Return to last edit position when opening files (You want this!)
" au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" }}}
" ============================================================================
