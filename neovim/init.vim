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

Plug 'junegunn/vim-easy-align'
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)

Plug 'airblade/vim-gitgutter'
  let g:gitgutter_map_keys = 0

" Plug 'jiangmiao/auto-pairs'
" I find myself having to delete the second one most of the time, worth it?

" Plug 'universal-ctags/ctags'         
  " Tags management

Plug 'ludovicchabant/vim-gutentags'
  " Ctrl + ] easy tag, easy life
  " Do not pollute projects with tag files, keep them all in one place.
  let g:gutentags_cache_dir = '~/.tags_dir'

" Plug 'junegunn/limelight.vim'
"   " Color name (:help cterm-colors) or ANSI code
"   let g:limelight_conceal_ctermfg = 'gray'
"   let g:limelight_conceal_ctermfg = 240
"   " Color name (:help gui-colors) or RGB color
"   let g:limelight_conceal_guifg = 'DarkGray'
"   let g:limelight_conceal_guifg = '#777777'

Plug 'lervag/vimtex', {'for' : 'tex'}
  " let g:vimtex_view_general_viewer = 'zathura'
  " let g:vimtex_view_general_options
  "     \ = '-reuse-instance -forward-search @tex @line @pdf'
  " let g:vimtex_view_general_options_latexmk = '-reuse-instance'
  let g:vimtex_view_general_viewer = 'okular'
  let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
  let g:tex_flavor='latex'
  " TOC settings, toggle with <leader>lt
  let g:vimtex_toc_config = {
        \ 'name' : 'TOC',
        \ 'layers' : ['content', 'todo'],
        \ 'resize' : 1,
        \ 'split_width' : 50,
        \ 'todo_sorted' : 0,
        \ 'show_help' : 1,
        \ 'show_numbers' : 1,
        \ 'mode' : 1,
        \ 'split_pos' : 'full'
        \}
  let g:vimtex_syntax_conceal = {
      \ 'accents':0,
      \ 'ligatures':0,
      \ 'cites':0,
      \ 'sections':0,
      \ 'fancy':0,
      \ 'greek':1,
      \ 'math_bounds':1,
      \ 'math_delimiters':1,
      \ 'math_fracs':1,
      \ 'math_super_sub':1,
      \ 'math_symbols':1,
      \ 'styles':1
      \ }
  let g:vimtex_quickfix_ignore_filters = [
          \ 'Underfull',
          \]
  let g:vimtex#re#neocomplete =
      \ '\v\\%('
      \ .  '%(\a*cite|Cite)\a*\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|%(\a*cites|Cites)%(\s*\([^)]*\)){0,2}'
      \     . '%(%(\s*\[[^]]*\]){0,2}\s*\{[^}]*\})*'
      \     . '%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|bibentry\s*\{[^}]*'
      \ . '|%(text|block)cquote\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|%(for|hy)\w*cquote\*?\{[^}]*}%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|defbibentryset\{[^}]*}\{[^}]*'
      \ . '|\a*ref%(\s*\{[^}]*|range\s*\{[^,}]*%(}\{)?)'
      \ . '|hyperref\s*\[[^]]*'
      \ . '|includegraphics\*?%(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
      \ . '|%(include%(only)?|input|subfile)\s*\{[^}]*'
      \ . '|([cpdr]?(gls|Gls|GLS)|acr|Acr|ACR)\a*\s*\{[^}]*'
      \ . '|(ac|Ac|AC)\s*\{[^}]*'
      \ . '|includepdf%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|includestandalone%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|%(usepackage|RequirePackage|PassOptionsToPackage)%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|documentclass%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|begin%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|end%(\s*\[[^]]*\])?\s*\{[^}]*'
      \ . '|\a*'
      \ . ')'

Plug 'ajh17/VimCompletesMe'
  function! GoTex()
    setlocal spell
    set conceallevel=2
  endfunction
  augroup VimCompletesMeTex
    autocmd!
    autocmd FileType tex
        \ let b:vcm_omni_pattern = g:vimtex#re#neocomplete
    autocmd FileType tex call GoTex()
  augroup END

Plug 'SirVer/ultisnips'
  let g:UltiSnipsExpandTrigger="<c-u>"
  let g:UltiSnipsJumpForwardTrigger="<c-i>"
  let g:UltiSnipsJumpBackwardTrigger="<c-o>"

Plug 'tmux-plugins/vim-tmux-focus-events'

