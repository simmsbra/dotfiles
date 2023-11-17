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

" Return a foldtext that has a smaller minimum width, that looks cooler, and
" that uses spacing to align the line text with the unfolded line text if
" possible -- this results in the fact that when you unfold the fold, the line
" text is in the same place.
"
" Examples:
"      Default Foldtext: │+--298 lines: text of line with foldlevel 1
"           My Foldtext: │──298──── text of line with foldlevel 1
"              Unfolded: │    text of line with foldlevel 1
"                        │
"      Default Foldtext: │+------  3 lines: text of line with foldlevel 5
" My (Aligned) Foldtext: │──────────────3──── text of line with foldlevel 5
"              Unfolded: │                    text of line with foldlevel 5
function! MyFoldText()
    let result = foldtext() " Start with the default foldtext.

    " Change the beginning of the text to look like ── (with a fixed width)
    " instead of +--... (with a variable width due to the number of hyphens
    " representing the fold level).
    let result = substitute(result, '^+-\+', '──', '')
    " Replace any padding spaces in the number of folded lines with '─'s.
    " The pattern matches any space character whose prefix is [the beginning
    " of the line then [1 or more '─'s] then [0 or more spaces]] and whose
    " suffix is [[0 or more spaces] then a digit].
    " The '()@<=' is a positive lookbehind. The '()@=' is a positive lookahead.
    let result = substitute(result, '\(^─\+ *\)\@<= \( *[0-9]\)\@=', '─', 'g')
    let result = substitute(result, ' line[s]*: ', '──── ', '')

    " If the folded line is indented more than the width of the foldtext prefix,
    " then add spacing characters to align them.
    let numberOfSpacesFoldIsIndented = v:foldlevel * &shiftwidth
    " 1234567890
    " ──999──── text of line
    let widthOfPrefix = 10
    if numberOfSpacesFoldIsIndented > widthOfPrefix
        let spacing = repeat('─', numberOfSpacesFoldIsIndented - widthOfPrefix)
        let result = spacing . result
    endif

    " A space between this foldtext and the following fold fillchars looks good.
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
autocmd BufReadPre * :call InitializeColorColumnBasedOnFileType()

" when using sudoedit, the original filename is not present, so filetype
" detection (for syntax highlighting) based on filename won't work correctly. so
" here are custom rules to detect certain filetypes based on file content.
function! DetectMissingFiletype()
    if (&filetype == '') || (&filetype == 'conf')
        let originalCursorPosition = getcurpos()
        call cursor(1, 1)
        " if these common apache config patterns are within the first 1024 lines
        if search('<VirtualHost\|<Directory', 'cn', 1024) != 0
            set filetype=apache
        elseif search('listen 80;', 'cn', 1024) != 0
            set filetype=nginx
        endif
        call setpos('.', originalCursorPosition)
    endif
endfunction
autocmd VimEnter * :call DetectMissingFiletype()

" if the file is short enough to fit entirely on screen, open all folds
function! UnfoldFoldsIfFileIsShortEnoughToFitOnScreen()
    let maxAmountOfLinesDisplayable = winheight(0)
    if line("$") <= maxAmountOfLinesDisplayable
        normal! zR
    endif
endfunction
autocmd BufReadPost * :call UnfoldFoldsIfFileIsShortEnoughToFitOnScreen()

" shift (indent) the previously changed lines (can be pasted lines) by the
" number of shifts given. for example, if you pass 2 and your shiftwidth is
" set to 4, then the block would be indented 8 characters. a negative number
" shifts left
function! IndentPreviouslyChangedBlock(numberOfShifts)
    let shouldShiftLeft = a:numberOfShifts < 0
    for shiftNumber in range(abs(a:numberOfShifts))
        " use the > or < action with a range to shift the block. the '[ and ']
        " are marks that vim automatically sets for the previously changed
        " lines. use zv to make sure that the first line of the changed block is
        " not folded, because otherwise the entire fold will be shifted
        call feedkeys("'[zvV']" .. (shouldShiftLeft ? "<" : ">"))
        " the more simple way to write this is using only an ex command:
        " exec "'[,']" .. (shouldShiftLeft ? "<" : ">")
        " but when done that way, you can't use . to repeat the action
    endfor
endfunction

" paste clipboard content under the current line at the same indentation level
" of the current line (indentation within the clipboard content is preserved)
function! PasteBlockFromClipboardAtCurrentIndentationLevel()
    " indent of current line, in spaces
    let originalIndentAsSpaces = indent(line('.'))

    if originalIndentAsSpaces % &shiftwidth != 0
        echohl ErrorMsg
        echo "The current line's indent is not aligned to a tabstop"
            \ .. " (determined using the value of 'shiftwidth')"
        echohl None
        return
    endif

    let originalIndentAsNumberOfShifts = originalIndentAsSpaces / &shiftwidth

    " put clipboard (+ register) contents under current line
    put +
    " indent the pasted block to what our indentation level was
    call IndentPreviouslyChangedBlock(originalIndentAsNumberOfShifts)
    " cursor will be all the way left, so move it to the first char of the line
    call feedkeys("^")
