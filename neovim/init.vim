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

" Suggested by vim-markdown
Plug 'godlygeek/tabular'

Plug 'plasticboy/vim-markdown'
  let g:vim_markdown_folding_disabled = 1
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
  au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
  au BufEnter *.md setlocal foldmethod=expr
  " au BufEnter *.md setlocal foldlevel=99

" God this plugin is good. Live rendering, cursor syncing
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
  " nmap <leader>md <Plug>MarkdownPreviewToggle
  nmap <leader>m <Plug>MarkdownPreviewToggle

Plug 'terryma/vim-multiple-cursors' " <C-n> for easy multi-cursor edit
  " If set to 0, insert mappings won't be supported in Insert mode anymore.
  " (default : 1)
  let g:multiple_cursors_support_imap = 0
  " If set to 1, then pressing g:multi_cursor_quit_key in Visual mode will
  " quit and delete all existing cursors, just skipping normal mode with
  " multiple cursors.  (default : 0)
  let g:multi_cursor_exit_from_visual_mode = 1
  " If set to 1, then pressing g:multi_cursor_quit_key in Insert mode will
  " quit and delete all existing cursors, just skipping normal mode with
  " multiple cursors.  (default : 0)
  let g:multi_cursor_exit_from_insert_mode = 1

Plug 'airblade/vim-gitgutter'
  let g:gitgutter_map_keys = 0 
  function! GitChunks()
    let [a,m,r] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', a, m, r)
  endfunction

Plug 'neoclide/coc.nvim', {'branch': 'release', 'for':['python','javascript']}
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
  " set signcolumn=yes
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
  fun! GoCoc()
    inoremap <buffer> <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <buffer> <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    nmap <buffer> <silent> gd <Plug>(coc-definition)
    nmap <buffer> <silent> gr <Plug>(coc-references)
    nmap <buffer> <silent> <leader>rn <Plug>(coc-rename)
    " nmap <buffer> <silent> <leader>isort :Isort<CR>
    nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>
    nnoremap <buffer> <silent> <leader>coc  :<C-u>CocList<CR>
  endfun
  augroup cocbindings
    autocmd! cocbindings
    autocmd Filetype python,javascript :call GoCoc()
  augroup end

Plug 'SirVer/ultisnips'              " Custom snippets
  " Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
  let g:UltiSnipsExpandTrigger="<C-u>"
  let g:UltiSnipsJumpForwardTrigger="<Down>"
  let g:UltiSnipsJumpBackwardTrigger="<Up>"
  let g:UltiSnipsSnippetDirectories=[$HOME.'/dotfiles/neovim/UltiSnips']

