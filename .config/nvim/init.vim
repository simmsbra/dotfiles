" opens up the command-line-window and constructs a :let @a="" command for
" editing whichever macro register letter is given. just edit the macro text and
" then hit enter. note that you'll have to escape " characters; and if you want
" to insert a special character, you can use C-v
function! OpenMacroForEditing(registerLetter)
    " to insert the macro register's literal text into the command, <C-r><C-o>
    " (:h i_CTRL-R_CTRL-O) is used. but that wouldn't escape any double quotes,
    " so instead of putting the macro's register letter right after <C-r><C-o>,
    " we use the expression register (:h @=) to insert the result of escaping
    " any double quotes within the macro register's contents
    call feedkeys(
        \ "q:"
        \ .. "i"
        \ .. ":let @" .. a:registerLetter .. "="
        \ .. '"'
        \ .. "\<C-r>\<C-o>=escape(@" .. a:registerLetter .. ", '\"')\<CR>"
        \ .. '"'
        \ .. "\<Esc>"
    \ )
endfunction

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

" having these 2 functions is kind of verbose but i don't want to have to
" duplicate the literal colorcolumn value anywhere
function! ColorColumnOn()
    set colorcolumn=81
endfunction
function! ColorColumnOff()
    set colorcolumn=
endfunction
" this func is used by a mapping further below
function! ToggleColorColumn()
    if &colorcolumn
        call ColorColumnOff()
    else
        call ColorColumnOn()
    endif
endfunction
function! InitializeColorColumnBasedOnFileType()
    " if filename ends with .txt
    " :h filename-modifiers to learn about %:e
    if expand('%:e') ==# "txt"
        call ColorColumnOff()
    else
        call ColorColumnOn()
    endif
endfunction
" start with color column on unless the filename ends with .txt
" i'm not checking if vim's &filetype is 'text' because i don't want color
" column to be off if vim doesn't know the filetype and defaults it to 'text'
" -- for example, in my .aliases file
autocmd VimEnter,BufReadPre * :call InitializeColorColumnBasedOnFileType()

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

" if the file is short enough, don't have anything folded. vim can't know the
" character height of your terminal, so i'm just using a heuristic-y value
function! UnfoldFoldsIfFileIsShortEnoughToFitOnScreen()
    let maxAmountOfLinesDisplayable = 41
    if line("$") <= maxAmountOfLinesDisplayable
        normal zR
    endif
endfunction
autocmd BufReadPost * :call UnfoldFoldsIfFileIsShortEnoughToFitOnScreen()

" paste clipboard content under current line while keeping the indentation level
" of the current line (indentation within the clipboard content is preserved)
function! PasteBlockFromClipboardAtCurrentIndentationLevel()
    " indentation level of current line, in spaces
    let indentationLevel = indent(line('.'))
    " put clipboard (+ register) contents under current line
    put +
    " indent the pasted block by using visual block mode to insert spaces the
    " '[ and '] are automatic marks that vim sets for the previously changed
    " text (in this case our pasted block)
    call feedkeys("'[\<C-v>']I" .. repeat(" ", indentationLevel) .. "\<Esc>")
    " cursor will be all the way left, so move it to the first char of the line
    call feedkeys("^")
endfunction


" ---------- Display Stuff ----------
set number relativenumber
set list listchars=tab:>-,trail:~,extends:>,precedes:<
" abort highlighting matching paren-like characters if it's producing a
" noticeable slowdown. this slowdown can happen when moving the cursor over a
" large fold surrounded by matching brackets
let g:matchparen_timeout=4
if &diff
    " syntax highlighting looks horrible when combined with the diff colors
    syntax off
else
    syntax on
endif
colorscheme portal
" no special styling of certain HTML tags. for example, <em> text being highlit
let html_no_rendering=1
" remove | characters from vertical splits
" make hyphens after foldtext be full-width bars so they connect to eachother
set fillchars=vert:\ ,fold:─
set foldtext=MyFoldText()

" ---------- Folding ----------
" automatically fold files based on indentions
set foldmethod=indent
" by default, lines that start with a # are treated differently during indent
" folding (foldignore="#"). don't do that -- treat no lines specially.
set foldignore=""
" excludes 'hor' so that horizontal movement commands don't open folds
set foldopen=block,mark,percent,quickfix,search,tag,undo

" ---------- Indentation ----------
filetype indent off
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
" use smaller indentations for HTML, since it usually has lots of nesting
autocmd FileType html setlocal shiftwidth=2 tabstop=2

" ---------- Misc ----------
set wildignorecase