endfunction

" delete trailing whitespace characters (from either the current line or the
" currently visually-selected lines)
function! DeleteTrailingWhitespace()
    let originalCursorPosition = getcurpos()
    substitute/\s\+$//e
    " substitution leaves any pattern results in the document highlit, so turn
    " off highlighting afterward
    nohlsearch
    call setpos('.', originalCursorPosition)
endfunction


" i want my manually opened and closed folds for *.txt files to persist after
" exiting. this is taken from :h loadview. the 'silent!' ignores errors, like
" ones about folds not being present in the file anymore
autocmd BufWinLeave *.txt mkview
autocmd BufWinEnter *.txt silent! loadview


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
" make hyphens after foldtext be full-width bars so they connect to eachother
set fillchars=fold:─
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
" write but don't change the marks in the file, because some are used for the
" indentation mappings. this way, writing between pasting something and using an
" indentation mapping to indent the pasted text does not end up indenting the
" entire buffer.
nnoremap <Leader>e :lockmarks write<CR>
" write and quit
nnoremap <Leader>E :wq<CR>
" quit window
nnoremap <Leader>u :quit<CR>
" swap to the alternate buffer. easier than CTRL-6
nnoremap <Leader>s :edit #<CR>
" turn off search highlighting
nnoremap <Leader>h :nohlsearch<CR>
" refresh the syntax highlighting for when its parsing gets messed up
nnoremap <Leader>1 :syntax sync fromstart<CR>
" toggle line numbers so can highlight text with mouse (for copying) without
" also selecting the line number text
nnoremap <Leader>U :set number! relativenumber!<CR>
" easier way to escape insert mode than using pinky
inoremap ,n <Esc>
vnoremap ,n <Esc>
nnoremap ,n <Nop>
" remap frequently-used commands that use 'z' so that they don't use right pinky
nnoremap <Leader>na za
nnoremap <Leader>nA zA
nnoremap <Leader>nv zv
nnoremap <Leader>nx zx
nnoremap <Leader>n. zc
nnoremap <Leader>nC zC
vnoremap <Leader>nC zC
nnoremap <Leader>no zo
nnoremap <Leader>nO zO
nnoremap <Leader>nm zm
nnoremap <Leader>nM zM
nnoremap <Leader>nr zr
nnoremap <Leader>nR zR
nnoremap <Leader>ne zz
nnoremap <Leader>nc zt
" like zt, but leave some more lines above the cursor
nnoremap <Leader>nt zt5<C-y>
vnoremap <Leader>nt zt5<C-y>
" copy into X's clipboard
nnoremap <Leader>y "+y
vnoremap <Leader>y "+y
" overwrite visual selection with what's in the unnamed register, but don't
" replace what's in the unnamed register. this way you can easily paste the same
" thing multiple times
vnoremap <Leader>p "_dP
" quick way to indent lines (one just 1 line) that were just pasted. i
" originally had i as shift right and d as shift left, but that confused me
" once because in dvorak, i is on the left, like <, but it goes in the opposite
" direction (and vice versa for d)
nnoremap <Leader>i :call IndentPreviouslyChangedBlock(-1)<CR>
nnoremap <Leader>d :call IndentPreviouslyChangedBlock(1)<CR>
" use same key sequences from above, but for indenting visually-selected lines
vnoremap <Leader>i <
vnoremap <Leader>d >
" similar to above mappings but for the current line. i chose "a" as the prefix
" key because it is currently not being used, it is on another hand than the leader
" key, and it does not use the same finger as either indent key
nnoremap <Leader>ai V<
nnoremap <Leader>ad V>
" paste clipboard register under current line while keeping the current
" indentation level. this mapping is intended to make it easy to paste multiline
" clipboard contents with proper indentation (both of the content and of our
" current indentation level). for non-multiline contents, you can still just do
" ctrl-shift-v in insert mode
nnoremap <Leader>p :call PasteBlockFromClipboardAtCurrentIndentationLevel()<CR>
" remove trailing whitespace from the lines in the current visual selection
vnoremap <Leader>l :call DeleteTrailingWhitespace()<CR>
" remove trailing whitespace from the current line
nnoremap <Leader>l :call DeleteTrailingWhitespace()<CR>
" move cursor to column 80. i frequently have to do this to split long lines
nnoremap <Leader>8 80<Bar>
" easier way to reload this config file (especially when making edits to it)
nnoremap <Leader>f :source ~/.config/nvim/init.vim<CR>
" easier way (in terms of typing) to call a macro
nnoremap <Leader>m @
" quick way to call a macro on the set of currently visually selected lines
for letter in split('a b c d e f g h i j k l m n o p q r s t u v w x y z')
    execute "vnoremap"
    \   .. " <Leader>m" .. letter
    \   .. " :'<'>normal! @" .. letter .. "<CR>"
