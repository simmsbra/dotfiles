set nocompatible

" display stuff
set ruler
set number
set relativenumber
set list
set listchars=tab:>-,trail:~,extends:>,precedes:<
set hlsearch
set colorcolumn=81
syntax on
colorscheme pablo
highlight Folded ctermbg=None ctermfg=DarkGrey
highlight ColorColumn ctermbg=DarkMagenta ctermfg=White

" this block is related to indentation (using 4 spaces)
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
" use smaller indentations for HTML, since it usually has lots of nesting
autocmd FileType html setlocal shiftwidth=2 tabstop=2

" misc
set wildmenu
set wildignorecase
set showcmd
set mouse=

" behavior of certain actions
set backspace=indent,eol,start

" mappings for frequently used actions
nmap ;w :write<CR>
nmap ;n :nohlsearch<CR>
nmap ;s :syntax sync fromstart<CR>
imap ,t <Esc>
vmap ,t <Esc>
nmap ,t <Nop>
inoremap <C-n> <C-p>
inoremap <C-p> <C-n>

" mappings for less frequently used actions
set pastetoggle=<F2>
noremap Q :set colorcolumn=<CR>
noremap <F3> :set foldmethod=indent<CR>

" C-like flow control block snippets
imap {if if () {<CR>}<Esc>kf(a
imap {el if () {<CR>} else {<CR>}<Esc>kkf(a
imap {ie if () {<CR>} else if () {<CR>} else {<CR>}<Esc>kkkf(a
imap {f for () {<CR>}<Esc>kf(a
imap {fe foreach () {<CR>}<Esc>kf(a
