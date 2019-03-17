source $VIMRUNTIME/defaults.vim

set number
set relativenumber
set list
set listchars=tab:>-,trail:~

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set wildignorecase

autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
