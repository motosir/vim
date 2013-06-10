"=========================================================================================
"   .vimrc    ---   Motosir Ali
"=========================================================================================


"========================================================================================
" Vundle - Plugin Manager
"======================================================================================== 
""" ------------------------------------------------{{{
set nocompatible               " be iMproved 
filetype off                   " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" My vim plugins
source ~/.vim/plugin/mali.vim
source ~/.vim/plugin/proj.vim

" let Vundle manage Vundle
Bundle 'gmarik/vundle'
" My Bundles here:
" GitHub
"Bundle 'Rip-Rip/clang_complete'
Bundle 'Lokaltog/vim-powerline'
Bundle 'Valloric/YouCompleteMe'
Bundle 'Valloric/vim-indent-guides'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-notes'
Bundle 'scrooloose/nerdtree'
"Bundle 'vim-scripts/OmniCppComplete'
Bundle 'vim-scripts/autoproto.vim'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'derekwyatt/vim-fswitch'
Bundle 'derekwyatt/vim-protodef'
Bundle 'corntrace/bufexplorer'
Bundle 'kien/ctrlp.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-surround'
Bundle 'altercation/vim-colors-solarized'
Bundle 'nanotech/jellybeans.vim'
"Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
" vim-scripts repos
"Bundle 'L9'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" ...
filetype plugin indent on     " required!
syntax on
"}}}
"========================================================================================
" EDITOR
"========================================================================================
"{{{
" STATUS LINE
set statusline=%<%f\ " Filename
set statusline+=%w%h%m%r " Options
"set statusline+=%{fugitive#statusline()} " Git Hotness
set statusline+=\ [%{&ff}/%Y] " filetype
set statusline+=\ [%{getcwd()}] " current dir
set statusline+=\ [A=\%03.3b/H=\%02.2B] " ASCII / Hexadecimal value of char
set statusline+=%=%-14.(%l,%c%V%)\ %p%% " Right aligned file nav inii
" always show the status line
set ls=2

set path+=~/.vim/mytags/cpp_src

" EDITOR SETTINGS
set bs=indent,eol,start
"set makeprg=g++\ -o\ %:r\ -Wall\ %
set ts=4
set expandtab
"set cindent shiftwidth=4
set cindent 
set shiftwidth=4
set mouse=a
set splitbelow
"modified buffers can be hidden 
set hidden
set hlsearch
set incsearch
set number
set wildmenu
" used the system clipboard
set clipboard=unnamed
" timeout for key code sequence
set timeoutlen=350
" setting colour for the column in here doesn't work
"highlight colorcolumn guibg=lightblue
"set colorcolumn=80
}}}
"========================================================================================
" GLOBALS
"========================================================================================
"{{{
" write notes here, probably not needed as we have notes plugin for this.
let MYHELPFILE = "~/.vim/usr/files/help.txt"
" global var to toggle between 0=c++03 and 1=c++11 
let CPPSTD=1
"}}}
"========================================================================================
" CUSTOM FUNCTIONS
"========================================================================================
"{{{
" toggle between c++03 and c++11
function! ToggleStandards()
   if g:CPPSTD == 0 
       let g:CPPSTD=1
       echo "std=c++11"
   else
       let g:CPPSTD=0
       echo "std=c++03"
   endif
endfunction

" builds using all cpp files in current dir
" TODO: customise output name
function! SimpleMake()
  if filereadable('Makefile')
    set makeprg=make
  else
      let cpp_files = glob("**/*.cpp")
"      let hdr_files = glob("**/*.h")
      let files = substitute(cpp_files, "\n", " ", "g")
      if g:CPPSTD==0
        let make_line = "g++ " . files . " -o main"
      else
        let make_line = "g++ -std=c++11 " . files . " -o main"
      endif
      "echo make_line
      let &makeprg=make_line
  endif
endfunction

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
"}}}
"========================================================================================
" VIM SETTINGS 
"========================================================================================
"{{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/mytags/cpp
set tags+=~./tags/

if has('gui_running')
	set background=dark
"	colorscheme	desert 
	colorscheme	jellybeans
    set guifont=Inconsolata\ 9
else
	colorscheme	desert 
	set background=dark
endif
" cscope
if has('cscope')
  " shows db connnection debug output
  set cscopetag cscopeverbose

  if has('quickfx')
    set cscopequickfix=s-,c-,d-,i-,t-,e-
  endif

endif
"}}}
"========================================================================================
" MAPS
"========================================================================================
"{{{
let mapleader = ","
map! ;; <Esc>
map <F8> :cn<CR>

" window navigation
nmap <silent> <Leader>h :wincmd h<CR>
nmap <silent> <Leader>j :wincmd j<CR>
nmap <silent> <Leader>k :wincmd k<CR>
nmap <silent> <Leader>l :wincmd l<CR>

" switch between header/cpp 
nmap <silent> <Leader>ol :FSRight<cr>
nmap <silent> <Leader>oL :FSSplitRight<cr>
nmap <buffer> <silent> <leader> ,PP

"vimrc
map <Leader>ev :vsplit $MYVIMRC<CR><C-W>_
map <Leader>rv :source $MYVIMRC<CR>:echom ".vimrc reloaded"<CR>
map <Leader>eh :execute ":e " . MYHELPFILE<CR>

" map for easy compile and run of C/C++ programs
map <Leader>1 <Esc>:call ToggleStandards()<CR>
map <Leader>b <Esc>:call SimpleMake()<CR>:make<CR>
map <Leader>r <Esc>:!./main<CR>
nnoremap <C-x> :!./main<CR>

" call g:ClangUpdateQuickFix()
nnoremap <Leader># :call g:ClangUpdateQuickFix()<CR>
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <C-b> :call ConfigureMakePRG()<CR>

" easier navigation of command history 
cnoremap <c-j> <down>
cnoremap <c-k> <up>
cnoremap <c-h> <left>
cnoremap <c-l> <right>

" Ctags and Cscope (rebuild DB's)
function! Recscope()
    :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q
    :!cscope -R -b
    :cs reset 
endfunction
nnoremap ,t :exec Recscope()<CR>

" Tabbing between buffers
nnoremap <C-Tab> :if &modifiable && !&readonly && &modified <CR> :w<CR> :endif<CR> :bn<CR>
nnoremap <Leader>o :b#<CR>

" keymap Ctrl-h to the InsertGuard function
noremap <silent> <Leader>hg :call <SID>InsertGuard()<CR>

" My abbreviations - note these are just examples
"inoremap <Leader>sc std::cout << "" << std::endl;<Esc>F"i
"inoremap <Leader>sv std::vector<> ;<Esc>F>i

"}}}
"========================================================================================
" ABBREVIATIONS
"========================================================================================
"{{{
iabbr sts std::string
"}}}
"========================================================================================
" PLUGINS 
"========================================================================================
"{{{
" -- YouCompleteMe 
"========================================================================================
"  load extra config for defualt clang compiler args
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py' 
let g:ycm_autoclose_preview_window_after_completion = 1
"  go to definition
augroup filetype_vim
    au FileType cpp nnoremap <buffer> <C-]> :YcmCompleter GoToDefinitionElseDeclaration<CR>
augroup END
"defuault completeopt=preview,menuone, preview doesn't work too well with ycm,
"so diable
set completeopt=menuone
"========================================================================================
" -- EasyMotion
"========================================================================================
"let g:EasyMotion_leader_key = ','
nmap <Leader>f <Leader><Leader>f

"========================================================================================
" -- Notes 
"========================================================================================
let g:notes_directories = ['~/notes']

"========================================================================================
" -- MiniBufferExpl
"========================================================================================
map <Leader>mbt :MBEToggle<cr>
"========================================================================================
" Experimental -- ScratchPad Area
"========================================================================================

function! FuncTemplate()
    let p = getpos(".")
    let line = p[1]
    call append(line-1, ["void func()", "{", "","}"])
endfunction 

map fff :call FuncTemplate()<CR>

inoremap <expr> <C-j> ((pumvisible())?("\<C-n>"):("\<C-j>"))
inoremap <expr> <C-k> ((pumvisible())?("\<C-p>"):("\<C-k>"))

if exists('vimrc_loaded')
  finish
endif
let vimrc_loaded = 1
" do one off stuff here

function! ConfigureMakePRG()
  if findfile("Makefile", ".") == "Makefile" 
    set makeprg=make
  else
    let list3 = split(globpath(".", "*.cpp"), "\n")
    let s:objs = join(list3, " ")
    let s:objs = substitute(s:objs, "./", "", "g") 
    echo s:objs 
    set makeprg=g++\ -std=c++11\ s:objs\ -o\ %<\ -Wall 
    let &g:makeprg="g++ " . s:objs . " -o main"
  endif
  echo &makeprg
  :make
endfunction
command! M call ConfigureMakePRG()
"}}}
"========================================================================================
" Old Stuff
"========================================================================================
"{{{
" navigating tabs 
"map <C-F2> :tabnew <CR>
"map <F2> :tabnext <CR>
"imap <F2> <Esc> :tabnext <CR>
"
"map <F5> :!./%< <CR>
""map <F6> :!g++ % -o %< <CR>
"map <F3> <Esc> :w <CR> <Esc> :set makeprg=qmake\ -project\ &&\ qmake\ %<.pro <CR> <Esc> :make <CR>
"map <F6> <Esc> :w <CR> <Esc> :set makeprg=g++\ %\ -o\ %<\ -Wall <CR> <Esc> :make<CR>
"map <S-F6> <Esc> :w <CR> <Esc> :set makeprg=g++\ %\ -lrt\ -lmylib\ -o\ %<\ -Wall <CR> <Esc> :make<CR>
"func! CompileRunGcc()
""  exec "w"
""  exec "!g++ % -o %<"
""  exec "! ./%<"
""endfunc
"func! CompileRunGcc()
""  exec "!g++ % -o %< | tee  && ./%< || vim -q make.out"
""  exec "!g++ test.cpp 2>&1 | tee /tmp/make.out && ./a.out || (read -n 1 -p Press any key to continue; vi -q /tmp/make.out)"
""   exec "!g++ % 2>&1 | tee /tmp/make.out; [ $PIPESTATUS -eq 0 ] && ./%< || (read -n 1 -p Press any key to continue; vi -q /tmp/make.out)"
"   exec "!g++ % 2>&1 | tee /tmp/make.out; [ $PIPESTATUS -eq 0 ] && ./%< || (read -n 1 -p Press any key to continue; vi -q /tmp/make.out)"
"endfunc
"
"map <C-F7> :w <CR> :!./copy.sh<CR>
"map <F7> :w <CR> :call RunMe()<CR>:make <CR>
"imap <F7> <Esc> :w <CR> :call RunMe()<CR>:make<CR>
"fun! RunMe()
"  :if filereadable('Makefile')
"    set  makeprg=make
"  :else
"	  set makeprg=g++\ -o\ %:r\ -Wall\ %
"  :endif
"endfunc
"========================================================================================
" -- clang_complete 
"========================================================================================
"let g:clang_library_path='/opt/clang/lib'
"let g:clang_user_options='-std=c++11'
"let g:clang_complete_copen=1
"let g:clang_periodic_quickfix=0
"" call g:ClangUpdateQuickFix()
"let g:clang_snippets=1"}}}
