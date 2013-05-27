"=================================================================================
" Author:       Motosir Ali
" Date:         May 2013
" Copyright:    Standard VIM Licensing
" Descripton:   Small set of Misc. Vim scripts to imporve workflow  
"=================================================================================
"
"
"
"
"
"=================================================================================
"  = EasyGrep =
"  - Wrapper around grep to call command line invocation of :grep <WORD> *  
"  - Doesn't show default result window. Doesn't jump to first result
"  - Instead presents results in quickfix window 
"  Invocation:
"  :Grep <Search-Word> [file-extension=*]
"  <F4> searches word under cursor
"=================================================================================
"
"This is to hide MiniBufferExplorer window if visible, this requires disabling
"as it prevents quickfix from showing.

function! HideMBE()
    if bufloaded("-MiniBufExplorer-")
        :normal,mbt 
    endif
endfunction

"
function! EasyGrep(arg1, ...)
    :cclose
    call HideMBE()
    if a:0 == 1
        exec ":silent grep!" a:arg1 a:1 
    elseif a:0 == 0  
        exec ":silent grep!" a:arg1 "*"
    endif
    :cwin
endfunction

command! -nargs=+ Grep call EasyGrep(<f-args>)
nnoremap <F4> :exec "Grep" expand("<cword>")<CR>
"=================================================================================


"=================================================================================
"  = Comment =
"  - Comment/Uncomment blocks of code in C++/Python
"  Invocation:
"  - <C-k> to toggle lines or visual blocks of code  
"  - :call Comment() if you prefer command line variant
"=================================================================================
 
let b:comment_char = "//"

function! Comment() range
    echom a:firstline a:lastline
    let s:lnum = a:firstline 
    if getline(s:lnum) =~ "^" . b:comment_char
        while s:lnum <= a:lastline
            let charnum = strlen(b:comment_char)
            call setline(s:lnum, strpart(getline(s:lnum),charnum))
            let s:lnum = s:lnum + 1
        endwhile
    else
        while s:lnum <= a:lastline
            call setline(s:lnum, b:comment_char . getline(s:lnum))
            let s:lnum = s:lnum + 1
        endwhile
    endif
endfunction

"toggle comment for selected visual block
vnoremap <C-k> :call Comment()<CR>
"toggle comment for current line 
nnoremap <C-k> :call Comment()<CR> 
"set comment char based on FileType set for current buffer
autocmd FileType python :let b:comment_char = "\""
autocmd FileType vim :let b:comment_char = "\""
autocmd FileType cpp :let b:comment_char = "//"
"=================================================================================



