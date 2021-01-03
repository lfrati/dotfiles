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

let g:MY_VIMWIKIDIR = $HOME . "/Dropbox/vimwiki"
" let g:ruby_host_prog = '/home/lapo/.gem/ruby/2.7.0/bin/neovim-ruby-host'

" }}}
" ============================================================================
" Plugins {{{
" ============================================================================

" needed by various plugins
set nocompatible
filetype plugin on
syntax on

call plug#begin('~/.vim/plugged')

" needed because of https://github.com/neovim/neovim/issues/1496
Plug 'lambdalisue/suda.vim'

Plug 'ap/vim-css-color'

Plug 'qpkorr/vim-bufkill'

" Too much power, my computer is not ready yet! ... (requires nigthly build)
" Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

Plug 'mhinz/vim-startify'
 let g:startify_bookmarks = [
       \ {'v': g:MY_VIMWIKIDIR . '/index.md' },
       \ {'c': $MYVIMRC },
       \ ]
 let g:startify_padding_left = 3

Plug 'tpope/vim-unimpaired'

Plug 'ajh17/VimCompletesMe'

Plug 'JuliaEditorSupport/julia-vim'

" Suggested by vim-markdown
Plug 'godlygeek/tabular'

Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1

Plug 'airblade/vim-gitgutter'
  let g:gitgutter_map_keys = 0
  function! GitChunks()
    let [a,m,r] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', a, m, r)
  endfunction

" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  nmap <Leader>p <Nop>
  augroup prettiercmds
    autocmd! prettiercmds
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
  augroup end

Plug 'fisadev/vim-isort'
  let g:vim_isort_config_overrides = {'multi_line_output': 3}

Plug 'psf/black', { 'branch': 'stable' }
function! s:SafeFormat()
  " because of fucking course isort conflicts with black and ends up resetting
  " the cursor to the top. (I had commented an import and black wants spaces
  " while isort doesn't, so isort would format them, bringing the cursor to
  " the beginning every time I saved, then black would put the space back)
  " Appartently is a known bug? https://github.com/fisadev/vim-isort/issues/15
  let s:pos = getpos( '. ')
  let s:view = winsaveview()
  execute ':Isort'
  execute ':Black'
  call setpos( '.', s:pos )
  call winrestview( s:view )
endfunc
augroup pycmds
  autocmd! pycmds
  " autocmd BufWritePre *.py execute ':Isort'
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

Plug 'jeetsukumaran/vim-pythonsense'
  " class OneRing(object):             -----------------------------+
  "                                    --------------------+        |
  "     def __init__(self):                                |        |
  "         print("One ring to ...")                       |        |
  "                                                        |        |
  "     def rule_them_all(self):                           |        |
  "         self.find_them()                               |        |
  "                                                        |        |
  "     def find_them(self):           ------------+       |        |
  "         a = [3, 7, 9, 1]           ----+       |       |        |
  "         self.bring_them(a)             |- `if` |- `af` |- `ic`  | - `ac`
  "         self.bind_them("darkness") ----+       |       |        |
  "                                    ------------+       |        |
  "     def bring_them_all(self, a):                       |        |
  "         self.bind_them(a, "#000")                      |        |
  "                                                        |        |
  "     def bind_them(self, a, c):                         |        |
  "         print("shadows lie.")      --------------------+        |
  "                                    -----------------------------+
  let g:is_pythonsense_suppress_motion_keymaps = 1

Plug 'jpalardy/vim-slime'
  let g:slime_target = "tmux"
  let g:slime_paste_file = tempname()
  let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}
  let g:slime_dont_ask_default = 1
  let g:slime_python_ipython = 1
  let g:slime_no_mappings = 1
  let g:slime_cell_delimiter='#%%'
  function! IpythonLoad()
    let filename = expand("%:p")
    exec 'SlimeSend1 %load ' . filename
    " because of course when you load a script ipython waits patiently for you
    " to press enter before actually executing it
    exec 'SlimeSend1 "Script ' . filename . ' loaded."'
  endfunction
  function! RegionHandler()
    call slime#send_cell()
    call search(g:slime_cell_delimiter, 'W')
    execute 'normal! zz'
  endfunction
  augroup slimecmds
    autocmd! slimecmds
    autocmd FileType python xmap <leader><leader>p <Plug>SlimeRegionSend
    autocmd FileType python nmap <leader><leader>p <Plug>SlimeParagraphSend
    autocmd FileType python nmap <leader><leader>r :call RegionHandler()<CR>
    " autocmd FileType python nmap <leader><leader>r <Plug>SlimeSendCell
    " autocmd FileType python nmap <leader><leader>r :SlimeSend1 %reset -f<CR>
    " autocmd FileType python nmap <leader><leader>f :call IpythonLoad()<CR>
  augroup END

