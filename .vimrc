" some copied from defaults.vim
set nocompatible

set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set number
set relativenumber
set list
set listchars=tab:>-,trail:~
set colorcolumn=81
highlight ColorColumn ctermbg=5
set mouse=

set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2

set wildignorecase

nmap ;w :w<CR>
noremap Q :set colorcolumn=<CR>
imap .t <Esc>
vmap .t <Esc>

" C-like flow control block snippets
imap {if if () {<CR>}<Esc>kf(a
imap {f for () {<CR>}<Esc>kf(a
imap {fe foreach () {<CR>}<Esc>kf(a
