" see available colors:
" :run syntax/colortest.vim

let g:colors_name="portal"

set background=dark

highlight clear

highlight Normal cterm=None ctermbg=Black ctermfg=White
highlight Folded cterm=None ctermbg=Black ctermfg=DarkGrey
highlight ColorColumn cterm=None ctermbg=DarkGrey ctermfg=White
" hide the ~ chars that appear under the last line of a buffer
highlight EndOfBuffer cterm=None ctermfg=bg
highlight StatusLineNC cterm=reverse ctermbg=None ctermfg=None
highlight StatusLine cterm=None ctermbg=Cyan ctermfg=bg

highlight PmenuSel cterm=None ctermbg=fg ctermfg=bg

highlight Constant cterm=None ctermfg=Red
highlight Comment cterm=None ctermfg=Magenta

highlight Visual cterm=reverse ctermbg=None ctermfg=None

" vim defaults this to bold, which was messing with my colors
highlight Identifier cterm=None
