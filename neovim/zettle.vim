
" =========================================================
" ======================== VIMWIKI ========================
" =========================================================

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
  " video link       [title](storage/name.mp4)
  " markdown image  ![title](assets/name.{jpg|png|jpeg})
  " pdf              [title](assets/name.pdf})
  let l:match = matchlist(l:word ,'\!\?[.\+\](\([assets\|storage\/.\+\))')
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
    let l:vid_title = trim(system("youtube-dlc -e " . shellescape(l:url)))
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
    call ReplaceCoords('['.a:name.']('.a:path.')',l:pos)
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
      call ReplaceCoords(l:new, l:old)
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
      call ReplaceCoords(l:new, l:old)
      return
    endif
  endif
  echo "No match found"
  return
endfunction
let g:stream_patterns = "youtu\\.be\\|www\\.youtube\\.com\\|vimeo\\.com"
function! Backup_stream(url)
  " Convert youtube URLs to links and backup content
  " https://youtu.be/rbfFt2uNEyQ?t=5478           -> [video](storage/init_5f4e7.mp4)
  " https://www.youtube.com/watch?v=Z_MA8CWKxFU   -> [video](storage/init_f5913.mp4)
  " [test 1](https://youtu.be/rbfFt2uNEyQ?t=5478) -> [test 1](storage/init_f5782.mp4)
  " [test 2](https://www.youtube.com/watch?v=Z_U) -> [test 2](storage/init_ee172.mp4)
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
      let l:link = "storage/" . l:md5 . ".mp4"
      let l:cmd_mv = 'mv ' . l:temp . " " . g:MY_VIMWIKIDIR . "/" . l:link
      echo "Calculating md5..."
      call system(l:cmd_mv)
      echo "Done."
    endif
    return l:link
  else
    echo "Video not found."
    return ""
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



" =========================================================
" =========================== FZF =========================
" =========================================================

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
  if a:lines[0] == 'ctrl-i'
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
  if l:lines[0] == 'ctrl-i'
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
                         \ '--expect=ctrl-i',
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
                       \ '--expect=ctrl-i',
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

