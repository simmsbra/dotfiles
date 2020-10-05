" I'm using color codes instead of color names because using color names can
" cause weird things. The following is copied from :help highlight-ctermfg
"
" NR-16   COLOR NAME
" 0       Black
" 1       DarkBlue
" 2       DarkGreen
" 3       DarkCyan
" 4       DarkRed
" 5       DarkMagenta
" 6       Brown, DarkYellow
" 7       LightGray, LightGrey, Gray, Grey
" 8       DarkGray, DarkGrey
" 9       Blue, LightBlue
" 10      Green, LightGreen
" 11      Cyan, LightCyan
" 12      Red, LightRed
" 13      Magenta, LightMagenta
" 14      Yellow, LightYellow
" 15      White
let g:colors_name="portal"

set background=dark

highlight clear

highlight Normal cterm=None ctermbg=0 ctermfg=15
highlight Folded cterm=None ctermbg=0 ctermfg=8
highlight ColorColumn cterm=None ctermbg=8 ctermfg=15
" hide the ~ chars that appear under the last line of a buffer
highlight EndOfBuffer cterm=None ctermfg=bg
highlight StatusLineNC cterm=reverse
" if this is not subtle enough, LightMagenta or LightCyan are good alternatives
highlight StatusLine cterm=None ctermbg=10 ctermfg=bg

highlight PmenuSel cterm=None ctermbg=fg ctermfg=bg
