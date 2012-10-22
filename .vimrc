
" tabbing between buffers
nnoremap <Tab> :if &modifiable && !&readonly && &modified <CR> :w<CR> :endif<CR> :bn<CR>
nnoremap <S-Tab> :if &modifiable && !&readonly && &modified <CR> :w<CR> :endif<CR> :bp<CR>
syntax on

filetype plugin on

set path+=~/.vim/mytags/cpp_src
set nocompatible
"set makeprg=g++\ -o\ %:r\ -Wall\ %
set makeprg=g++\ %\ -o\ %<\ -Wall 
set ts=4
set expandtab
"set cindent shiftwidth=4
set shiftwidth=2
set mouse=a
set splitbelow
set hidden
map <C-F12> :w <CR> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" navigating tabs 
map <C-F2> :tabnew <CR>
map <F2> :tabnext <CR>
imap <F2> <Esc> :tabnext <CR>

map <F5> :!./%< <CR>
"map <F6> :!g++ % -o %< <CR>
map <F3> <Esc> :w <CR> <Esc> :set makeprg=qmake\ -project\ &&\ qmake\ %<.pro <CR> <Esc> :make <CR>
map <F6> <Esc> :w <CR> <Esc> :set makeprg=g++\ %\ -o\ %<\ -Wall <CR> <Esc> :make<CR>
map <S-F6> <Esc> :w <CR> <Esc> :set makeprg=g++\ %\ -lrt\ -lmylib\ -o\ %<\ -Wall <CR> <Esc> :make<CR>

function! SimpleMake()
  let num=5
  let cpp_files = glob("**/*.cpp")
  let hdr_files = glob("**/*.h")
  let files = substitute(cpp_files, "\n", " ", "g")
  let make_line = "g++ " . files . " -o main"
  "echo make_line
  let &makeprg=make_line
endfunction

"func! CompileRunGcc()
"  exec "w"
"  exec "!g++ % -o %<"
"  exec "! ./%<"
"endfunc
func! CompileRunGcc()
"  exec "!g++ % -o %< | tee  && ./%< || vim -q make.out"
"  exec "!g++ test.cpp 2>&1 | tee /tmp/make.out && ./a.out || (read -n 1 -p Press any key to continue; vi -q /tmp/make.out)"
"   exec "!g++ % 2>&1 | tee /tmp/make.out; [ $PIPESTATUS -eq 0 ] && ./%< || (read -n 1 -p Press any key to continue; vi -q /tmp/make.out)"
   exec "!g++ % 2>&1 | tee /tmp/make.out; [ $PIPESTATUS -eq 0 ] && ./%< || (read -n 1 -p Press any key to continue; vi -q /tmp/make.out)"
endfunc

map <C-F7> :w <CR> :!./copy.sh<CR>
map <F7> :w <CR> :call RunMe()<CR>:make <CR>
imap <F7> <Esc> :w <CR> :call RunMe()<CR>:make<CR>
fun! RunMe()
  :if filereadable('Makefile')
    set  makeprg=make
  :else
	  set makeprg=g++\ -o\ %:r\ -Wall\ %
  :endif
endfunc

map <F8> :cn<CR>

"--------------------
" OmniCppComplete
" --------------------
" set Ctrl+j in insert mode, like VS.Net
imap <C-j> <C-X><C-O>
" :inoremap <expr> <CR> pumvisible() ? "\<c-y>" : "\<c-g>u\<CR>"
" set completeopt as don't show menu and preview
set completeopt=menuone
" Popup menu hightLight Group
highlight Pmenu ctermbg=13 guibg=LightGray
highlight PmenuSel ctermbg=7 guibg=DarkBlue guifg=White
highlight PmenuSbar ctermbg=7 guibg=DarkGray
highlight PmenuThumb guibg=Black
" use global scope search
let OmniCpp_GlobalScopeSearch = 1
" 0 = namespaces disabled
" 1 = search namespaces in the current buffer
" 2 = search namespaces in the current buffer and in included files
let OmniCpp_NamespaceSearch = 1
" 0 = auto
" 1 = always show all members
let OmniCpp_DisplayMode = 1
" 0 = don't show scope in abbreviation
" 1 = show scope in abbreviation and remove the last column
let OmniCpp_ShowScopeInAbbr = 0
" This option allows to display the prototype of a function in the
"  abbreviation part of the popup menu.
" 0 = don't display prototype in abbreviation
" 1 = display prototype in abbreviation
let OmniCpp_ShowPrototypeInAbbr = 1
" This option allows to show/hide the access information ('+', '#', '-') in
"  the popup menu.
" 0 = hide access
" 1 = show access
let OmniCpp_ShowAccess = 1
" This option can be use if you don't want to parse using namespace
"  declarations in included files and want to add namespaces that are always
"  used in your project.
let OmniCpp_DefaultNamespaces = ["std"]
" Complete Behaviour
let OmniCpp_MayCompleteDot = 0
let OmniCpp_MayCompleteArrow = 0
let OmniCpp_MayCompleteScope = 0
" When 'completeopt' does not contain "longest", Vim automatically select
"  the first entry of the popup menu. You can change this behaviour with the
"  OmniCpp_SelectFirstItem option.
let OmniCpp_SelectFirstItem = 0

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
set completeopt=menuone,menu,longest,preview


" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/mytags/cpp
set tags+=~./tags/
"set tags+=~/.vim/tags/gl
"set tags+=~/.vim/tags/sdl
"set tags+=~/.vim/mytags/qt4


function! s:InsertGuard()
  let randlen = 4
  let randnum = system("xxd -c " . randlen * 2 . " -l " . randlen . " -p /dev/urandom")
  let randnum = strpart(randnum, 0, randlen * 2)
  let fname = expand("%")
  let lastslash = strridx(fname, "/")
  if lastslash >= 0
    let fname = strpart(fname, lastslash+1)
  endif
  let fname = substitute(fname, "[^a-zA-Z0-9]", "_", "g")
"  let randid = toupper(fname . \"_\" . randnum)
  let randid = toupper(fname)
  exec 'norm O#ifndef ' . randid
  exec 'norm o#define ' . randid
  let origin = getpos('.')
  exec '$norm o#endif /* ' . randid . ' */'
  norm o
  -norm O
  call setpos('.', origin)
  norm w
endfunction


if has('gui_running')
	set background=dark
	colorscheme	desert 
else
	colorscheme	desert 
	set background=dark
endif



"===================================================================
" My .VIMRC
"===================================================================


" cscope
if has('cscope')
  " shows db connnection debug output
  set cscopetag cscopeverbose

  if has('quickfx')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

endif

"==================================================================
" Globals
"==================================================================
let MYHELPFILE = "~/.vim/usr/files/help.txt"




"===================================================================
" My MAPs
"===================================================================
let mapleader = ","
map! ;; <Esc>

" window navigation
nmap <silent> <Leader>wh :wincmd h<CR>
nmap <silent> <Leader>wj :wincmd j<CR>
nmap <silent> <Leader>wk :wincmd k<CR>
nmap <silent> <Leader>wl :wincmd l<CR>

" switch between header/cpp 
nmap <silent> <Leader>ol :FSRight<cr>
nmap <silent> <Leader>oL :FSSplitRight<cr>
nmap <buffer> <silent> <leader> ,PP

"vimrc
map <Leader>ev :e $MYVIMRC<CR><C-W>_
map <Leader>rv :source $MYVIMRC<CR>:echom ".vimrc reloaded"<CR>
map <Leader>eh :execute ":e " . MYHELPFILE<CR>

map ,b <Esc>:call SimpleMake()<CR>:make<CR>
map ,r <Esc>:!./main<CR>

" Ctags and Cscope (rebuild DB's)
function! Recscope()
    :!ctags -R
    :!cscope -R -b
    :cs reset 
endfunction
nmap ,t :exec Recscope()<CR>

" keymap Ctrl-h to the InsertGuard function
noremap <silent> <C-h> :call <SID>InsertGuard()<CR>
map test  i#include <iostream><CR><CR>using namespace std;<CR><CR>int main()<CR>{<CR><CR>  cout << "Hello World" << endl;<CR><CR>	return 0;<CR><CR>}	


" My abbreviations - note this are just examples
iab sct std::cout << "" << std::endl;
iab cprint #define PRINTF(str, ...) printf("\033[41m"str"\033[0m\n", __VA_ARGS__);


function! CppInterface(...)

  echo "CPP Project Manager"
  let s:argc = a:0
  echo a:0
  if s:argc == 0
    echo "no args"   
  elseif s:argc == 1
    echo "1 args: " a:1
  else   
    echo "lots of args" 
  endif 
endfunction
command! -nargs=* Cpp call CppInterface(<f-args>)

"========================================================================================
" Experimental -- ScratchPad Area
"========================================================================================

function! FuncTemplate()
    let p = getpos(".")
    let line = p[1]
    call append(line-1, ["void func()", "{", "","}"])
endfunction 

map fff :call FuncTemplate()<CR>

inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

"========================================================================================