" ---------- Custom Mappings ----------
nnoremap <Space> <Nop>
:let mapleader = " "
nnoremap <Leader>o o<Esc>k
nnoremap <Leader>w :write<CR>
" turn off search highlighting
nnoremap <Leader>n :nohlsearch<CR>
" refresh the syntax highlighting for when its parsing gets messed up.
" also fix indent folds when they get broken due to a vim bug (using the
" workaround shown here: https://github.com/vim/vim/issues/3214#issue-341341390)
nnoremap <Leader>s :set foldignore=""<CR>:syntax sync fromstart<CR>
" toggle line numbers so can highlight text with mouse (for copying) without
" also selecting the line number text
nnoremap <Leader>u :set number! relativenumber!<CR>
" easier way to escape insert mode than using pinky
inoremap ,t <Esc>
vnoremap ,t <Esc>
nnoremap ,t <Nop>
" copy into X's clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
" paste clipboard register under current line while keeping the current
" indentation level. this mapping is intended to make it easy to paste multiline
" clipboard contents with proper indentation (both of the content and of our
" current indentation level). for non-multiline contents, you can still just do
" ctrl-shift-v in insert mode
nnoremap <Leader>p :call PasteBlockFromClipboardAtCurrentIndentationLevel()<CR>
" like zt, but leave some more lines above the cursor
nnoremap ze zt5<C-y>
vnoremap ze zt5<C-y>
" remove trailing whitespace from the lines in the current visual selection.
" substitution leaves any pattern results in the document highlit, so turn off
" highlighting afterward.
vnoremap <Leader>l :s/\s\+$//e<CR>:nohlsearch<CR>
" move cursor to column 80. i frequently have to do this to split long lines
nnoremap <Leader>8 80<Bar>
" easier way (in terms of typing) to call a macro. originally had this on the q
" key, but that was bad because if i messed up typing it, i'd end up editing the
" macro that i wanted to run and would have to recreate the macro
nnoremap <Leader>m @
" easier way to reload this config file (especially when making edits to it)
nnoremap <Leader>f :source ~/.config/nvim/init.vim<CR>
" editing a macro by pasting it into your buffer and then yanking it back into
" the register does not work well, especially if there are things like newlines
" in your macro. so the better way is to use a command like :let @a=''
" this mapping does most of the lifting for you so that you can just start
" editing the macro text right away without first constructing that command.
for letter in split('a b c d e f g h i j k l m n o p q r s t u v w x y z')
    execute 'nnoremap'
    \   .. '<Leader>q' .. letter
    \   .. ' :call OpenMacroForEditing("' .. letter .. '")<CR>'
endfor
" quick way to surround an entire line with parentheses
nnoremap <Leader>( I(<Esc>A)<Esc>^
" :help opens in a horizontal orientation, but i like it vertical
" https://stackoverflow.com/a/630913
cabbrev h vert help
" quick way to toggle color column
noremap Q :call ToggleColorColumn()<CR>
" insert current datestamp
inoremap <F3> <C-R>=strftime("%Y-%m-%d")<CR>

" ---------- Mappings that Override Default Actions ----------
" make n only jump to the next result when search results are being highlit.
" this way i don't get teleported out of what i'm doing if i accidentally hit n.
" i'd like to make the false value <Nop> for semantic purposes, but that doesn't
" seem to work for mappings with expressions, so an empty string does the job.
" also, the zv in the mapping just reinstates the default behavior of opening
" folds when going to the next search result -- see :h 'foldopen'
nnoremap <expr> n (v:hlsearch) ? "nzv" : ""
" make sure that after using zv, the line is vertically centered in the view
nnoremap zv zvzz
" swap C-n and C-p because n is easier to type but 'previous' is the action
" that i usually want because i want to use an identifier seen above in the file
inoremap <C-n> <C-p>
inoremap <C-p> <C-n>
" i want to be able to do one normal mode command, like p, while in insert mode
" but without losing my current identation. this can be done with the action of
" <C-\><C-o> but <C-o> is easier to type
inoremap <C-o> <C-\><C-o>

" ---------- Flow Control Block Snippets ----------
inoremap {if if () {<CR>}<Esc>kf(a
inoremap {el if () {<CR>} else {<CR>}<Esc>kkf(a
inoremap {ie if () {<CR>} else if () {<CR>} else {<CR>}<Esc>kkkf(a
inoremap {f for () {<CR>}<Esc>kf(a
inoremap {fe foreach () {<CR>}<Esc>kf(a
inoremap {tc try {<CR>} catch () {<CR>}<Esc>kf(a
