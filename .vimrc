function! MyFoldText()
    " First get the default text from the built-in vim function that is normally
    " used to set the foldtext option
    let result = foldtext()

    " Change the beginning of the text to look like ─┼─── (with a fixed width)
    " instead of +--... (with a variable width due to the number of hyphens
    " representing the fold level). Also, add a space between the ─┼─── and
    " the number of folded lines that comes afterward.
    let result = substitute(result, '^+-\+', '─┼─── ', '')

    " A space between this foldtext and the following fold fillchars looks good
    return result . ' '
endfunction

function! ToggleColorColumn()
    if &colorcolumn
        set colorcolumn=
    else
        set colorcolumn=81
    endif
endfunction

" when using sudoedit, the original filename is not present, so filetype
" detection (for syntax highlighting) based on filename won't work. so here are
" custom rules to detect certain filetypes based on file content.
function! DetectMissingFiletype()
    if &filetype == '' " i only care when vim hasn't detected a filetype
        " if these common apache config patterns are within the first 1024 lines
        let originalCursorPosition = getcurpos()
        call cursor(1, 1)
        if search('<VirtualHost\|<Directory', 'cn', 1024) != 0
            set filetype=apache
        endif
        call setpos('.', originalCursorPosition)
    endif
endfunction
autocmd VimEnter * :call DetectMissingFiletype()


set nocompatible

" display stuff
set showcmd
set laststatus=2 " always show status line, even if there's only one window open
set ruler
set number relativenumber
set list listchars=tab:>-,trail:~,extends:>,precedes:<
" remove | characters from vertical splits
" make hyphens after foldtext be full-width bars so they connect to eachother
set fillchars=vert:\ ,fold:─
set foldtext=MyFoldText()
set hlsearch
" abort highlighting matching paren-like characters if it's producing a
" noticeable slowdown. this slowdown can happen when moving the cursor over a
" large fold surrounded by matching brackets
let g:matchparen_timeout=4
" the constant 81 is repeated in the ToggleColorColumn, but that's ok
set colorcolumn=81
if &diff
    " syntax highlighting looks horrible when combined with the diff colors
    syntax off
else
    syntax on
endif
colorscheme portal
" no special styling of certain HTML tags. for example, <em> text being highlit
let html_no_rendering=1

" this block is related to indentation (using 4 spaces)
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set shiftround
" use smaller indentations for HTML, since it usually has lots of nesting
autocmd FileType html setlocal shiftwidth=2 tabstop=2
" automatically fold files based on indentions
set foldmethod=indent
" by default, lines that start with a # are treated differently during indent
" folding (foldignore="#"). don't do that -- treat no lines specially.
set foldignore=""

" misc
set history=500 " 10 times the default of 50
set wildmenu
set wildignorecase
set mouse=

" behavior of certain actions
set backspace=indent,eol,start
" excludes 'hor' so that horizontal movement commands don't open folds
set foldopen=block,mark,percent,quickfix,search,tag,undo

" mappings for frequently used actions
nnoremap <Space> <Nop>
:let mapleader = " "
nnoremap <Leader>o o<Esc>k
nnoremap <Leader>w :write<CR>
" turn off search highlighting
nnoremap <Leader>n :nohlsearch<CR>
" make n only jump to the next result when search results are being highlit.
" this way i don't get teleported out of what i'm doing if i accidentally hit n.
" i'd like to make the false value <Nop> for semantic purposes, but that doesn't
" seem to work for mappings with expressions, so an empty string does the job.
" also, the zv in the mapping just reinstates the default behavior of opening
" folds when going to the next search result -- see :h 'foldopen'
nnoremap <expr> n (v:hlsearch) ? "nzv" : ""
" refresh the syntax highlighting for when its parsing gets messed up.
" also fix indent folds when they get broken due to a vim bug (using the
" workaround shown here: https://github.com/vim/vim/issues/3214#issue-341341390)
nnoremap <Leader>s :set foldignore=""<CR>:syntax sync fromstart<CR>
" toggle line numbers so can highlight text with mouse (for copying) without
" also selecting the line number text
nnoremap <Leader>u :set number! relativenumber!<CR>
inoremap ,t <Esc>
vnoremap ,t <Esc>
nnoremap ,t <Nop>
inoremap <C-n> <C-p>
inoremap <C-p> <C-n>
" i want to be able to do one normal mode command, like p, while in insert mode
" but without losing my current identation. this can be done with the action of
" <C-\><C-o> but <C-o> is easier to type
inoremap <C-o> <C-\><C-o>
" like zt, but leave some more lines above the cursor
nnoremap ze zt5<C-y>
vnoremap ze zt5<C-y>
" remove trailing whitespace from the lines in the current visual selection
vnoremap <Leader>l :s/\s\+$//e<CR>

" mappings for less frequently used actions
set pastetoggle=<F2>
noremap Q :call ToggleColorColumn()<CR>
" insert current datestamp
inoremap <F3> <C-R>=strftime("%Y-%m-%d")<CR>

" C-like flow control block snippets
inoremap {if if () {<CR>}<Esc>kf(a
inoremap {el if () {<CR>} else {<CR>}<Esc>kkf(a
inoremap {ie if () {<CR>} else if () {<CR>} else {<CR>}<Esc>kkkf(a
inoremap {f for () {<CR>}<Esc>kf(a
inoremap {fe foreach () {<CR>}<Esc>kf(a
