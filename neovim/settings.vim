" needed by various plugins
set nocompatible
filetype plugin on

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
set path=.,,,**                        " Search down into subfolders,  provides tab-completion for all file-related tasks
set splitbelow                          " Open new split panes to right 
set splitright                          " and bottom, which feels more natural than Vim’s default
set autoindent                          " When opening a new line and no filetype-specific indenting is enabled, keep the same indent as the line you're currently on. Useful for READMEs, etc.
set visualbell                          " No beep
set noerrorbells                        " and no bells on errors
set hidden                              " This makes vim act like all other editors, buffers can exist in the background without being in a window. http://items.sjbach.com/319/configuring-vim-right
set nostartofline                       " Try to keep the curso in place
set whichwrap+=<,>,h,l                  " And allow moving over lines in certain situations
set confirm                             " Instead of failing a command because of unsaved changes, instead raise a dialogue asking if you wish to save changed files.
if has("nvim")
  set inccommand=split                  " let :s/:%s show incremental highlight of matches in a temporary split
endif

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
