" here is the set of colors i've been using. they were a color scheme of the
" terminal emulator i used to use, but i can't remember which
" #131313
" #ed1515
" #11d116
" #f67400
" #1d99f3
" #9b59b6
" #1abc9c
" #fcfcfc
"
" #7f8c8d
" #c0392b
" #1cdc9a
" #fdbc4b
" #3daee9
" #8e44ad
" #16a085
" #ffffff

let g:colors_name="portal"

highlight Normal guibg=#131313 guifg=NvimLightGrey2
highlight Folded guibg=#131313 guifg=NvimDarkGrey4 " matches line numbers
highlight Constant guifg=#c0392b
highlight String guifg=#c0392b
highlight Comment guifg=#9b59b6
highlight Identifier guifg=#16a085
highlight Special guifg=#ffb3b3
highlight Statement guifg=#fdbc4b
highlight Todo guibg=#fdbc4b guifg=#131313
highlight Type guifg=#3daee9

" without this, the prob is that, when visually selecting folds, the fold text
" color is the same as the fold background color, so you can't read it. i'm
" trying this out for a while. although this essentially removes all syntax
" highlighting for visually-selected things
highlight Visual guibg=NvimDarkGrey4 guifg=NvimLightGrey2