" My zettelkasten for life?
Plug 'vimwiki/vimwiki', {'branch' : 'dev'}
  let g:vimwiki_key_mappings =
    \ {
    \   'all_maps': 0,
    \   'global': 0,
    \   'headers': 0,
    \   'text_objs': 0,
    \   'table_format': 0,
    \   'table_mappings': 0,
    \   'lists': 0,
    \   'links': 0,
    \   'html': 0,
    \   'mouse': 0,
    \ }  
  nmap <Leader>ww <Plug>VimwikiIndex
  let g:vimwiki_global_ext=0 " Prevent creation of temporary wikis so that markdown file are not flagged vimwiki
  " let g:vimwiki_folding='expr'
  let g:vimwiki_folding='custom'
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
  let g:VIMWIKI_DIR = $HOME . "/Dropbox/vimwiki"
  function! s:MyMakeNote()
    " Create a new note with a unique name using the date + random string
    py from uuid import uuid4
    py from datetime import datetime
    let l:id = pyeval("datetime.today().strftime('%Y_%m_%d_') + uuid4().hex[:8]") . ".md"
    let l:path = g:VIMWIKI_DIR . "/". l:id
    " return path and id because vimwiki links only need the id but opening
    " files requires the path
    return {"path" : l:path, "id" : l:id }
  endfunction
  function! s:GetVisualSelection()
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
  function! s:MakeLink(title, file)
    " use replace to turn the selection into a markdown link [a:title](a:file)
    let l:line_num = line(".")
    let l:line = getline(l:line_num)
    call setline(l:line_num, substitute(l:line, '\('. a:title .'\)', '[\1]('. a:file .')', "g"))
  endfunction
  function! s:AddNote(mode)
    if  match(getline('.'),'\[.\+\](.\+)') >= 0
      " extract filename from markdown link
      let l:line = getline('.')
      " extract groups
      let l:parts = matchlist(l:line, '\[\([^\]]\+\)\](\(.\+\))')
      " matchlist returns [fullmatch, group1, group2,...]
      let l:file = l:parts[2]
      " open link takes care of creating the file and allows for going back with backspace
      call vimwiki#base#open_link("e",l:file)
    else
      " create new note and wraps the current word in a markdown link syntax
      let l:path = s:MyMakeNote().id
      if a:mode == 'v'
        " Get visual selection to allow multiple words as link name
        let l:name = s:GetVisualSelection()
      else
        " assume normal mode
        let l:name = expand('<cWORD>')
      endif
      call s:MakeLink(l:name, l:path)
    endif
  endfunction
  function! s:AddPrevious()
    " wraps the current word in a markdown link to the alternate-file (<C-^>)
    let l:path = expand('#:t')
    " Be carefull to call this function from visual mode
    let l:name = s:GetVisualSelection()
    call s:MakeLink(l:name, l:path)
  endfunction
  fun! GoVimwiki()
    " autocmd InsertLeave <buffer> :update
    autocmd BufEnter <buffer> setlocal signcolumn=no
    " Link navigation mappings
    nmap <buffer> <TAB> <Plug>VimwikiNextLink
    nmap <buffer> <S-TAB> <Plug>VimwikiPrevLink
    nmap <buffer> <BS> <Plug>VimwikiGoBackLink
    " replaced by my link management functions
    " nmap <buffer> <CR> <Plug>VimwikiFollowLink
    " File management mappings
    nmap <buffer> <leader>wd <Plug>VimwikiDeleteFile
    nmap <buffer> <leader>wr <Plug>VimwikiRenameFile
    " Custom mappings
    " WikiBackward : Create link to alternate-file (<C-^>)
    " Usage should be:
    " 1. make new note with AddNote()
    " 2. go to the file you want to add link to new note
    " 3. use <leader>wp to make link
    " simple version in normal mode that creates empty link
    nnoremap <buffer> <leader>wb :put =\"[](\" . expand('#:t') . \")\"<CR>
    " uses current word as name of the link to alternate-file
    vnoremap <buffer> <leader>wb :call <SID>AddPrevious()<CR>
    " WikiForward : Create link to new note
    nmap <buffer> <CR> :call <SID>AddNote('n')<CR>
    vmap <buffer> <CR> :call <SID>AddNote('v')<CR>
    " WikiList : show the notes in chronological order and search tags
    nnoremap <buffer> <leader>wl :Notes<CR>
  endfun
  augroup vimwikicmds
    autocmd! vimwikicmds
    autocmd FileType vimwiki :call GoVimwiki()
  augroup end
  nmap <leader>n :execute "e " . <SID>MyMakeNote()['path']<CR>
  " copy the current file name to use it in notes
  " nmap <leader>cpf :let @+ = expand("%:t")<CR>
  " easily create link to previous buffer

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
      \             [ 'cocstatus' ],
      \             [ 'filename' ] 
      \           ],
      \   'right': [ 
      \              [ 'gitbranch','lineinfo' ],
      \              [ 'modified','fileencoding','filetype','sync']
      \            ]
      \ },
      \ 'inactive': {
      \ 'left': [ [ 'filename' ] ],
      \ 'right': [ [ 'lineinfo' ],
      \            [ 'modified','sync' ] ] 
      \ },
      \ 'component_function': {
      \   'gitbranch': 'GitStatus',
      \   'filename': 'LightlineFilename',
      \   'sync': 'SyncFlag',
      \   'cocstatus': 'CocStatusMsg'
      \ },
      \ 'component_expand':{
      \   'modified' : 'ModifiedFlag',
      \   'coc_error' : 'LightlineCocErrors',
      \   'coc_warning' : 'LightlineCocWarnings'
      \ },
      \ 'component_type':{
      \   'modified' : 'error',
      \   'coc_error' : 'error',
      \   'coc_warning' : 'warning'
      \ }
      \ }
  " Component expand is called only once every time the statusline is updated
  " To make our red modfied symbol work we update the statusline every time
  " there is a change. More info about the events in :help TextChanged
  augroup change_triggers
    autocmd! change_triggers
    autocmd TextChanged,TextChangedI,BufWritePost,BufEnter * call lightline#update()
    autocmd User CocStatusChange call lightline#update()
    autocmd User CocDiagnosticChange call lightline#update()
    " update the file whenever I switch to a new buffer or get back to nvim
    autocmd FocusGained, BufEnter * checktime
  augroup END
  function! ModifiedFlag()
    " custom function that checks if the buffer has been modified
    return &modifiable && &modified ? '[+]' : ''
	endfunction
  " From https://github.com/neoclide/coc.nvim/issues/401
  " Show CocDiagnistics in lightline, hide on small windows/splits
	function! CocStatusMsg() abort
	  return winwidth(0) > 100 ? get(g:, 'coc_status', '') : ''
  endfunction
  let g:coc_user_config = { 
    \ 'diagnostic': {
    \   'errorSign': 'E',
    \   'warnignSign': 'W'
    \   }
    \ }
  function! s:lightline_coc_diagnostic(kind, sign) abort
    let info = get(b:, 'coc_diagnostic_info', 0)
    if empty(info) || get(info, a:kind, 0) == 0
      return ''
    endif
    try
      let s = g:coc_user_config['diagnostic'][a:sign . 'Sign']
    catch
      let s = ''
    endtry
    return printf('%s %d', s, info[a:kind])
  endfunction
    function! LightlineCocErrors() abort
    return s:lightline_coc_diagnostic('error', 'error')
  endfunction
  function! LightlineCocWarnings() abort
    return s:lightline_coc_diagnostic('warning', 'warning')
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
      " return ' ' . l:head . ' ' . GitChunks()
      return ' ' . l:head
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
  " nmap <leader>bind :windo set scb!<CR>
  command! Bind :windo set scb!

