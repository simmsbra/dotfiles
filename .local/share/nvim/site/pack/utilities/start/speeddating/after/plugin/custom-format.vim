" i'm wrapping this in a conditional so that it doesn't error out if you don't
" have the speeddating plugin installed
if exists(":SpeedDatingFormat")
    " note that had to add %* at the end to make the parentheses work:
    " https://github.com/tpope/vim-speeddating/issues/3
    1SpeedDatingFormat %Y-%m-%d (%a)%*
endif
