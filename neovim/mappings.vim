" ============================================================================
"   LEADER
" ============================================================================

" Set space as leader
" Space acts as a fucking step to the right so we need to unmap it
noremap <Space> <Nop>
sunmap <Space>
" mapleader has to be up here because it works only on what comes after
let mapleader=' '
let maplocalleader=' '
" DISABLE FUCKING EXMODE UNTIL I FIND A BETTER USE FOR Q
nmap Q <Nop>
" Save/close
nnoremap <Leader>s :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <leader>- :bd<Cr>
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

" Vim's (d)elete is more like a cut.
" use leader d to really delete something, i.e. cut to blackhole register _
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

" alternate between current file and alternate file
nnoremap <leader><leader>a <C-^>

" open current file at current position in visual studio code, the double
" getpos is ugly as fuck but... na mindegy
nnoremap <silent> <leader><leader>vs :exec '! code --goto ' . expand('%:p') . ':' . getpos('.')[1] . ':' . getpos('.')[2]<CR>

" ============================================================================
"   GENERIC
" ============================================================================

" Type a replacement term and press . to repeat the replacement again. Useful
" for replacing a few instances of the term (comparable to multiple cursors)
nnoremap <silent> s* :let @/='\<'.expand('<cword>').'\>'<CR>cgn

" Remap VIM 0 to first non-blank character
map 0 ^

" convenient mapping to quickly correct the last spelling mistake while in
" inser mode. Requires :set spell
inoremap <C-f> <c-g>u<Esc>[s1z=`]a<c-g>u

" ============================================================================
"   UNUSED
" ============================================================================
 
" https://salferrarello.com/vim-close-all-buffers-except-the-current-one/
" command! Bonly execute '%bdelete|edit #|normal `"'

" execute current line in shell and paste results above it
" nnoremap <leader><leader>ex !!bash<CR>

" Dictionary (l)ookup
" nnoremap <leader>l :execute "!xdg-open https://www.merriam-webster.com/dictionary/" . expand('<cword>')<CR>
" nnoremap <leader><leader>l :execute "!xdg-open \"https://www.dictionary.com/browse/" . expand('<cword>') . "?s=t\""<CR>