" Zen mode
Plug 'junegunn/goyo.vim'
  function Get_color(group, attr)
    " https://github.com/junegunn/goyo.vim/blob/6b6ed2734084fdbb6315357ddcaecf9c8e6f143d/autoload/goyo.vim#L31
    return synIDattr(synIDtrans(hlID(a:group)), a:attr)
  endfunction
  " let bg = s:get_color('Normal', 'bg#')
  function! ReturnHighlightTerm(group, term)
    " https://github.com/junegunn/goyo.vim/blob/6b6ed2734084fdbb6315357ddcaecf9c8e6f143d/autoload/goyo.vim#L31
    " Store output of group to variable
    let output = execute('hi ' . a:group)
    " Find the term we're looking for
    return matchstr(output, a:term.'=\zs\S*')
  endfunction
  " let b = ReturnHighlightTerm('StatusLine', 'ctermbg')
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
    " hide annoying ~ delimiting end of buffer
    highlight EndOfBuffer ctermfg=bg ctermbg=bg
    " :call buftabline#update(0) not needed since I don't use buftabline
    " Limelight!
  endfunction
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
  " nnoremap <leader>go :Goyo<CR>

" highlight the area where writing and fade out the rest
Plug 'junegunn/limelight.vim'
  let g:limelight_conceal_ctermfg = 237