" God this plugin is good. Live rendering, cursor syncing
" Makes previewing my vimkikis hella easy
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for':['markdown','vimwiki'] }
  " nmap <leader>md <Plug>MarkdownPreviewToggle
  nmap <leader>m <Plug>MarkdownPreviewToggle

" ---------------------------------------------------------------
" My zettelkasten for life?
Plug 'vimwiki/vimwiki', {'branch' : 'dev'}

" The third component of the holy trinity of plugins
" (fzf + vimwiki + easymotion)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'junegunn/fzf.vim'
  source ~/dotfiles/neovim/zettle.vim
" ---------------------------------------------------------------

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
      \             [ 'mode', 'paste','readonly','coc_warning','coc_error'],
      \             [ 'cocstatus','mymodified' ],
      \             [ 'absolutepath' ]
      \           ],
      \   'right': [
      \              [ 'gitbranch','lineinfo' ],
      \              [ 'sync' ]
      \            ]
      \ },
      \ 'inactive': {
      \ 'left': [ [ 'filename'],[ 'sync' ] ],
      \ 'right': [ ['modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'GitStatus',
      \   'filename': 'LightlineFilename',
      \   'sync': 'SyncFlag',
      \   'cocstatus': 'CocStatusMsg'
      \ },
      \ 'component_expand':{
      \   'mymodified' : 'ModifiedFlag',
      \   'coc_error' : 'LightlineCocErrors',
      \   'coc_warning' : 'LightlineCocWarnings',
      \ },
      \ 'component_type':{
      \   'mymodified' : 'error',
      \   'coc_error' : 'error',
      \   'coc_warning' : 'warning',
      \ }
      \ }
  " Component expand is called only once every time the statusline is updated
  " To make our red modfied symbol work we update the statusline every time
  " there is a change. More info about the events in :help TextChanged
  augroup change_triggers
    autocmd! change_triggers
    autocmd TextChanged,TextChangedI,BufWritePost,BufEnter * call lightline#update()
    " update the file whenever I switch to a new buffer or get back to nvim
    autocmd FocusGained * checktime
    autocmd BufEnter * checktime
  augroup END
  function! ModifiedFlag()
    " for some reason it doesn't work with inactive buffers since it always shows
    " the value of the active one.
    return &modifiable && &modified ? '[+]' : ''
	endfunction
  function! SyncFlag()
    "check if the window has the scrollbind flag set
    return &scb == 0 ? '' : 'Syncd'
   " scb has to be called on all the windows that we want to scrollbind
  endfunction
  function! GitStatus()
    " check the branch name and display it with a fancy symbol
    let l:head = FugitiveHead()
    if l:head == ''
      " return ' - '
      return ''
    else
      " return ' ' . l:head . ' ' . GitChunks()
      return ' ' . l:head
    endif
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
  function! SetupLightlineColors() abort
    " transparent background in statusbar
    let l:palette = lightline#palette()
                                       "guibg,    guifg,   ctermbg, ctermfg"
    let l:palette.normal.middle = [ [ '#ABB2BF', '#282C34', '235', '174' ] ]
    " let l:palette.normal.middle = [ [ '#ABB2BF', '#282C34', '145', '235' ] ]
    let l:palette.inactive.middle = [ [ '#ABB2BF', '#282C34', '145', '146' ] ]
    let l:palette.inactive.right = [ [ '#ABB2BF', '#282C34', '235', '204' ] ]
    " let l:palette.tabline.middle = l:palette.normal.middle
    call lightline#colorscheme()
  endfunction
  autocmd! VimEnter * call SetupLightlineColors()
  " nmap <leader>bind :windo set scb!<CR>
  command! Bind :windo set scb!

" Zen mode
Plug 'junegunn/goyo.vim'
  function! s:goyo_enter()
    set noshowmode
    set noshowcmd
    set scrolloff=999
    " Limelight
  endfunction
  function! s:goyo_leave()
    set showmode
    set showcmd
    set scrolloff=4
    " :call buftabline#update(0) not needed since I don't use buftabline
    " Limelight!
  endfunction
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
  " nnoremap <leader>go :Goyo<CR>

" highlight the area where writing and fade out the rest
Plug 'junegunn/limelight.vim'
  let g:limelight_conceal_ctermfg = 237

Plug 'tpope/vim-fugitive'        " For git-awareness (used by fzf commands)
  " nmap <leader>gs :G<CR>
  " " MERGING get from right side (j is on the right)
  " nmap <leader>gj :diffget //3<CR>
  " " MERGING get from left side (f is on the left)
  " nmap <leader>gf :diffget //2<CR>
  " NOT WORKING
  " function FugitiveBack()
  "   if exists("b:fugitive_type") && b:fugitive_type =~# '^\%(tree\|blob\)$'
  "       echo b:fugitive_type
  "       edit %:h<CR>
  "   else
  "     echo "No fugitive_type"
  "   endif
  " endfunction
  " autocmd! BufEnter fugitive://* nnoremap <buffer> <BS> :call FugitiveBack()<CR>


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

Plug 'haya14busa/vim-easyoperator-line'
  let g:EasyOperator_line_do_mapping = 0
  nmap <leader><Leader>ld <Plug>(easyoperator-line-delete)
  nmap <leader><Leader>lp <Plug>(easyoperator-line-yank)

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

Plug 'dominikduda/vim_current_word' " highlight current word and other occurrences
  " Color customizations are at the end of the file
  " hi CurrentWord ctermbg=236
  " hi CurrentWordTwins ctermbg=237

Plug 'tpope/vim-surround'
  " cs surrounding capabilities eg. cs)]
  " 'Hello world'  -> cs']  -> [Hello  world]
  " 'Hello world'  -> ds'   ->  Hello  world
  "  H(e)llo world -> ysiw' -> 'Hello' world
  "  H(e)llo world -> csw'  -> 'Hello' world  # bug or intended?
  "yss" works on a line"

Plug 'christoomey/vim-system-copy'   " cp/cv for copy paste e.g. cvi = paste inside '

Plug 'tpope/vim-commentary'          " gc code away

Plug 'universal-ctags/ctags'         " Tags management

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
set foldlevel=99                       " Unfold folds by default, don't use nofoldenable, for some reason the foldlevel gets messed up
" Foldlevel=99 means I have to zr 98 times before folding a second level fold
" with the following autocmd I set the foldlevel value to the max fold level
" in the file, -> the first zr folds the deepest level and so on
function! FindFoldLevel()
  return max(map(range(1, line('$')), 'foldlevel(v:val)'))
endfunction
" I'm not crazy, I swear for some reason folding didn't work properly
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "="
endfunction
autocmd BufReadPost *.md setlocal foldexpr=MarkdownLevel()
autocmd BufReadPost *.md setlocal foldmethod=expr
autocmd BufReadPost *.md let &foldlevel = FindFoldLevel()

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
" Utilities {{{
" ============================================================================

function! AllMatches(text,pattern)
  let matches = []
  let cursor = 0
  let safety = 0
  let [matched,startpos,endpos] = matchstrpos(a:text,a:pattern,cursor)
  while matched != ""
    call add(matches, matched)
    let cursor = endpos
    let [matched,startpos,endpos] = matchstrpos(a:text,a:pattern,cursor)
    let safety += 1
    if safety > 10000
      break
    endif
  endwhile
  return matches
endfunction
function! UniqList(list)
  " return a list that contains only unique strings
  let dict = {}
  for l in a:list
     let l:dict[l] = ''
  endfor
  let uniqueList = keys(l:dict)
  return uniqueList
endfunction
" function! ChangeWordUnderCursor(from, to)
"   let pos = GetUnderCursor(a:from)
"   call s:ReplaceCoords(a:to, pos)
" endfunction
function! GetUnderCursor(pattern)
" Return the match under the cursor. Yeah, it's a pain
  let col = col('.') - 1
  let line = getline('.')
  let found = ''
  let ebeg = -1
  let elen = 0
  " match( ..., 0) return col of first match
  let cont = match(line, a:pattern, 0)
  " search until the cursor is within the match
  while (ebeg >= 0 || (0 <= cont) && (cont <= col))
    let contn = matchend(line, a:pattern, cont)
    if (cont <= col) && (col < contn)
      let ebeg = match(line, a:pattern, cont)
      let elen = contn - ebeg
      let found = strpart(line, ebeg, elen)
      break
    else
      let cont = match(line, a:pattern, contn)
      let found = ''
    endif
  endwh
  return {'match' : found, 'start' : ebeg, 'len' : elen}
endfunction
function! ReplaceCoords(insert, pos)
" Replaces the text between pos.start and pos.start + pos.len with insert
  if a:pos.start >= 0
    let line = getline('.')
    let from = a:pos.start
    let to = a:pos.start + a:pos.len
    let newline = strpart(line, 0, from).a:insert.strpart(line, to)
    call setline(line('.'), newline)
  endif
endfunction
function! s:GetVisualSelection()
  " I think you can guess what this one does
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
      return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction
function! QuickfixNames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(values(buffer_numbers))
endfunction

" }}}
" ============================================================================
" Mappings {{{
" ============================================================================

" https://salferrarello.com/vim-close-all-buffers-except-the-current-one/
command! Bonly execute '%bdelete|edit #|normal `"'

" http://vimcasts.org/episodes/project-wide-find-and-replace/
command! -nargs=0 -bar Qargs execute 'args ' . QuickfixNames()

" function! s:QuickGetLine(off)
"   " easily move lines to line below cursor
"   echoerr "BUGGED"
"   return
"   let matches = matchlist(a:off,'\([0-9]\+\)\([jk]\)')
"   redraw
"   if len(matches) > 0
"     let nlines = str2nr(matches[1])
"     let dir = matches[2]
"     if dir == 'k' " k means get from above
"      let nlines = -nlines
"     endif
"     let l:start = line('.')
"     let l:line = getline(l:start + l:nlines)
"     " Insert that line below the cursor
"     put =l:line
"   endif
" endfunction
" nnoremap <leader>r :call <SID>QuickGetLine(input(''))<CR>


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
" easily open and source neovim config file
" nnoremap <leader>conf :e $MYVIMRC<CR>
nnoremap <leader>c :e $MYVIMRC<CR>
" Vim's (d)elete is more like a cut.
" use leader d to really delete something, i.e. cut to blackhole register _
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP
" nnoremap <leader>d :put =strftime('%Y-%m-%d')<CR>
" Switch CWD to the directory of the open buffer
nnoremap <leader><leader>cd :cd %:p:h<cr>:pwd<cr>
" Take quick notes, with = so that is close to buffer close
function! s:ToggleScratchpad()
  let l:file = expand("%:t")
  if l:file ==? "buffer.md"
    bd
  else
    execute "e " . g:MY_VIMWIKIDIR . "/buffer.md"
  endif
endfunction
nnoremap <leader>= :call <SID>ToggleScratchpad()<CR>
" easily close buffer (used constantly)
" nnoremap <leader>- :bd<Cr>
" use vim-buffkill's BD to preserve splits
nnoremap <leader>- :BD<Cr>

" ===================
" INFREQUENT MAPPINGS (use double leader)
" ===================
" insert date
nnoremap <leader><leader>d :execute "normal! i" . strftime('%Y-%m-%d')<CR>
" execute current line in shell and paste results under it
" nmap <leader>e :exec 'r!'.getline('..')<CR>
" execute current line in shell and paste results above it
nnoremap <leader><leader>ex !!bash<CR>
" alternate between current file and alternate file
nnoremap <leader><leader>a <C-^>
" Dictionary (l)ookup
" nnoremap <leader>l :execute "!xdg-open https://www.merriam-webster.com/dictionary/" . expand('<cword>')<CR>
nnoremap <leader><leader>l :execute "!xdg-open \"https://www.dictionary.com/browse/" . expand('<cword>') . "?s=t\""<CR>

" nnoremap <leader>wc :echo wordcount()["words"]<CR>
" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors)
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn

" open current file at current position in visual studio code, the double
" getpos is ugly as fuck but... na mindegy
nnoremap <silent> <leader><leader>vs :exec '! code --goto ' . expand('%:p') . ':' . getpos('.')[1] . ':' . getpos('.')[2]<CR>

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
    autocmd! vimrccmds
    autocmd BufWritePost $MYVIMRC nested so % | call EchoWarning("Reloaded " . $MYVIMRC) | redraw
    autocmd FileType c,cpp,java,php,python,json,vim autocmd BufWritePre <buffer> :call CleanExtraSpaces()
augroup END

" 2020-09-14 : doesn't work in neovim yet https://github.com/neovim/neovim/issues/12330
" Allows you to save files you opened without write permissions via sudo
" cmap w!! w !sudo tee %

nnoremap <leader><leader>\ :vsp<CR>
nnoremap <leader><leader>- :sp<CR>
nnoremap <leader><leader>i :9000vsp<CR>

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

" Better navigation of long lines, when wrapping and pressing up/down
" you might want to that part of the line, not the line above
" http://bit-101.com/techtips/2018/02/23/Better-cursor-movement-in-vim/
" Disable because it fucks with jumps, 3j doesn't consider wrapping so moving
" around becomes pretty tricky (3j will move you to different spots depending
" on how much wrapping there is)
" nnoremap j gj
" nnoremap k gk

" center current line after jumping to prev/next locations
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" DISABLE FUCKING EXMODE UNTIL I FIND A BETTER USE FOR Q
nmap Q <Nop>

" Remap VIM 0 to first non-blank character
map 0 ^

" Hopefully more intuitive folding navigation
" WARNING: OVERRIDES f (find) mapping, but I never use it on its own e.g. fl vs dfl
" When looking at a closed fold down (j) opens it, like pulling down a menu
nnoremap fj zo
" Similarly (k) pushes it back up -> closed
nnoremap fk zc
" Since j/k open close individual folds, left/right i.e. h/l toggle all folds
" at once
nnoremap fl zR
nnoremap fh zM
" I still want to increase/decrease all levels by 1, so I'll use o as in open
" and i as in... being next to it ;P
nnoremap fo zr
nnoremap fi zm

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

" }}}
" ============================================================================
" Plugin Graveyard {{{
" ============================================================================

" Plug 'scrooloose/nerdtree'       " better netrw vim navigation
"   silent! nmap <F7> :NERDTreeToggle<CR>

" " Nicer syntax highlight in NERDTree
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Plug 'Xuyuanp/nerdtree-git-plugin'

" Plug 'kassio/neoterm'            " easier terminal management in vim
"   let g:neoterm_direct_open_repl=1
"   let g:neoterm_repl_python='/home/lapo/miniconda3/envs/deep/bin/ipython --no-autoindent --pylab'
"   let g:neoterm_default_mod=':vertical'
"   let g:neoterm_size=80
"   let g:neoterm_autoscroll=1
"   " My own functions to try to run python code in an ipython terminal
"   function! IPythonLoadCurrentFile()
"     " Get absolute path of current file
"     let path = expand('%:p')
"     " Send ipython magic to load current file, . does string concatenation
"     execute "T %load " . path
"     " I have no idea how to send the final newline, I'll use another magic as a
"     " hack, people like seeing time and shit anyways.
"     execute "T %time"
"   endfunction
"   function! IPythonLoadCurrentLine()
"     " yank current line to clipboard
"     normal! "+yy
"     " paste in python REPL from clipboard using %paste magic
"     execute "T %paste"
"     " move down a line to chain multiple calls easily
"     normal! j
"   endfunction
"   " Without range it will call the function for every line in the range
"   function! IPythonLoadCurrentVisualSelection() range
"     " The range has been yanked to clipboard already
"     execute "T %paste"
"     " Move to the end of visual selection and then down a line, see :h `> for
"     " info
"     normal! `>j
"   endfunction
"   fun! GoNeoterm()
"     nnoremap <buffer> <leader>t :call IPythonLoadCurrentLine()<CR>
"     vnoremap <buffer> <leader>t "+y<CR>:call IPythonLoadCurrentVisualSelection()<CR>
"     nnoremap <buffer> <leader>T :call IPythonLoadCurrentFile()<CR>
"     tnoremap <ESC> <C-\><C-n>
"   endfun
"   augroup neotermcmds
"     autocmd! neotermcmds
"     autocmd FileType python :call GoNeoterm()
"   augroup end

" Python specific bindings from https://stackoverflow.com/a/54108005
" augroup pybindings
"   autocmd! pybindings
"   autocmd Filetype python nmap <buffer> <silent> <leader>isort :Isort<CR>
" augroup end

" Plug 'junegunn/vim-easy-align'       " sounds super cool, never used so far
"   " Start interactive EasyAlign in visual mode (e.g. vipga)
"   xmap ga <Plug>(EasyAlign)
"   " Start interactive EasyAlign for a motion/text object (e.g. gaip)
"   nmap ga <Plug>(EasyAlign)

" Plug 'sbdchd/vim-shebang'            " automatically add #! stuff to files
"   let g:shebang#shebangs = {
"               \ 'julia': '#!/usr/bin/env julia',
"               \ 'sh': '#!/usr/bin/env bash',
"               \ 'python': '#!/usr/bin/env python',
"               \ 'R': '#!/usr/bin/env Rscript'
"               \}


" Plug 'tmhedberg/SimpylFold'          " Better Python folding
"   let g:SimpylFold_docstring_preview=1
"   set foldmethod=indent
"   set foldlevel=99

" Plug 'Konfekt/FastFold'              " Suggested by SimplyFold to improve speed

" Coc handle tags, do I still need this?
" Plug 'ludovicchabant/vim-gutentags'
"   " Do not pollute projects with tag files, keep them all in one place.
"   let g:gutentags_cache_dir = '~/.tags_dir'

" Plug 'majutsushi/tagbar'
"   let g:tagbar_autofocus = 1
"   nmap <F6> :TagbarToggle<CR>
"   let g:tagbar_type_vimwiki = {
"           \   'ctagstype':'vimwiki'
"           \ , 'kinds':['h:header']
"           \ , 'sro':'&&&'
"           \ , 'kind2scope':{'h':'header'}
"           \ , 'sort':0
"           \ , 'ctagsbin':'/home/lapo/dotfiles/neovim/vwtags.py'
"           \ , 'ctagsargs': 'markdown'
"           \ }

" Plug 'itchyny/calendar.vim'

" Plug 'ap/vim-buftabline'            " Show open buffers
"   let g:buftabline_numbers=2      " Show ordinal tab numbers (not the vim buffer ones)
  " Doesn't display correct with CascadiaCode Nerd Font
  " let g:buftabline_separators=1   " Add vertical bars beween tabs
  " Use leader+number to quickly change tab
  " nmap <leader>1 <Plug>BufTabLine.Go(1)
  " nmap <leader>2 <Plug>BufTabLine.Go(2)
  " nmap <leader>3 <Plug>BufTabLine.Go(3)
  " nmap <leader>4 <Plug>BufTabLine.Go(4)
  " nmap <leader>5 <Plug>BufTabLine.Go(5)
  " nmap <leader>6 <Plug>BufTabLine.Go(6)
  " nmap <leader>7 <Plug>BufTabLine.Go(7)
  " nmap <leader>8 <Plug>BufTabLine.Go(8)
  " nmap <leader>9 <Plug>BufTabLine.Go(9)

" Plug 'SirVer/ultisnips'              " Custom snippets
"   " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"   let g:UltiSnipsExpandTrigger="<C-u>"
"   let g:UltiSnipsJumpForwardTrigger="<Down>"
"   let g:UltiSnipsJumpBackwardTrigger="<Up>"
"   let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/neovim/UltiSnips']

" Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
" Plug 'neovimhaskell/haskell-vim'
" Plug 'tpope/vim-obsession'

" Plug 'dense-analysis/ale'
"   " " Equivalent to the above.
"   let g:ale_linters = {'python': ['flake8']}
"   let g:ale_fixers = {
"   \   '*': ['remove_trailing_lines', 'trim_whitespace'],
"   \   'javascript': ['prettier'],
"   \   'python': ['black','isort']
"   \}
"   let g:LINT_FIX_ENV = '/home/lapo/miniconda3/envs/deep/bin/'
"   let g:ale_python_black_executable = g:LINT_FIX_ENV . 'black'
"   let g:ale_python_isort_executable = g:LINT_FIX_ENV . 'isort'
"   let g:ale_python_flake8_executable = g:LINT_FIX_ENV . 'flake8'
"   let g:ale_python_flake8_options = "--ignore=F632,E501,W503,E203,E731"
"   let g:ale_set_loclist = 0
"   let g:ale_set_quickfix = 1
"   let g:ale_lint_on_text_changed = 0
"   let g:ale_lint_on_save = 0
"   let g:ale_lint_on_insert_leave = 0
"   let g:ale_lint_on_enter = 0
"   let g:ale_fix_on_save = 0

" Plug 'maximbaz/lightline-ale'

" I keep adding, removing, tweaking this motherfucker but I cannot get it to
" work smoothly >_> The python language server is slow af sometimes and I have
" to wait multiple seconds for it to finish checking in the background before
" I can use things like go to def.
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
"   " TextEdit might fail if hidden is not set.
"   " set hidden
"   " Some servers have issues with backup files, see #649.
"   set nobackup
"   set nowritebackup
"   " Give more space for displaying messages.
"   " set cmdheight=2
"   " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"   " delays and poor user experience.
"   set updatetime=300
"   " Don't pass messages to |ins-completion-menu|.
"   set shortmess+=c
"   " Always show the signcolumn, otherwise it would shift the text each time
"   " diagnostics appear/become resolved.
"   " set signcolumn=yes
"   function! s:check_back_space() abort
"     let col = col('.') - 1
"     return !col || getline('.')[col - 1]  =~# '\s'
"   endfunction
"   " Use K to show documentation in preview window.
"   function! s:show_documentation()
"     if (index(['vim','help'], &filetype) >= 0)
"       execute 'h ' . expand('<cword>')
"     else
"       call CocAction('doHover')
"     endif
"   endfunction
"   fun! GoCoc()
"     " Use tab for trigger completion with characters ahead and navigate.
"     " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"     " other plugin before putting this into your config.
"     inoremap <buffer> <silent><expr> <TAB>
"           \ pumvisible() ? "\<C-n>" :
"           \ <SID>check_back_space() ? "\<TAB>" :
"           \ coc#refresh()
"     inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"     nmap <buffer> <silent> gd <Plug>(coc-definition)
"     nmap <buffer> <silent> gr <Plug>(coc-references)
"     nmap <buffer> <silent> <leader>rn <Plug>(coc-rename)
"     nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>
"     nnoremap <buffer> <silent> <leader>coc  :<C-u>CocList<CR>
"   endfun
"   augroup cocbindings
"     autocmd! cocbindings
"     autocmd Filetype python,json,vim,javascript :call GoCoc()
"   augroup end

" " COC LIGHTLINE CONFIGURATION
" " From https://github.com/neoclide/coc.nvim/issues/401
" " Show CocDiagnistics in lightline, hide on small windows/splits
" function! CocStatusMsg() abort
"   return winwidth(0) > 100 ? get(g:, 'coc_status', '') : ''
" endfunction
" let g:coc_user_config = {
"   \ 'diagnostic': {
"   \   'errorSign': 'E',
"   \   'warnignSign': 'W'
"   \   }
"   \ }
" function! s:lightline_coc_diagnostic(kind, sign) abort
"   let info = get(b:, 'coc_diagnostic_info', 0)
"   if empty(info) || get(info, a:kind, 0) == 0
"     return ''
"   endif
"   try
"     let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
"   catch
"     let s = ''
"   endtry
"   return printf('%s %d', s, info[a:kind])
" endfunction
"   function! LightlineCocErrors() abort
"   return s:lightline_coc_diagnostic('error', 'error')
" endfunction
" function! LightlineCocWarnings() abort
"   return s:lightline_coc_diagnostic('warning', 'warning')
" endfunction
" autocmd User CocStatusChange call lightline#update()
" autocmd User CocDiagnosticChange call lightline#update()

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
