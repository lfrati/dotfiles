" Install vim-plug if needed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'qpkorr/vim-bufkill'
  nnoremap <leader>- :BD<Cr>

Plug 'tpope/vim-unimpaired'

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
    " autocmd BufWritePre *.py execute ':Black'
    autocmd FileType python nmap <leader><leader>b :Black<CR>
    command! Isort :! isort %
    command! Flake :! autoflake --in-place --remove-all-unused-imports %
  augroup end

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


" The godsend savior of REPLS
Plug 'jpalardy/vim-slime'
  let g:slime_target = "tmux"
  let g:slime_paste_file = tempname()
  let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.2"}
  let g:slime_dont_ask_default = 1
  " let g:slime_python_ipython = 1
  let g:slime_bracketed_paste = 1
  let g:slime_no_mappings = 1
  let g:slime_cell_delimiter='#%%'
  function! RegionHandler()
    " wouldn't it be nice to move to the next cell after sending the current
    " one? oh if only there was a way to do it...
    call slime#send_cell()
    call search(g:slime_cell_delimiter, 'W')
    execute 'normal! zz'
  endfunction
  augroup slimecmds
    autocmd! slimecmds
    autocmd FileType python xmap <leader><leader>p <Plug>SlimeRegionSend
    autocmd FileType python nmap <leader><leader>p <Plug>SlimeParagraphSend
    autocmd FileType python nmap <leader><leader>r :call RegionHandler()<CR>
  augroup END


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
    autocmd BufEnter * checktime
  augroup END

Plug 'tpope/vim-commentary'          " gc code away
  nmap <Bslash> gcc
  vmap <Bslash> gc

Plug 'joshdick/onedark.vim'         " atom inpspired true color theme
 let g:onedark_hide_endofbuffer=1

Plug 'williamboman/nvim-lsp-installer' " handle installing LSPs
Plug 'neovim/nvim-lspconfig'           " handle configuring LSPs
Plug 'hrsh7th/nvim-cmp'                " handle completiong through LSP
Plug 'hrsh7th/cmp-nvim-lsp'            " 

Plug 'nvim-lua/plenary.nvim'           " requirement for telescope + is useful
Plug 'nvim-telescope/telescope.nvim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
