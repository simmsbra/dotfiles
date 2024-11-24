" here is the set of colors i've been using. i think most of them are from the
" Breeze colorscheme (of Konsole)
let s:colorBlack   = "#131313" " 0
let s:colorRed     = "#c0392b" " 1
let s:colorGreen   = "#1cdc9a" " 2
let s:colorYellow  = "#fdbc4b" " 3
let s:colorBlue    = "#3daee9" " 4
let s:colorMagenta = "#8e44ad" " 5
let s:colorCyan    = "#16a085" " 6
let s:colorWhite   = "#e0e2ea" " 7 NvimLightGrey2
let s:colorIntenseBlack   = "#000000" " 0
let s:colorIntenseRed     = "#ed1515" " 1
let s:colorIntenseGreen   = "#11d116" " 2
let s:colorIntenseYellow  = "#f67400" " 3
let s:colorIntenseBlue    = "#1d99f3" " 4
let s:colorIntenseMagenta = "#9b59b6" " 5
let s:colorIntenseCyan    = "#1abc9c" " 6
let s:colorIntenseWhite   = "#ffffff" " 7
let s:background = s:colorBlack
let s:foreground = s:colorWhite

let g:colors_name = "portal"

execute "highlight Normal guibg=" .. s:background .. " guifg=" .. s:foreground
" matches line numbers
execute "highlight Folded guibg=" .. s:background .. " guifg=NvimDarkGrey4"
execute "highlight Constant guifg=" .. s:colorRed
execute "highlight String guifg=" .. s:colorRed
execute "highlight Comment guifg=" .. s:colorIntenseMagenta
execute "highlight Identifier guifg=" .. s:colorCyan
highlight Special guifg=#ffb3b3
execute "highlight Statement guifg=" .. s:colorYellow
execute "highlight Todo guibg=" .. s:colorYellow .. " guifg=" .. s:background
execute "highlight Type guifg=" .. s:colorBlue

" without this, the prob is that, when visually selecting folds, the fold text
" color is the same as the fold background color, so you can't read it. i'm
" trying this out for a while. although this essentially removes all syntax
" highlighting for visually-selected things
execute "highlight Visual guibg=NvimDarkGrey4 guifg=" .. s:foreground
