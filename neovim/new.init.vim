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

source ~/.config/nvim/settings.vim
source ~/.config/nvim/mappings.vim
source ~/.config/nvim/plugins.vim


let g:python3_host_prog="~/miniconda3/envs/neovim3/bin/python"
let g:python_host_prog="~/miniconda3/envs/neovim2/bin/python"

function! StatuslineCheck() abort
	let focused = g:statusline_winid == win_getid(winnr())
	return focused ? '%#StatusLine#' : '%#StatusLineNC#'
endfunction

" At the bottom to override themes and shit
function s:PatchColors()
  " Use terminal background color to customize (no more trying to match both
  " because of vim's uneven borders)
  hi Normal guibg=NONE ctermbg=NONE
  " Give VimWiki links a nice light blue colors
  hi VimwikiLink ctermfg=39 cterm=underline
  " Make LSP.hints (gutter and virtual text) less of a punch in the eye
  hi DiagnosticHint ctermfg=241 guifg=DarkGray
  " https://github.com/neovim/nvim-lspconfig/issues/379#issuecomment-707803645
  " Not sure why I need to define these myself but whatever, now cursorhold=highlights
  hi LspReferenceText  ctermfg=40    ctermbg=236
  hi LspReferenceRead  ctermfg=40    ctermbg=236
  hi LspReferenceWrite ctermfg=40    ctermbg=236
  hi StatusLine        ctermfg=209   ctermbg=236
  hi StatusLineNC      ctermfg=240   ctermbg=234
endfunction


autocmd! ColorScheme onedark call s:PatchColors()
colorscheme onedark
set background=dark " Because dark is cool

autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()

" lua require('main')
