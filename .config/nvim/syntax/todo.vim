" Notes:
"     - ":help :syn-pattern"
"     - ":help /\zs" - using \zs and \ze to start and end the match, in order to
"       get the highlighting correct


" ---------- Date Headers ------------------------------------------------------
"
" 1970-01-01 (Thu):
" ^^^^^^^^^^^^^^^^^ highlight
syntax match Special /[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} (\a\{3\}):/

" ---------- Frequency Labels for Recurring Tasks ------------------------------
"
" (monthly) delete old files
" ^^^^^^^^^ highlight
syntax match Identifier /(\a\+ly)\ze / " (daily), (monthly), etc
syntax match Identifier /(every \d\+ \a\+)\ze / " (every 2 months), etc
syntax match Identifier /(\w\+ of every \w\+)\ze / " (1st of every month), etc

" ---------- Task Completion Markers -------------------------------------------
"
" *** task to do
"     - task done
"     ^ highlight
" ^^^ highlight
syntax match Type /^\s*-/
syntax match Type /^\s*\zs\*\+\ze /

" ---------- Option List Letters -----------------------------------------------
"
" a. option 1
" b. option 2
" ^^ highlight
"
syntax match Identifier /^\s\+\zs[a-z]\.\ze /