" The third component of the holy trinity of plugins 
" (fzf + vimwiki + easymotion)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'tpope/vim-fugitive'        " For git-awareness (used by fzf commands)

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
  " command! -bang -nargs=? -complete=dir Files
  "     \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
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
    let spec = {
             \ 'options': [ '--phony', 
                           \ '--query', a:query, 
                           \ '--bind', 'change:reload:'.reload_command
                        \ ],
             \ 'dir':path
             \ }
    call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
  endfunction
  " Use RipGrep to search inside files
  command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0) 
  " When fzf starts in a terminal buffer, the file type of the buffer is set to fzf. So you can set up FileType fzf autocmd to
  " customize the settings of the window. For example, if you use the default layout ({'down': '~40%'}) on Neovim, you might
  " want to temporarily disable the statusline for a cleaner look.
  if has('nvim') && !exists('g:fzf_layout')
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  endif
  " from https://coreyja.com/vim-spelling-suggestions-fzf/#fnref-1 
  function! FzfSpellSink(word)
    exe 'normal! "_ciw'.a:word
  endfunction
  function! FzfSpell()
    let suggestions = spellsuggest(expand("<cword>"))
    return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
  endfunction
  nnoremap <leader>fd :call FzfSpell()<CR>
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fl :Lines<CR>
  nnoremap <leader>fg :Rg<CR>
  nnoremap <leader>fw :Rg <C-R><C-W><CR>
  " Notes is part of the vimwiki mappings
  command! -bang -nargs=* Notes
  \ call fzf#vim#grep(
  \   'rg --column --no-line-number --no-heading --sortr=modified --color=always --smart-case -- '.shellescape('tags:'), 1,
  \   fzf#vim#with_preview({'dir' : g:VIMWIKI_DIR}), <bang>0)

Plug 'liuchengxu/vim-which-key'
  set timeout
  set timeoutlen=500
  " added two spaces because the vsplit was cutting the last 2 chars
  let g:which_key_map = {
        \ '-' : 'Close buffer  ',
        \ '=' : 'Open scratchpad  ',
        \ 'c' : 'Open init.vim  ',
        \ 'd' : 'Put date Y-m-d  ',
        \ 'e' : 'Exec curr line as bash  ',
        \ 'l' : 'Dictionary lookup  ',
        \ 'm' : 'Toggle md preview  ',
        \ 'n' : 'Create new note  ',
        \ 'p' : '<C-^>  ',
        \ 'q' : 'Quit  ',
        \ 's' : 'Save  ',
        \ }
  let g:which_key_map.w = {
        \ 'name' : '+vimwiki  ',
        \ 'b' : 'Backward link  ',
        \ 'd' : 'Delete file  ',
        \ 'f' : 'Forward link 2 new note  ',
        \ 'l' : 'List notes, search tags  ',
        \ 'r' : 'Rename file  ',
        \ 'w' : 'Open index  ',
        \ }
  let g:which_key_map.f = {
        \ 'name' : '+fzf  ',
        \ 'b' : 'Buffers  ',
        \ 'd' : 'Dictionary  ',
        \ 'f' : 'Files  ',
        \ 'g' : 'RipGrep  ',
        \ 'l' : 'Lines  ',
        \ 'w' : 'RipGrep curr word  ',
        \ }
  " the horiz floating bar is an ugly grey wall
  " the keys are also too spaced out to scan easily
  " Using a separate vertical stplit is much better
  let g:which_key_vertical = 1
  let g:which_key_use_floating_win = 0
  let g:which_key_position = 'topleft'
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
  " vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
  " ADD register after the Plug end
  " call which_key#register('<Space>', "g:which_key_map")

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

Plug 'tpope/vim-surround'            " cs surrounding capabilities eg. cs)], csw'

Plug 'christoomey/vim-system-copy'   " cp/cv for copy paste e.g. cvi = paste inside '

Plug 'tpope/vim-commentary'          " gc code away

Plug 'universal-ctags/ctags'         " Tags management

Plug 'tpope/vim-repeat'          " Allows repeating some plugins operations using .

Plug 'ryanoasis/vim-devicons'       " DevIcons for some plugins

Plug 'joshdick/onedark.vim'         " atom inpspired true color theme

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

call which_key#register('<Space>', "g:which_key_map")

" }}}
" ============================================================================
" UI Layout {{{
" ============================================================================

