function! GetInput()
    "let s:input = input("Enter filename: ")
    "echom ".   user entered:" s:input
    let choice = inputlist(['Select operation:', '1. Test C++ project',
                \ '2. New C++ Project', '3. New Class', '4. Python'])
    if choice == 1
        call CreateMainFile("")
        call CreateMakefile("")
        b main.cpp
    endif
    if choice == 2
        let s:input = input("\nEnter Project Name: ")
        call CreatNewProject(s:input) 
        b main.cpp
    endif
    if choice == 3
        let s:input = input("\nEnter Class Name: ")
        call CreateClass(s:input)
    endif
    if choice == 4
        echo "\nTODO: Create Python template" 
    endif
endfunction

function! CreatNewProject(name)
    call CreateMainFile(a:name)
    call CreateClass(a:name)
    call CreateMakefile(a:name)
endfunction

function! CreateMainFile(name)
    if bufexists("main.cpp")
        echom "Aborting new main.cpp. File already exists"
        return
    endif
    :e main.cpp
    let s:include = strlen(a:name)==0?'':'#include '.'"'.a:name.'.h"'
    let s:lines = ['#include <iostream>', 
                \s:include,
                \'',
                \'int main(int argc, char* argv[])',
                \'{',
                \'',
                \'}',
                \'']
    call setline(1,s:lines) 
endfunction

function! CreateClass(name)
    let imp = a:name.'.cpp'
    let hdr = a:name.'.h'
    if bufexists(imp) || bufexists(hdr)
        echom "Aborting. File already exists"
        return
    endif

    let name_const = toupper(a:name).'_H'
    let classname  = a:name
    
    exec ":e ".imp 
    let s:lines = ['#include '.'"'.hdr.'"', 
                \'',
                \classname."::".classname."()",
                \'{',
                \'}',
                \'']
    call setline(1,s:lines) 
    exec ":e ".hdr
    let s:lines2 = ['#ifndef '.name_const,
                \'#define '.name_const,
                \'',
                \'class '.a:name,
                \'{',
                \'public:',
                \"\t".a:name."();",
                \'',
                \'private:',
                \'',
                \'};',
                \'',
                \'#endif /* '.name_const.' */']
    call setline(1,s:lines2) 
endfunction

function! CreateMakefile(name)
    if bufexists("Makefile")
        echom "Aborting. File already exists"
        return
    endif
    :e Makefile
    let s:obj = strlen(a:name)==0?"":"\t".a:name.".o"
    let s:lines = ['',
                \'CC = g++ ',
                \'CXX = g++ ',
                \'CXXFLAGS = -std=c++11 -Wall',
                \'',
                \'TARGET = main ',
                \'',
                \'all   :   $(TARGET)',
                \'',
                \"OBJ =\tmain.o \\",
                \s:obj,
                \'',
                \"${TARGET}:\t$(OBJ)",
                \'',
                \'.PHONY: clean',
                \'',
                \'clean:',
                \"\trm -f $(OBJ) $(TARGET)",
                \'']
    call setline(1,s:lines) 
endfunction

function! GetWin()
    for i in range(1,winnr('$'))
        echom bufname(i)
        let bnum = winbufnr(i)
        "echo "--" getbufvar(bnum, "&buftype")
        echo "--" getbufvar(bnum, "")
        "echo getwinvar(i,"")
    endfor

endfunction




