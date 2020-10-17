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

" Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
" Plug 'neovimhaskell/haskell-vim'

" needed because of https://github.com/neovim/neovim/issues/1496
Plug 'lambdalisue/suda.vim'

Plug 'mhinz/vim-startify'
 let g:startify_bookmarks = [ 
       \ {'v': g:MY_VIMWIKIDIR . '/index.md' },
       \ {'c': $MYVIMRC },
       \ ]
 let g:startify_padding_left = 3

Plug 'tpope/vim-unimpaired'

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

Plug 'neoclide/coc.nvim', {'branch': 'release', 'for':['python','javascript','json']}
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
    autocmd Filetype json,python,javascript :call GoCoc()
  augroup end

" God this plugin is good. Live rendering, cursor syncing
" Makes previewing my vimkikis hella easy
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install', 'for':['markdown','vimwiki'] }
  " nmap <leader>md <Plug>MarkdownPreviewToggle
  nmap <leader>m <Plug>MarkdownPreviewToggle

" My zettelkasten for life?
Plug 'vimwiki/vimwiki', {'branch' : 'dev'}
  let g:vimwiki_key_mappings =
    \ {
    \   'global': 0,
    \   'headers': 0,
    \   'text_objs': 0,
    \   'table_format': 0,
    \   'table_mappings': 0,
    \   'lists': 1,
    \   'links': 0,
    \   'html': 0,
    \   'mouse': 0,
    \ }  
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
  let g:vimwiki_tag_format = {'pre_mark': '#', 'post_mark': '#', 'sep': ':'}
  " ==================
  " HANDLERS FUNCTIONS
  " ==================
  let g:MY_URLPATTERN ='https\?://\(www\.\)\?[[:alnum:]\%\/\_\#\.\:\-\?\=\&\~]\+' 
  function! s:Link_handler()
    " Overrides the powerfull vimwiki <Enter> mapping to handle zettle-style
    " notes.
    " NOTE: Needs to re-implement the link/url handling functionality
    " let l:word = expand('<cWORD>')
    let l:word = GetUnderCursor('!\?\[.\+\]([^)]\+)').match
    if l:word == ''
      let l:word = expand('<cWORD>')
    endif
    " URL
    " https://www.img.com
    " ![test](https://img.com) =)
    let l:match = matchlist(l:word , g:MY_URLPATTERN)
    if len(l:match) > 0
      let l:url = l:match[0]
      echo "Opening " . l:url 
      call system('xdg-open ' . shellescape(l:url).' &')
      return
    endif
    " assets:
    " video link       [title](assets/name.mp4)
    " markdown image  ![title](assets/name.{jpg|png|jpeg})
    " pdf              [title](assets/name.pdf})
    let l:match = matchlist(l:word ,'\!\?[.\+\](\(assets/.\+\))')
    if len(l:match) > 0
      let l:vid = g:MY_VIMWIKIDIR . '/' . l:match[1]
      call system('xdg-open ' . shellescape(l:vid) . ' &')
      return
    endif
    " markdown link []()
    let l:match = matchlist(l:word ,'\[\([^\]]\+\)\](\([^)]\+\))')
    " let match_link = GetUnderCursor('\[.\+\]([^)]\+)')
    " If current line contains a link follow it 
    if  len(l:match) > 0
      " extract groups -> link_name and file_name
      " matchlist returns [fullmatch, group1, group2,...]
      let l:title = l:match[1]
      let l:file = l:match[2]
      " open link takes care of creating the file and allows for going back with backspace
      call vimwiki#base#open_link("e",l:file)
      call s:Insert_header("",l:title)
      return
    endif 
    " None of the above, so create link
    call s:ForwardLink_handler()
  endfunction
  function! s:ForwardLink_handler()
    let l:name = expand('<cWORD>')
    " create new note and wraps the current word in a markdown link syntax
    let l:path = Make_zettlenote().id
    call s:Insert_link(l:name, l:path)
  endfunction
  function! s:BackwardLink_handler()
    " Create link to alternate-file
    let l:path = expand('#:t')
    let l:name = expand('<cWORD>')
    call s:Insert_link(l:name, l:path)
  endfunction
  function! Paste_handler()
    if s:Insert_bib()
      return
    endif
    if s:Insert_PNG()
      return
    endif
    if Insert_video_link()
      return
    endif
  endfunction
  function! GetBibID(file)
    " Papers notes (should) contain the corresponding bibfile
    " Extract the citation id from the file
    " e.g.
    " ```bib
    " @article{srivastava2014dropout,
    "   ...
    " }
    " ``` ---> srivastava2014dropout
    let lines = readfile(g:MY_VIMWIKIDIR . "/" . a:file)
    let l:found = match(l:lines, '@[^{]\+{\(.\+\),')
    let l:is_bib = match(l:lines, '```bib')
    let l:name = 'cite'
    if l:found > 0 && l:found == l:is_bib + 1
      let l:matches = matchlist(l:lines[l:found], '@[^{]\+{\(.\+\),')
      let l:name = l:matches[1]
    endif
    return l:name
  endfunction
  " ================
  " INSERT FUNCTIONS
  " ================
  function! s:Insert_header(tag,title)
  " Insert yaml front matter in empty files
    if line('$') == 1 && getline(1) == ''
      let l:tags = "tags: " . a:tag . "\<CR>"
      let l:keyw = "keywords: \<CR>"
      let l:title = "title: " . a:title . "\<CR>"
      let l:date = "date: " . system('date --iso-8601=seconds')
      let l:header = "---\<CR>" . l:tags . l:keyw . l:title . l:date . "---\<CR>"
      execute "normal! ggi" . l:header
      normal ggj$
    endif
  endfunction
  function! s:Insert_bib()
    " check beginning of content of copy register (+)
    " to see if it is @ (beginning of bib entry)
    if strpart(@+,0,1) == "@"
      normal G
      call append(line('$'), "```bib")
      call append(line('$'), "")
      call append(line('$'), "```")
      execute "normal! Gk\"+gP"
      " copy title from bib to a-register
      execute 'g/^[ ]\+title=/normal www"ayi}'
      " make the note title the same as bib title
      execute '%s/title\:.\+/title\: ' . tolower(@a) . '/'
      " add paper tag
      execute '%s/tags\: /tags\: #paper#/'
      " sometimes an empty line appears, don't know why
      " execute '%s/}\n\n```/}\r```/'
      return 1
    else
      " echo "Clipboard doesn't contain bib"
      return 0
    endif
  endfunction
  function! s:Insert_PNG()
  " If there is an img in the clipboard save it to
  " MY_VIMWIKIDIR/assets/filename_rndmst and insert an image link
    py from uuid import uuid4
    let l:avail = system('xclip -selection clipboard -t TARGETS -o')
    if l:avail =~ 'image/png'
      let l:file = expand('%:t:r')
      let l:id = pyeval("uuid4().hex[:5]")
      let l:link = "assets/" . l:file . '_' . l:id . '.png'
      let l:path = g:MY_VIMWIKIDIR . '/' . l:link
      call system('xclip -selection clipboard -t image/png -o > ' . l:path)
      echo "Image saved to " . l:path
      let l:img_link = '![img]('.l:link . ')'
      put =l:img_link
      return 1
    else
      " echo "No image found in clipboard."
      return 0
    endif
  endfunction
  function! Insert_video_link()
    let l:url = @+
    let l:match = matchlist(l:url ,'^https\?://' . g:stream_patterns . '.\+$')
    if len(l:match) > 0
      echo "Pasting video"
      let l:vid_title = trim(system("youtube-dl -e " . shellescape(l:url)))
      if l:vid_title == ''
        let l:vid_title = "video"
      endif
      let l:img_link = '['.l:vid_title.'](' . l:url . ')'
      " put =l:img_link
      execute "normal! A" . l:img_link 
      return 1
    else
      " echo "No youtube link found in clipboard."
      return 0
    endif
  endfunction
  function! s:Insert_link(name, path)
    " Use replace to insert a markdown link [a:title](a:file) in the current line.
    " Don't use bunch of spaces or empty lines as links
    if a:name != '' && a:name !~? '^\s\+$'
      let l:pos = GetUnderCursor(a:name)
      call s:ReplaceCoords('['.a:name.']('.a:path.')',l:pos)
    else
      echo "Select something to make a link."
    endif
  endfunction
  " ==============
  " BACKUP HELPERS
  " ==============
  " from https://neovim.io/doc/user/job_control.html
  " function! s:OnEvent(job_id, data, event) dict
  "     if a:event == 'stdout'
  "       let str = self.shell.' stdout: '.join(a:data)
  "       echo str
  "     else
  "       echo self.shell . ": Download complete."
  "       let g:job = -1
  "     endif
  " endfunction
  " let s:callbacks = {
  "   \ 'on_stdout': function('s:OnEvent'),
  "   \ 'on_stderr': function('s:OnEvent'),
  "   \ 'on_exit': function('s:OnEvent')
  "   \ }
  " let g:job = -1
  " function! YoutubeDownloader(url, file)
  "   let l:cmd = printf("youtube-dl -f 'best[height<=480]' --format mp4 -o '%s' %s", a:file, a:url)
  "   let g:job = jobstart(['bash', '-c', l:cmd], extend({'shell': 'youtube-dl'}, s:callbacks))
  " endfunction
  " function! JobKill()
  "   call jobstop(g:job1)
  "   let g:job = -1
  " endfunction
  function! GetParts(url, title)
    let l:title_pattern = '\[\([^\]]\+\)\]'
    let l:link_pattern =  l:title_pattern . '(' . a:url . ')'
    let l:search = GetUnderCursor(l:link_pattern)
    let l:word = l:search.match
    if l:word == ''
      let l:search = GetUnderCursor(a:url)
      let l:word = l:search.match
    endif
    let l:url = matchlist(l:word , a:url)
    let l:title = matchlist(l:word , l:title_pattern)
    if len(l:title) > 0
      let l:name = l:title[1]
    else
      let l:name = a:title
    endif
    if len(l:url) > 0
      let l:link = l:url[0]
    else
      let l:link = ""
    endif
      return [l:name, l:link, l:search]
  endfunction
  function! Backup_handler()
    " Youtube backup
    " match video-url or [name](video-url)
    let l:stream_url = 'https\?://\(' . g:stream_patterns . '\)[^ )]\+'
    let [l:title,l:url, l:old] = GetParts(l:stream_url, "stream")
    if l:title == ''
      let l:title = 'stream'
    endif
    if len(l:url) > 0
      let l:file = Backup_stream(l:url)
      if l:file != ""
        let l:new = "[".l:title."](" . l:file . ")"
        call s:ReplaceCoords(l:new, l:old)
        return
      endif
    endif
    " Pdf backup
    let [l:title,l:url,l:old] = GetParts(g:MY_URLPATTERN, "")
    let l:ext = matchlist(l:url,'\.\([a-z]\+\)$')[1]
    if l:title == ''
      " use extension as title
      let l:title = l:ext 
    endif
    if len(l:url) > 0
      let l:file = Backup_url(l:url, l:ext)
      if l:file != ""
        let l:new = "[" . l:title . "](" . l:file . ")"
        call s:ReplaceCoords(l:new, l:old)
        return
      endif
    endif
    echo "No match found"
    return
  endfunction
  let g:stream_patterns = "youtu\\.be\\|www\\.youtube\\.com\\|vimeo\\.com"
  function! Backup_stream(url)
    " Convert youtube URLs to links and backup content
    " https://youtu.be/rbfFt2uNEyQ?t=5478           -> [video](assets/init_5f4e7.mp4)
    " https://www.youtube.com/watch?v=Z_MA8CWKxFU   -> [video](assets/init_f5913.mp4)
    " [test 1](https://youtu.be/rbfFt2uNEyQ?t=5478) -> [test 1](assets/init_f5782.mp4)
    " [test 2](https://www.youtube.com/watch?v=Z_U) -> [test 2](assets/init_ee172.mp4)
    " https://www.img.com                           -> https://www.img.com
    " check if video actually exists
    let l:vid_title = system("youtube-dl -e " . shellescape(a:url))
    " shell_error == 1 is the previous system call has failed
    if v:shell_error == 0
      let choice = confirm("Backup: " . trim(l:vid_title) . "?","&No\n&Yes")
      if choice == 2
        let l:temp = shellescape(tempname()) 
        " call YoutubeDownloader(shellescape(l:url), l:path)
        echo "Downloading " . l:vid_title 
        let l:cmd = "youtube-dl -f 'best[height<=480]' --format mp4 -o " . l:temp . " " . shellescape(a:url)
        echo system(l:cmd)
        let l:md5 = split(system('md5sum ' . l:temp), ' ')[0]
        let l:link = "assets/" . l:md5 . ".mp4"
        let l:cmd_mv = 'mv ' . l:temp . " " . g:MY_VIMWIKIDIR . "/" . l:link 
        echo "Calculating md5..."
        call system(l:cmd_mv)
        echo "Done."
      endif
      return l:link
    else
      echo "Video not found."
      return ""
      " endif
    endif
  endfunction
  let g:user_agent = shellescape("Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36")
  function! Backup_url(url,ext)
    let l:temp = shellescape(tempname())
    let l:cmd_download = "wget --user-agent=" . g:user_agent . " -O " . l:temp . " " . shellescape(a:url)
    echo "Backing up " . a:url
    let l:out = system(l:cmd_download)
    " echo l:out
    let l:md5 = split(system('md5sum ' . l:temp), ' ')[0]
    let l:link = "assets/" . l:md5 . "." . a:ext
    let l:cmd_mv = 'mv ' . l:temp . " " . g:MY_VIMWIKIDIR . "/" . l:link
    call system(l:cmd_mv)
    echo "Saved to " . l:link
    return l:link
  endfunction
  " =============
  " NOTE CREATION
  " =============
  function! Make_zettlenote()
    " Create a new note with a unique name using the date + random string
    " NOTE: the body of the node is empty, needs to call Insert_header!
    py from uuid import uuid4
    py from datetime import datetime
    let l:id = pyeval("datetime.today().strftime('%Y_%m_%d_') + uuid4().hex[:8]") . ".md"
    let l:path = g:MY_VIMWIKIDIR . "/". l:id
    " return path and id because vimwiki links only need the id but opening
    " files requires the path
    return {"path" : l:path, "id" : l:id }
  endfunction
  function! Make_emptynote()
    execute "e " . Make_zettlenote()['path']
    call s:Insert_header("","")
  endfunction
  " ============
  " INFO HELPERS
  " ============
  let s:CiteWin = -1
  function! s:Popup_cite()
    call s:Popup_cite_close()
    " use non-greedy match \{-} to select the content of square brackets
    let search = GetUnderCursor('\[.\{-}\](\([^)]\+\.md\))')
    if search.match != ''
      if s:CiteWin < 0
        let file = matchlist(search.match, '\[.\{-}\](\([^)]\+\.md\))')[1]
        let path = g:MY_VIMWIKIDIR . '/' . l:file
        if filereadable(l:path)
          let line = readfile(l:path, '', 4)[-1]
          let title_parts = matchlist(l:line ,'^title: \(.*\)')
          " title line found
          if len(l:title_parts) > 1 
            let title = title_parts[1]
            " title is not empty
            if len(title) > 0
              call s:Popup_cite_open(title)
            endif
          endif
        endif
      endif
    endif
  endfunction
  function! s:Popup_cite_open(txt)
    let buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(buf, 0, -1, v:true, [a:txt])
    let opts = {'relative': 'win', 'width': len(a:txt), 'height': 1, 'col': wincol()-1,
        \ 'row': winline()-2, 'anchor': 'NW', 'style': 'minimal'}
    let win = nvim_open_win(buf, 0, opts)
    " optional: change highlight, otherwise Pmenu is used
    call nvim_win_set_option(win, 'winhl', 'Normal:ErrorMsg')
    let s:CiteWin = win
  endfunction
  function! s:Popup_cite_close()
    if s:CiteWin > 0
      call nvim_win_close(s:CiteWin,0)
      let s:CiteWin = -1
    endif
  endfunction
  " ========
  " MAPPINGS
  " ========
  fun! GoVimwiki()
    " autocmd InsertLeave <buffer> :update
    autocmd BufEnter <buffer> setlocal signcolumn=no
    " autocmd! CursorMoved *.md call s:Popup_cite()
    autocmd! CursorMoved,WinLeave,BufLeave,FocusLost,InsertEnter *.md call s:Popup_cite_close()
    autocmd! CursorHold *.md call s:Popup_cite()
    " Link navigation mappings
    nmap <buffer> <TAB> <Plug>VimwikiNextLink
    nmap <buffer> <S-TAB> <Plug>VimwikiPrevLink
    nmap <buffer> <BS> <Plug>VimwikiGoBackLink
    " replaced by my link management functions
    " nmap <buffer> <CR> <Plug>VimwikiFollowLink
    " File management mappings
    nmap <buffer> <leader>wd <Plug>VimwikiDeleteFile
    nmap <buffer> <leader>wr <Plug>VimwikiRenameFile
    " DEPRECATED: use the History command (<leader>wih) to link recent notes
    " nmap <buffer> <leader>wb :call <SID>BackwardLink_handler()<CR>
    " vim(W)iki (I)nsert (B)ib
    " nmap <buffer> <leader>wib :call <SID>Insert_bib()<CR>
    " vim(W)iki (I)nsert (I)mage
    " nmap <buffer> <leader>wii :call <SID>Insert_PNG()<CR>
    " vim(W)iki (I)nsert (Y)outube
    " nmap <buffer> <leader>wiy :call Insert_video_link()<CR>
    " vim(W)iki (B)ackup (Y)outube 
    nmap <buffer> <leader>wbl :call Backup_handler()<CR>
    nmap <buffer> <CR> :call <SID>Link_handler()<CR>
    nmap <buffer> <C-Space> <Plug>VimwikiToggleListItem
    inoremap <C-v> <C-o>:call Paste_handler()<CR>
  endfun
  augroup vimwikicmds
    autocmd! vimwikicmds
    autocmd FileType vimwiki :call GoVimwiki()
    autocmd FileType vimwiki :call GoVimwiki_FZF()
  augroup end
  nmap <leader>wn :call Make_emptynote()<CR>
  nmap <Leader>ww <Plug>VimwikiIndex
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
      \             [ 'cocstatus','mymodified' ],
      \             [ 'filename' ] 
      \           ],
      \   'right': [ 
      \              [ 'gitbranch','lineinfo' ],
      \              [ 'fileencoding','filetype','sync']
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
      \   'coc_warning' : 'LightlineCocWarnings'
      \ },
      \ 'component_type':{
      \   'mymodified' : 'error',
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
    autocmd FocusGained * checktime
    autocmd BufEnter * checktime
    " autocmd FocusGained * echo 'FOCUS'
    " autocmd BufEnter * echo 'BUFF'
  augroup END
  function! ModifiedFlag()
    " for some reason it doesn't work with inactive buffers since it always shows
    " the value of the active one.
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
  nmap <leader>gs :G<CR>
  " MERGING get from right side (j is on the right)
  nmap <leader>gj :diffget //3<CR>    
  " MERGING get from left side (f is on the left)
  nmap <leader>gf :diffget //2<CR>
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

" The third component of the holy trinity of plugins 
" (fzf + vimwiki + easymotion)
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'junegunn/fzf.vim'
  " Always enable preview window on the right with 60% width
  " let g:fzf_preview_window = 'right:60%'
  let g:fzf_layout = {'window': {'height':0.8, 'width':0.8, 'border':'sharp'}}
  let $FZF_DEFAULT_OPTS='--reverse --preview-window noborder' " hide broken rounded corners in the inner preview
  let $FZF_DEFAULT_OPTS.=' --bind ctrl-a:select-all,ctrl-d:deselect-all'
  " CTRL-A CTRL-Q to select all and build quickfix list
  " https://github.com/junegunn/fzf.vim/issues/185#issuecomment-322120216
  " Note that g:fzf_action only applies to commands that handle plain file paths (i.e used by fzf#wrap() with arguments without explicit sink). 
  " In other cases, you'll have to implement your own sink function.
  function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
    copen
    cc
  endfunction
  function! MyTest()
    echo "TEST"
    return 4
  endfunction
  " TODO: why does this work also with other function names? for some reason
  " the FuncRef methods always implements populating the quickfix list even
  " setting it to s:test it still populates it
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }
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
  " When fzf starts in a terminal buffer, the file type of the buffer is set to fzf. So you can set up FileType fzf autocmd to
  " customize the settings of the window. For example, if you use the default layout ({'down': '~40%'}) on Neovim, you might
  " want to temporarily disable the statusline for a cleaner look.
  if has('nvim') && !exists('g:fzf_layout')
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  endif
  " =================
  " UTILITY FUNCTIONS
  " =================
  function! GitAwarePath()
    " NOTE: uses FUGITIVE for handling git!
    let root = fnamemodify(get(b:, 'git_dir'), ':h')
    let path = expand('%:p:h')
    if path[:len(root)-1] ==# root
      return root
    endif
    return path
  endfunction
  " from https://coreyja.com/vim-spelling-suggestions-fzf/#fnref-1 
  function! FzfSpellSink(word)
    exe 'normal! "_ciw'.a:word
  endfunction
  function! FzfSpell()
    let suggestions = spellsuggest(expand("<cword>"))
    return fzf#run({'source': suggestions, 'sink': function("FzfSpellSink"), 'down': 10 })
  endfunction
  function! InsertAndMove(text)
    " Insert text at current cursor location and move to end of insert
    let pos = getpos('.')
    let line = getline('.')
    call setline('.', strpart(line, 0, col('.') - 1) . a:text . strpart(line, col('.') - 1))
    let newcol = col('.') + len(a:text)
    let pos[2] = newcol
    call setpos('.', pos)
  endfunction
  " ==================
  " HANDLERS FUNCTIONS
  " ==================
  " receive a list of files from Rg and perform actions on them
  let g:fzf_handler_error = 0
  let g:fzf_handler_msg = ""
  function! Cite_handler(lines)
    " insert citations as [bibID](<path>)
    " handles multiple lines as :
    " [bibID](<path>),[bibID](<path>),[bibID](<path>)...
    " note: skip the first element of a:lines because we ignore ctrl-l
    if a:lines[0] == 'ctrl-l'
      echo a:lines
      return
    endif
    let l:lines = map(copy(a:lines[1:]), {key,val -> split(val,':')[0]})
    if len(l:lines) == 1
      let citation= '[' . GetBibID(l:lines[0]) . '](' . l:lines[0] . ')'
      call InsertAndMove(citation)
    else
      let citation= '[' . GetBibID(l:lines[0]) . '](' . l:lines[0] . ')'
      call InsertAndMove(citation)
      for line in l:lines[1:]
        let citation= ',[' . GetBibID(line) . '](' . line . ')'
        call InsertAndMove(citation)
      endfor
    endif
  endfunction
  function! Rg_handler(lines)
    let l:lines = copy(a:lines)
    let l:filetype = &filetype
    " Ctrl-l is used to reference notes (l->link)
    if l:lines[0] == 'ctrl-l' 
      if len(l:lines) > 2 " only insert link if 1 files is selected, no multiselect
        return
      endif
      if l:filetype == "vimwiki"
        let l:path = split(l:lines[1],":")[0]      
        let l:name = expand('<cWORD>')
        call s:Insert_link(l:name, l:path)
      endif
      return
    else
      let l:lines = l:lines[1:]
    endif
    " If only one file is selected open it, otherwise populate the
    " quickfixlist
    if len(l:lines) == 1
      let l:parts = split(l:lines[0],":")
      let l:file = l:parts[0]
      let l:linenum = l:parts[1]
      cclose
      if fnamemodify(l:file,":p:h") == g:MY_VIMWIKIDIR
        " vimwiki open_link based on the default wiki, no need for full path
        call vimwiki#base#open_link("e",l:file)
      else
        execute "e +" . l:linenum . " " . fnameescape(l:file)
      endif
    else
      let l:lines =  map(l:lines, { key, val -> split(val,":")})
      let l:quickfix = {} " use dictionary to remove duplicates
      for line in l:lines
        if !has_key(l:quickfix, line[0])
          let l:quickfix[line[0]] = l:line
        endif
      endfor
      let l:qflist = map(values(l:quickfix), '{ "filename": v:val[0] , "lnum" : v:val[1] , "text" : join(v:val[3:],"")}')
      call setqflist(l:qflist)
      copen
      cc
    endif
  endfunction
  " ================
  " SEARCH SELECTORS
  " ================
  " return a set of files to be searched, e.g. quickfix files,
  " incoming/outgoing links, buffer history...
  function! Qfix_selector()
    " returns the list of files in the quickfix list, items in the list are
    " assumed to be unique (enforced by populating it with the Rg_handler)
    let files = join(map(getqflist(), {key,val -> split(bufname(val.bufnr),'/')[-1]}))
    return files
  endfunction
  function! Incoming_selector()
    " returns the vimwiki files that contain links to the current file
    let node = expand("%:t")
    let pattern = "\\[.+\\]\\(" . l:node . "\\)"
    let command_fmt = 'rg --no-heading --sortr=modified %s '
    let cmd = printf("cd " . g:MY_VIMWIKIDIR . " && " . command_fmt, shellescape(l:pattern))
    let files = map(split(system(cmd), '\n'), {key,val -> split(v:val,':')[0]})
    if len(files) == 0
      let g:fzf_handler_error = 1
      let g:fzf_handler_msg = "No incoming edges found"
    endif
    return join(UniqList(l:files))
  endfunction
  function! Outgoing_selector()
    " from https://vim.fandom.com/wiki/Copy_search_matches
    " 1. clear register a
    " 2. search for lines matching (title)[year_month_day_id.md]
    " 3. use some vim magic to store the matches in hits
    " normal qaq
    " g/\[.\+\]([0-9]\+_[0-9]\+_[0-9]\+_[a-z0-9]\+.md)/y A
    " let hits = []
    " " how this does what it does is beyond me
    " %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
    let text = join(getline(1,"$"),"\n")
    let pattern = '\[[^\]]\+\]([0-9]\+_[0-9]\+_[0-9]\+_[a-z0-9]\+.md)'
    let hits = AllMatches(l:text, l:pattern)
    let files = map(hits, {key,val -> matchlist(v:val,'\[\([^\]]\+\)\](\([^)]\+\))')[2]})
    if len(files) == 0
      let g:fzf_handler_error = 1
      let g:fzf_handler_msg = "No outgoing edges found"
    endif
    return join(UniqList(l:files))
  endfunction
  " Keep track of buffers visited inside the vimwiki (using a filetype based
  " autocmd)
  let g:buff_hist = []
  let g:buff_hist_size = 50
  function! BuffHist_update()
    let l:bufname = bufname()
    if l:bufname != '' &&  fnamemodify(l:bufname,":p:h") == g:MY_VIMWIKIDIR
      let l:filename = fnamemodify(l:bufname,":t")
      " if the buffer corresponds to a markdown file add it to the list
      " the filetype check should ensure this, but just to be sure
      if len(g:buff_hist) == 0 
        let g:buff_hist = [l:filename]
      elseif l:filename != g:buff_hist[0]
        " avoid adding duplicate entries by leaving/re-entering the same buff
        let g:buff_hist = [l:filename] + g:buff_hist
      endif
      if len(g:buff_hist) > g:buff_hist_size + 1
        " keep buffer list size under control
        let g:buff_hist = g:buff_hist[: g:buff_hist_size]
      endif
    endif
  endfunction
  function! BufHist_selector()
    let l:files_list = ""
    if len(g:buff_hist) < 2
      let g:fzf_handler_error = 1
      let g:fzf_handler_msg = "Not enough files in history."
    else
      let l:files_list = join(g:buff_hist[1:])
    endif
    return l:files_list
  endfunction 
  " ================
  " SEARCH FUNCTIONS
  " ================
  " These functions use FZF only for the interface, they don't perform any
  " fuzzy searching (--phony)
  function! RipgrepFZF(query, fullscreen, sink, files)
    " Adapted from https://github.com/junegunn/fzf.vim#example-advanced-rg-command
    if g:fzf_handler_error
      echohl WarningMsg | echo g:fzf_handler_msg  | echohl None
      let g:fzf_handler_error = 0
      let g:fzf_handler_msg = ""
    else
      " line-number is needed for the preview
      " '|| true' prevents showing 'command failed ...' when nothing is matched
      let command_fmt = 'rg --line-number --with-filename --no-heading --sortr=modified -T jupyter --color=always --smart-case %s %s || true'
      let initial_command = printf(command_fmt, shellescape(a:query), a:files)
      let reload_command = printf(command_fmt, '{q}', a:files)
      let path = GitAwarePath()
      " options = 
      " sink*: function to handle the selected files
      " bind : restart rg search when the typed string changes
      " phony: turns off searching with fzf and lets rg do all the work (o.w.
      " fzf would search in the strings returned by rg)
      " ansi : shows the colored output of rg (--color=always) as actual colors
      let spec = { 
               \ 'source' : initial_command,
               \ 'sink*' : function(a:sink),
               \ 'options':[ '--bind', 'change:reload:' . reload_command,
                           \ '--expect=ctrl-l',
                           \ '--phony',
                           \ '--ansi',
                           \ '--multi'],
               \ 'dir':path
               \ }
      call fzf#run(fzf#wrap(fzf#vim#with_preview(spec)))
    endif
  endfunction
  function! PapersFZF(query, fullscreen, sink)
    " Search with ripgrep only in files that contain the paper tags
    let command_fmt = 'rg \#paper\(-toread\)\?\# -l | xargs rg --line-number --column --color=always --smart-case -- %s || true'
    let initial_command = printf(command_fmt, shellescape(a:query))
    let reload_command = printf(command_fmt, '{q}')
    let spec = {
             \ 'source' : initial_command,
             \ 'sink*': function(a:sink),
             \ 'options':[ '--bind', 'change:reload:'.reload_command,
                         \ '--expect=ctrl-l',
                         \ '--phony',
                         \ '--ansi',
                         \ '--multi'],
             \ 'dir':g:MY_VIMWIKIDIR
             \ }
    call fzf#run(fzf#wrap(fzf#vim#with_preview(spec)))
  endfunction
  " ============
  " FZF COMMANDS
  " ============
  " EXACT SEARCHES
  " These commands use fzf with -phony so all the work is done by ripgrep
  command! -nargs=* -bang Papers call PapersFZF(<q-args>, <bang>0, "Rg_handler") 
  command! -nargs=* -bang Cite call PapersFZF(<q-args>, <bang>0, "Cite_handler") 
  command! -nargs=* -bang MyRg call RipgrepFZF(<q-args>, <bang>0, "Rg_handler", "") 
  command! -nargs=* -bang Qf call RipgrepFZF(<q-args>, <bang>0, "Rg_handler", Qfix_selector()) 
  command! -nargs=* -bang Incoming call RipgrepFZF("^title: ", 0, "Rg_handler", Incoming_selector())
  command! -nargs=* -bang Outgoing call RipgrepFZF("^title: ", 0, "Rg_handler", Outgoing_selector())
  command! -nargs=* -bang History call RipgrepFZF("^title: ", 0, "Rg_handler", BufHist_selector())
  " FUZZY SEARCHES 
  " Other commands use fzf with -phony so all the work is done by ripgrep
  " These commands instead use fzf to fuzzy search in ripgrep's results
  command! -nargs=* -bang Tags
  \ call fzf#vim#grep(
  \   'rg --column --no-line-number --no-heading --sortr=modified --color=always --smart-case -e ^tags: -- ', 1,
  \   fzf#vim#with_preview({'dir' : g:MY_VIMWIKIDIR}), <bang>0)
  " Like rg but with fuzzy finding
  command! -nargs=* -bang FZFrg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --sortr=modified --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'dir' : GitAwarePath()}), <bang>0)  
  " ============
  " FZF MAPPINGS
  " ============
  nnoremap <leader>fd :call FzfSpell()<CR>
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fb :Buffers<CR>
  nnoremap <leader>fl :Lines<CR>
  " Crazy mnemonics here. 
  " frg -> (F)ZF (R)ip(G)rep
  " frf -> (F)ZF (R)ipGrep (F)uzzy
  " frw -> (F)ZF (R)ipGrep current (W)ord
  nnoremap <leader>frg :MyRg<CR>
  nnoremap <leader>frf :FZFrg<CR>
  nnoremap <leader>frw :MyRg <C-R><C-W><CR>
  " Vimwiki specific bindings that use FZF
  function! GoVimwiki_FZF()
    " Mappings start with W for vimwiki, the ones that perform some search
    " then use F, the ones that insert something use I
    " e.g. wft -> vim(W)iki (F)zf    (T)ags
    "      wic -> vim(W)iki (I)nsert (C)itation
    nnoremap <buffer> <leader>wft :Tags<CR>
    nnoremap <buffer> <leader>wfq :Qf<CR>
    nnoremap <buffer> <leader>wfp :Papers<CR>
    nnoremap <buffer> <leader>wfi :Incoming<CR>
    nnoremap <buffer> <leader>wfo :Outgoing<CR>
    nnoremap <buffer> <leader>wih :History<CR>
    nnoremap <buffer> <leader>wic :Cite<CR>
  endfunction
  autocmd! BufEnter *.md call BuffHist_update()

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