colorscheme onedark
set encoding=utf8
set background=dark " Because dark is cool

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
" set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings
set completeopt=longest,menuone,noselect,noinsert,preview " show popup menu when at least one match but don't insert stuff
set complete=.,w,b,u,t,kspell        " Check file -> window -> buffer -> hidden buffers -> tags -> spelling if enabled
set omnifunc=syntaxcomplete#Complete " On <c-x><c-o> use the file syntax to guess possible completions
set autoread                           " Reload files changed outside vim
set lazyredraw                         " Don't redraw while executing macros (good performance setting)
set linebreak                          " Stop annoying 80 chars line wrapping
set scrolloff=4
set foldlevel=99
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

let g:python3_host_prog="/home/lapo/miniconda3/envs/neovim3/bin/python"
let g:python_host_prog="/home/lapo/miniconda3/envs/neovim2/bin/python"

" Allows you to save files you opened without write permissions via sudo
" cmap w!! w !sudo tee %

" }}}
" ============================================================================
" Mappings {{{
" ============================================================================

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
" execute current line in shell and paste results under it
" nmap <leader>e :exec 'r!'.getline('..')<CR>
" execute current line in shell and paste results above it
" nnoremap <leader>ex !!bash<CR>
nnoremap <leader>e !!bash<CR>
" easily open and source neovim config file
" nnoremap <leader>conf :e $MYVIMRC<CR>
nnoremap <leader>c :e $MYVIMRC<CR>
" alternate between current file and previous file
nnoremap <leader>p <C-^> 
" insert date
" nnoremap <leader>date :put =strftime('%Y-%m-%d')<CR>
nnoremap <leader>d :put =strftime('%Y-%m-%d')<CR>
" Switch CWD to the directory of the open buffer
" nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>
" Take quick notes, with = so that is close to buffer close
nnoremap <leader>= :e ~/buffer.md<CR>
nnoremap <leader>- :bd<Cr>
" nnoremap <leader>wc :echo wordcount()["words"]<CR>
" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors)
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn
" Dictionary lookup
nnoremap <leader>l :execute "!xdg-open https://www.merriam-webster.com/dictionary/" . expand('<cword>')<CR>

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
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
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

" center current line after jumping to prev/next locations
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" DISABLE FUCKING EXMODE UNTIL I FIND A BETTER USE FOR Q
nmap Q <Nop>

" Remap VIM 0 to first non-blank character
map 0 ^

" }}}
" ============================================================================
" Custom colors {{{
" ============================================================================
" At the bottom to override themes and shit

" make the current word highlighting less of a punch in the eye
hi CurrentWord ctermbg=236
hi CurrentWordTwins ctermbg=236
" Give VimWiki links a nice light blue colors
hi VimwikiLink ctermfg=39 cterm=underline
" Use terminal background color to customize (no more trying to match both
" because of vim's uneven borders)
" hi Normal guibg=NONE ctermbg=NONE
hi EndOfBuffer ctermfg=bg ctermbg=bg

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

" " Very well made python aware plugin, I'm using it for semantig highlight
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
"   function MyCustomSemshiHighlights()
"       hi semshiGlobal          ctermfg=red
"       hi semshiLocal           ctermfg=209
"       hi semshiGlobal          ctermfg=214
"       hi semshiImported        ctermfg=180
"       hi semshiParameter       ctermfg=75
"       hi semshiParameterUnused ctermfg=117  cterm=underline
"       hi semshiFree            ctermfg=218
"       hi semshiBuiltin         ctermfg=207
"       hi semshiAttribute       ctermfg=49
"       hi semshiSelf            ctermfg=249
"       hi semshiUnresolved      ctermfg=226  cterm=underline
"       " hi semshiSelected        ctermfg=231  ctermbg=161
"       hi semshiSelected        ctermfg=161  cterm=underline
"       hi semshiErrorSign       ctermfg=231  ctermbg=160
"       hi semshiErrorChar       ctermfg=231  ctermbg=160
"       sign define semshiError text=E> texthl=semshiErrorSign
"   endfunction
"   autocmd FileType python call MyCustomSemshiHighlights()
"   autocmd ColorScheme * call MyCustomSemshiHighlights()

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