Plug 'qpkorr/vim-bufkill'
  " close buffer, but keep split

Plug 'JuliaEditorSupport/julia-vim', { 'for' : 'julia' }

Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1

" God this plugin is good. Live rendering, cursor syncing
" Makes previewing my vimkikis hella easy
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for':['markdown','vimwiki'] }
  " nmap <leader>md <Plug>MarkdownPreviewToggle
  nmap <leader>m <Plug>MarkdownPreviewToggle

" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  nmap <Leader>p <Nop>
  augroup prettiercmds
    autocmd! prettiercmds
    autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync
  augroup end

Plug 'tpope/vim-fugitive'

Plug 'psf/black', { 'branch': 'stable' , 'for' : 'python'}
  function! s:SafeFormat()
    let s:pos = getpos( '. ')
    let s:view = winsaveview()
    execute ':Black'
    execute ':Semshi highlight'
    call setpos( '.', s:pos )
    call winrestview( s:view )
  endfunc
  augroup pycmds
    autocmd! pycmds
    " autocmd BufWritePre *.py execute ':Black'
    " I've found a bug where sometimes black messes up Semshi's highlighting
    " this is a horrible fix. God have mercy.
    " autocmd BufWritePost *.py execute ':Semshi highlight'
    autocmd FileType python nmap <leader><leader>b :call <SID>SafeFormat()<CR>
    command! Isort :! isort %
    command! Flake :! autoflake --in-place --remove-all-unused-imports %
  augroup end

" Plug 'jeetsukumaran/vim-pythonsense'
"   let g:is_pythonsense_suppress_motion_keymaps = 1

Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
  function! MySemshiColors()
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
  function! GoSemshi()
      nmap <buffer> <silent> <leader>rn :Semshi rename<CR>
      nmap <buffer> <silent> <leader>er :Semshi goto error<CR>
  endfunction
  augroup semshicmds
    autocmd! semshicmds
    autocmd FileType python call GoSemshi()
    autocmd ColorScheme * call MySemshiColors()
  augroup end



Plug 'jpalardy/vim-slime'
  let g:slime_target = "tmux"
  let g:slime_paste_file = tempname()
  let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}
  let g:slime_dont_ask_default = 1
  let g:slime_python_ipython = 1
  let g:slime_no_mappings = 1
  let g:slime_cell_delimiter='# *%%'
  function! RegionHandler()
    " wouldn't it be nice to move to the next cell after sending the current
    " one? oh if only there was a way to do it...
    call slime#send_cell()
    call search(g:slime_cell_delimiter, 'W')
    execute 'normal! zz'
  endfunction
  augroup slimecmds
    autocmd! slimecmds
    autocmd FileType python,haskell xmap <leader><leader>p <Plug>SlimeRegionSend
    " autocmd FileType python,haskell nmap <leader><leader>p <Plug>SlimeParagraphSend
    autocmd FileType python,haskell nmap <leader><leader>p :call SlimeParagraphChecked()<CR>
    " autocmd FileType python,haskell nmap <leader><leader>r :call RegionHandler()<CR>
    autocmd FileType python,haskell nmap <leader><leader>r :call SlimeRegionChecked()<CR>
  augroup END
  " from https://jdhao.github.io/2020/11/15/nvim_text_objects/
  function! s:CellTextObj() abort
    " the parameter type specify whether it is inner text objects or around
    " text objects. TODO what is this line?
    " Move the cursor to the end of line in case that cursor is on the opening
    " of a code block. Actually, there are still issues if the cursor is on the
    " closing of a code block. In this case, the start row of code blocks would
    " be wrong. Unless we can match code blocks, it is not easy to fix this.
    normal! $
    let start_row = searchpos('\s*# *%%', 'bnW')[0]
    let end_row = searchpos('\s*# *%%', 'nW')[0]
    let buf_num = bufnr()
    " echo a:type start_row end_row
    call setpos("'<", [buf_num, start_row + 1, 1, 0])
    call setpos("'>", [buf_num, end_row, 1, 0])
    execute 'normal! `<V`>'
  endfunction
  vnoremap <silent> ic :<C-U>call <SID>CellTextObj()<CR>
  onoremap <silent> ic :<C-U>call <SID>CellTextObj()<CR>
  function! SlimeREPLCheck()
    let res = system("tmux list-panes -F '#{pane_current_command}'")
    let pos = stridx(res, "python")
    if pos > 0
      return 1
    else
      echo "No REPL found in panes."
      return 0
    endif
  endfunction
  function! SlimeRegionChecked()
    if SlimeREPLCheck()
      call RegionHandler()
    endif
  endfunction
  " https://github.com/jpalardy/vim-slime/blob/main/plugin/slime.vim
  function! SlimeParagraphChecked()
    if SlimeREPLCheck()
      let start = line("'{")
      let end = line("'}")
      call slime#send_range(start,end)
    endif
  endfunction

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
    let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
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
      \             [ 'modified' ],
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
  let g:lightline.tabline = {
		  \ 'left': [ [ 'tabs' ] ],
		  \ 'right': [ [] ] }
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
  nmap <Bslash> gcc
  vmap <Bslash> gc

