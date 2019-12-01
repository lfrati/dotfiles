" vim: fdm=marker
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

" Code completion & highlighting
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'     " better syntax highlight

" Editing
Plug 'tpope/vim-surround'            " cs surrounding capabilities eg. cs)], csw'  
Plug 'tpope/vim-commentary'          " gc+motion to comment
Plug 'christoomey/vim-system-copy'   " cp/cv for copy paste e.g. cvi = paste inside '
Plug 'terryma/vim-multiple-cursors'  " very cool but seems kinda buggy
Plug 'junegunn/vim-easy-align'       " sounds super cool, never used so far
Plug 'kassio/neoterm'                " copy code to Ipython terminal
Plug 'sbdchd/vim-shebang'            " automatically add #! stuff to files

" Tags management
Plug 'universal-ctags/ctags'
Plug 'ludovicchabant/vim-gutentags'
Plug 'powerline/powerline'

" Appearance
Plug 'joshdick/onedark.vim'     " atom inpspired true color theme
Plug 'itchyny/lightline.vim'    " lightweight status line
Plug 'ap/vim-buftabline'        " Show open buffers
Plug 'ryanoasis/vim-devicons'   " DevIcons for some plugins
Plug 'tpope/vim-fugitive'       " For git-awareness 
Plug 'tmhedberg/SimpylFold'     " Better folding
Plug 'Konfekt/FastFold'         " Suggested by SimplyFold to improve speed

" Navigation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion' " THE GOD PLUGIN
Plug 'kien/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-repeat'          " Allows repeating some plugins operations using .


" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" ============================================================================
" Lightline {{{1
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
" BufTabLine {{{1
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
" CtrlP {{{1
" ============================================================================
set wildignore+=*/.git/*,*/tmp/*,*.swp,*.so,*.zip
if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" ============================================================================
" EasyMotion {{{1
" ============================================================================
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

" ============================================================================
" FZF {{{1
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

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Use FZF to search in current file dir with preview
nnoremap <c-f> :Files<CR>

" USES FUGITIVE FOR HANDLING GIT
function! GitAwarePath()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p:h')
  if path[:len(root)-1] ==# root
    return root
  endif
  return path
endfunction
" Offload interactive search to Rg, use FzF only as a wrapper around it, also
" add preview
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

" ============================================================================
" vim-multiple-cursor {{{1
" ============================================================================
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key = '<C-s>'
let g:multi_cursor_next_key       = '<C-s>'
let g:multi_cursor_skip_key       = '<C-x>'
let g:multi_cursor_quit_key       = '<Esc>'

" ============================================================================
" vim-easy-align {{{1
" ============================================================================
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" ============================================================================
" gutentags {{{1
" ============================================================================
" augroup MyGutentagsStatusLineRefresher
"     autocmd!
"     autocmd User GutentagsUpdating call lightline#update()
"     autocmd User GutentagsUpdated call lightline#update()
" augroup END
" Do not pollute projects with tag files, keep them all in one place.
let g:gutentags_cache_dir = '~/.tags_dir'

" ============================================================================
" NeoTerm {{{1
" ============================================================================
let g:neoterm_repl_python= '/home/lapo/miniconda3/envs/deep/bin/ipython --no-autoindent --pylab'
let g:neoterm_eof="\r"

let g:neoterm_default_mod= ':vertical'
let g:neoterm_size=80
let g:neoterm_autoscroll=1

nnoremap <leader>t :TREPLSendLine<CR>
nnoremap <leader>T :TREPLSendFile<CR>
vnoremap <leader>t :TREPLSendSelection<CR>
tnoremap <ESC> <C-\><C-n>

" ============================================================================
" NERDTree {{{1
" ============================================================================
" silent! nmap <C-p> :NERDTreeToggle<CR>
" silent! map <F3> :NERDTreeFind<CR>

" let g:NERDTreeMapActivateNode="<F3>"
" let g:NERDTreeMapPreview="<F4>"

" ============================================================================
" vim-shebang {{{1
" ============================================================================
" Define my common Shebang
let g:shebang#shebangs = {
            \ 'julia': '#!/usr/bin/env julia',
            \ 'sh': '#!/usr/bin/env bash',
            \ 'python': '#!/usr/bin/env python',
            \ 'R': '#!/usr/bin/env Rscript'
            \}

" ============================================================================
" SimplyFold {{{1
" ============================================================================

let g:SimpylFold_docstring_preview=1

" ============================================================================
" COC {{{1 https://github.com/neoclide/coc.nvim
" ============================================================================

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" NO IDEA WHAT SELECTION RANGES ARE
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" COC Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

set updatetime=300 " You will have bad experience for diagnostic messages when it's default 4000. (COC)
set shortmess+=c " don't give ins-completion-menu messages. (COC)

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
set autoread                           " Reload files changed outside vim
set notimeout ttimeout ttimeoutlen=200 " Quickly time out on keycodes, but never time out on mappings

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

" Set backups --> CONFLICT WITH COC.NVIM plugin 
" if has('persistent_undo') 
"     set undofile 
"     set undolevels=3000 
"     set undoreload=10000
" endif
" set backupdir=~/.local/share/nvim/backup " Don't put backups in current dir
" set backup
" set noswapfile

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

" center current line after jumping to prev/next locations
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" not that hjkl is any better but it's a start
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
