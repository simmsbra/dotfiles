" some copied from defaults.vim
set nocompatible

set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set number
set relativenumber
set list
set listchars=tab:>-,trail:~

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2

set wildignorecase

" auto-closing
inoremap " ""<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap < <><left>