endfor
" editing a macro by pasting it into your buffer and then yanking it back into
" the register does not work well, especially if there are things like newlines
" in your macro. so the better way is to edit the macro register directly by
" using use a command like :let @a="[macro keys here]"
"
" this mapping does most of the lifting for you so that you can just start
" editing the macro text right away without first constructing that command.
for letter in split('a b c d e f g h i j k l m n o p q r s t u v w x y z')
    execute 'nnoremap'
    \   .. ' <Leader>q' .. letter
    \   .. ' :call OpenMacroForEditing("' .. letter .. '")<CR>'
endfor
" quick way to surround an entire line with parentheses
nnoremap <Leader>( I(<Esc>A)<Esc>^
" quick way to surround an entire line with double quotes
nnoremap <Leader>" I"<Esc>A"<Esc>^
" when navigating to a quick fix result, always open all folds and center it.
" this is useful when used in macros, since it keeps things looking consistent.
" (have to write bar this way so it's not interpreted right now. ":h map-bar")
cnoremap cn cnext <Bar> normal zR zz
cnoremap cp cprevious <Bar> normal zR zz
" :help opens in a horizontal orientation, but i like it vertical
" https://stackoverflow.com/a/630913
cabbrev h vert help
" quick way to toggle color column
noremap Q :call ToggleColorColumn()<CR>
" insert current datestamp
inoremap <F3> <C-R>=strftime("%Y-%m-%d")<CR>

" ---------- Custom Mappings, Task Tracking Markers ----------
" Task Examples:
"     this task has no markers
"     * this task is marked as being preferred 1x
"     ** this task is marked as being preferred 2x (and so on)
"     - this task is marked as being completed
" Key Choice:
"     The prefix key "h" is simply an easy-to-press home row key in Dvorak.
"     The 4 action keys are left-hand resting-position home row keys in Dvorak
"         ("aoeu"), whose positions from left to right roughly correspond to
"         how the action will change the task's position on the typical task
"         completion timeline:
"
"     Unmarked  ------------->  Preferred N Times  ------------>  Completed
"
"        <<<                 <                  >                   >>>
"       ┌───┐              ┌───┐              ┌───┐                ┌───┐
"       │ a │              │ o │              │ e │                │ u │
"       └───┘              └───┘              └───┘                └───┘
"     Unmark()            Defer()            Prefer()            Complete()
"
function! MoveCursorToFirstNonBlankCharAndGetNthChar(index)
    normal! ^
    let currentColumn = getpos('.')[2] - 1
    return getline('.')[currentColumn + a:index]
endfunction
function! TaskUnmark()
    let firstCharOfCurrentLine = MoveCursorToFirstNonBlankCharAndGetNthChar(0)
    if (firstCharOfCurrentLine == "*") || (firstCharOfCurrentLine == "-")
    " preferred or completed task
        normal! dw
    else " unmarked task
    endif
endfunction
function! TaskDefer()
    let firstCharOfCurrentLine = MoveCursorToFirstNonBlankCharAndGetNthChar(0)
    let secondCharOfCurrentLine = MoveCursorToFirstNonBlankCharAndGetNthChar(1)
    if firstCharOfCurrentLine == "*" " preferred task
        if secondCharOfCurrentLine ==? "*" " >1 preference marking
            normal! x
        else " 1 preference marking
            call TaskUnmark()
        endif
    else " completed or unmarked task
    endif
endfunction
function! TaskPrefer()
    let firstCharOfCurrentLine = MoveCursorToFirstNonBlankCharAndGetNthChar(0)
    if firstCharOfCurrentLine == "*" " preferred task
        normal! I*
    else
        if firstCharOfCurrentLine == "-" " completed task
            call TaskUnmark()
        else " unmarked task
        endif
        normal! I* 
    endif
    normal! ^
endfunction
function! TaskComplete()
    let firstCharOfCurrentLine = MoveCursorToFirstNonBlankCharAndGetNthChar(0)
    if firstCharOfCurrentLine == "-" " completed task
    else
        if firstCharOfCurrentLine == "*" " preferred task
            call TaskUnmark()
        else " unmarked task
        endif
        normal! I- 
    endif
    normal! ^
endfunction
nnoremap <Leader>ta :call TaskUnmark()<CR>
nnoremap <Leader>to :call TaskDefer()<CR>
nnoremap <Leader>te :call TaskPrefer()<CR>
nnoremap <Leader>tu :call TaskComplete()<CR>

" ---------- Mappings that Override Default Actions ----------
" make n only jump to the next result when search results are being highlit.
" this way i don't get teleported out of what i'm doing if i accidentally hit n.
" i'd like to make the false value <Nop> for semantic purposes, but that doesn't
" seem to work for mappings with expressions, so an empty string does the job.
" also, the zv in the mapping just reinstates the default behavior of opening
" folds when going to the next search result -- see :h 'foldopen'
nnoremap <expr> n (v:hlsearch) ? "nzv" : ""
" swap C-n and C-p because n is easier to type but 'previous' is the action
" that i usually want because i want to use an identifier seen above in the file
inoremap <C-n> <C-p>
inoremap <C-p> <C-n>
" ^ is harder to type than 0, but i use that action way more often, so swap them
nnoremap ^ 0
nnoremap 0 ^
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
