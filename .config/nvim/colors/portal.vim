" here is the set of colors i've been using. i think most of them are from the
" Breeze colorscheme (of Konsole)
let s:colorBlack   = "#131313" " 0
let s:colorRed     = "#e7301b" " 1
let s:colorGreen   = "#1cdc9a" " 2
let s:colorYellow  = "#fdbc4b" " 3
let s:colorBlue    = "#3daee9" " 4
let s:colorMagenta = "#9c4abf" " 5
let s:colorCyan    = "#16a085" " 6
let s:colorWhite   = "#e0e2ea" " 7 NvimLightGrey2
let s:colorIntenseBlack   = "#000000" " 0
let s:colorIntenseRed     = "#ed1515" " 1
let s:colorIntenseGreen   = "#11d116" " 2
let s:colorIntenseYellow  = "#f67400" " 3
let s:colorIntenseBlue    = "#1d99f3" " 4
let s:colorIntenseMagenta = "#a968c3" " 5
let s:colorIntenseCyan    = "#1abc9c" " 6
let s:colorIntenseWhite   = "#ffffff" " 7
let s:background = s:colorBlack
let s:foreground = s:colorWhite

let g:colors_name = "portal"

execute "highlight Normal guibg=" .. s:background .. " guifg=" .. s:foreground
" matches line numbers
execute "highlight Folded guibg=" .. s:background .. " guifg=NvimDarkGrey4"
highlight LineNr guifg=NvimLightGrey4
" give all visually-selected things a readable color combo with no syntax
" highlighting. this solves problems like when visually selecting folds'
" text color is the same as the fold background color, making them unreadable
execute "highlight Visual guibg=NvimDarkGrey4 guifg=" .. s:foreground

execute "highlight Constant guifg=" .. s:colorRed
execute "highlight String guifg=" .. s:colorRed
execute "highlight Comment guifg=" .. s:colorIntenseMagenta
execute "highlight Identifier guifg=" .. s:colorCyan
highlight Special guifg=#ffb3b3
execute "highlight Statement guifg=" .. s:colorYellow
execute "highlight Todo guibg=" .. s:colorYellow .. " guifg=" .. s:background
execute "highlight Type guifg=" .. s:colorBlue

" use the same colors for terminal mode
let g:terminal_color_0 = s:colorBlack
let g:terminal_color_1 = s:colorRed
let g:terminal_color_2 = s:colorGreen
let g:terminal_color_3 = s:colorYellow
let g:terminal_color_4 = s:colorBlue
let g:terminal_color_5 = s:colorMagenta
let g:terminal_color_6 = s:colorCyan
let g:terminal_color_7 = s:colorWhite
let g:terminal_color_8 = s:colorIntenseBlack
let g:terminal_color_9 = s:colorIntenseRed
let g:terminal_color_10 = s:colorIntenseGreen
let g:terminal_color_11 = s:colorIntenseYellow
let g:terminal_color_12 = s:colorIntenseBlue
let g:terminal_color_13 = s:colorIntenseMagenta
let g:terminal_color_14 = s:colorIntenseCyan
let g:terminal_color_15 = s:colorIntenseWhite
