set nocompatible

" display stuff
set showcmd
set ruler
set number relativenumber
set list listchars=tab:>-,trail:~,extends:>,precedes:<
" remove | characters from vertical splits
" make hyphens after foldtext be full-width bars so they connect to eachother
set fillchars=vert:\ ,fold:─
" change the beginning of folds to look like ─┼──... instead of +--...
set foldtext=MyFoldText()
function! MyFoldText()
    " First get the default text from the built-in vim function that is normally
    " used to set the foldtext option
    let result = foldtext()

    " Replace the - chars that immediately follow the + with ─ chars.
    " The regex matches any - char that has the following right before it:
    " beginning of string, + char, zero or more - chars
    " The ()@<= thing is called, in regex terms, a positive lookbehind
    let result = substitute(result, '\(^+-*\)\@<=-', '─', 'g')
    " Replace the first + at the beginning of the text with ─┼
    let result = substitute(result, '^+', '─┼', '')

    " A space between this foldtext and the following fold fillchars looks good
    return result . ' '
endfunction
set hlsearch
" abort highlighting matching paren-like characters if it's producing a
" noticeable slowdown. this slowdown can happen when moving the cursor over a
" large fold surrounded by matching brackets
let g:matchparen_timeout=4
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
set mouse=

" behavior of certain actions
set backspace=indent,eol,start

" mappings for frequently used actions
nmap ;w :write<CR>
nmap ;n :nohlsearch<CR>
nmap ;s :syntax sync fromstart<CR>
" toggle line numbers so can highlight text with mouse (for copying) without
" also selecting the line number text
nmap ;u :set number! relativenumber!<CR>
imap ,t <Esc>
vmap ,t <Esc>
nmap ,t <Nop>
inoremap <C-n> <C-p>
inoremap <C-p> <C-n>
" i want to be able to do one normal mode command, like p, while in insert mode
" but without losing my current identation. this can be done with the action of
" <C-\><C-o> but <C-o> is easier to type
inoremap <C-o> <C-\><C-o>

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
