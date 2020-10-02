let g:colors_name="portal"

set background=dark

highlight clear

highlight Normal ctermbg=Black ctermfg=White
highlight Folded ctermbg=Black ctermfg=DarkGrey
highlight ColorColumn ctermbg=DarkGrey ctermfg=White
" hide the ~ chars that appear under the last line of a buffer
highlight EndOfBuffer ctermfg=bg
highlight StatusLineNC cterm=reverse
" if this is not subtle enough, LightMagenta or LightCyan are good alternatives
highlight StatusLine cterm=None ctermbg=LightGreen ctermfg=bg