Plug 'tpope/vim-repeat'          " Allows repeating some plugins operations using .

Plug 'ryanoasis/vim-devicons'       " DevIcons for some plugins

Plug 'preservim/nerdtree'
  map <F4> :NERDTreeToggle<CR>
  let NERDTreeMinimalUI = 1
  let NERDTreeDirArrows = 1
  let NERDTreeQuitOnOpen = 1
  " Exit Vim if NERDTree is the only window left.
  autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'joshdick/onedark.vim'         " atom inpspired true color theme
 " let g:onedark_terminal_italics=1
 let g:onedark_hide_endofbuffer=1

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
set complete=.,w,b,u,kspell            " Check file -> window -> buffer -> hidden buffers -> spelling if enabled
set omnifunc=syntaxcomplete#Complete   " On <c-x><c-o> use the file syntax to guess possible completions
set autoread                           " Reload files changed outside vim
set lazyredraw                         " Don't redraw while executing macros (good performance setting)
set linebreak                          " Stop annoying 80 chars line wrapping
set scrolloff=4                        " Leave some space above and below the cursor while scrolling
set signcolumn=yes                     " Show the gutter for git info, errors...
set cscopetag                          " Use :cstags instead on :tags on Ctrl-] to list multiple matches

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

" let g:netrw_browsex_viewer= "xdg-open"
" let g:netrw_http_cmd="xdg-open"
" None of the above works for some reason.
" when xdg-open is selected it keeps passing it a tempfile name and the url, 
" which makes xdg-open fail and then for some reason open my config file...
" hacky workaround below
nmap gx :silent execute "!xdg-open " . shellescape("<cWORD>")<CR>
vmap gx <Esc>:silent execute "!xdg-open" . shellescape("<C-r>*") . " &"<CR>

" with my current mapping [ and ] are adjacent so let's use [ to go back
" Mysterious bugs happen if I have this on
" nmap <C-[> <C-t> 

" }}}
" ============================================================================
" Mappings {{{
" ============================================================================

" https://salferrarello.com/vim-close-all-buffers-except-the-current-one/
command! Bonly execute '%bdelete|edit #|normal `"'

" convenient mapping to quickly correct the last spelling mistake while in
" inser mode. Requires :set spell
inoremap <C-f> <c-g>u<Esc>[s1z=`]a<c-g>u

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors)
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn

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

" alternate between current file and alternate file
nnoremap <leader><leader>a <C-^>

" execute current line in shell and paste results above it
nnoremap <leader><leader>ex !!bash<CR>

" Dictionary (l)ookup
" nnoremap <leader><leader>l :execute "!xdg-open https://www.merriam-webster.com/dictionary/" . expand('<cword>')<CR>
" nnoremap <leader><leader>h :execute "!xdg-open https://hoogle.haskell.org/\\?hoogle\\=" . expand('<cword>')<CR>
" nnoremap <leader><leader>l :execute "!xdg-open \"https://www.dictionary.com/browse/" . expand('<cword>') . "?s=t\""<CR>

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

function! EchoWarning(msg)
  echohl WarningMsg
  echo  a:msg
  echohl None
endfunction
nnoremap <leader>init :e $MYVIMRC<CR>
" Source vim configuration upon save
augroup vimrccmds     
    autocmd! vimrccmds
    autocmd BufWritePost $MYVIMRC nested so % | call EchoWarning("Reloaded " . $MYVIMRC) | redraw
augroup END


" map esc to exit in terminal mode
" OFC this messes up fzf.nvim, pressing esc now fucks up floating windows
" tnoremap <Esc> <C-\><C-n>

" I've remap <C-k> in tmux to move between panes, so I'll use this to insert
" digraphs instead
nnoremap <leader><leader>d i<C-K>

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