" }}}
" ============================================================================
" Basic settings {{{
" ============================================================================

syntax on                              " Enable syntax highlighting
set encoding=utf8
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

let g:python3_host_prog="/home/lapo/miniconda3/envs/neovim3/bin/python"
let g:python_host_prog="/home/lapo/miniconda3/envs/neovim2/bin/python"

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
function! s:ReplaceCoords(insert, pos)
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
function! s:QuickfixNames()
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
command! -nargs=0 -bar Qargs execute 'args ' . s:QuickfixNames()

" Available in tpope/vim-unimpaired's ]e/[e
" function! s:QuickGetLine(off)
"   redraw
"   let l:start = line('.')
"   " Get the line with offset a:off (works for negative values)
"   let l:line = getline(l:start + str2nr(a:off))
"   " Insert that line below the cursor
"   put =l:line
" endfunction
" nnoremap <leader>g :call <SID>QuickGetLine(input('Line to copy: '))<CR>

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
" nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>
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
nnoremap <leader>- :bd<Cr>

" ===================
" INFREQUENT MAPPINGS (use double leader)
" ===================
" insert date
nnoremap <leader><leader>d :execute "normal! i" . strftime('%Y-%m-%d')<CR>
" execute current line in shell and paste results under it
" nmap <leader>e :exec 'r!'.getline('..')<CR>
" execute current line in shell and paste results above it
" nnoremap <leader>ex !!bash<CR>
nnoremap <leader><leader>e !!bash<CR>
" alternate between current file and alternate file
nnoremap <leader><leader>a <C-^> 
" Dictionary (l)ookup
" nnoremap <leader>l :execute "!xdg-open https://www.merriam-webster.com/dictionary/" . expand('<cword>')<CR>
nnoremap <leader><leader>l :execute "!xdg-open \"https://www.dictionary.com/browse/" . expand('<cword>') . "?s=t\""<CR>

" nnoremap <leader>wc :echo wordcount()["words"]<CR>
" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors)
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn

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

" 2020-09-14 : doesn't work in neovim yet https://github.com/neovim/neovim/issues/12330
" Allows you to save files you opened without write permissions via sudo
" cmap w!! w !sudo tee %

" Easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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
nnoremap fj zr
" h is like a stronger j, so it pulls down all the folds, i.e. open all 
nnoremap fh zR
" opposite for up (k) / l  
nnoremap fl zM
nnoremap fk zm
" Open close individual folds
nnoremap fi zc
nnoremap fo zo

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
