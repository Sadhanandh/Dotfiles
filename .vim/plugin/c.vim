"#################################################################################
"
"       Filename:  c.vim
"
"    Description:  C/C++-IDE. Write programs by inserting complete statements,
"                  comments, idioms, code snippets, templates and comments.
"                  Compile, link and run one-file-programs without a makefile.
"                  See also help file csupport.txt .
"
"   GVIM Version:  7.0+
"
"  Configuration:  There are some personal details which should be configured
"                   (see the files README.csupport and csupport.txt).
"
"         Author:  Dr.-Ing. Fritz Mehner, FH Südwestfalen, 58644 Iserlohn, Germany
"          Email:  mehner@fh-swf.de
"
"        Version:  see variable  g:C_Version  below
"        Created:  04.11.2000
"        License:  Copyright (c) 2000-2011, Fritz Mehner
"                  This program is free software; you can redistribute it and/or
"                  modify it under the terms of the GNU General Public License as
"                  published by the Free Software Foundation, version 2 of the
"                  License.
"                  This program is distributed in the hope that it will be
"                  useful, but WITHOUT ANY WARRANTY; without even the implied
"                  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
"                  PURPOSE.
"                  See the GNU General Public License version 2 for more details.
"       Revision:  $Id: c.vim,v 1.162 2012/02/25 15:15:30 mehner Exp $
"
"------------------------------------------------------------------------------
"
if v:version < 700
  echohl WarningMsg | echo 'The plugin c-support.vim needs Vim version >= 7 .'| echohl None
  finish
endif
"
" Prevent duplicate loading:
"
if exists("g:C_Version") || &cp
 finish
endif
let g:C_Version= "5.17"  							" version number of this script; do not change
"
"#################################################################################
"
"  Global variables (with default values) which can be overridden.
"
" Platform specific items:  {{{1
" - root directory
" - characters that must be escaped for filenames
"
let s:MSWIN = has("win16") || has("win32")   || has("win64")    || has("win95")
let s:UNIX	= has("unix")  || has("macunix") || has("win32unix")
"
"
let s:C_FilenameEscChar 		= ''

if	s:MSWIN
  let s:C_FilenameEscChar 			= ''
else
  let s:C_FilenameEscChar 			= ' \%#[]'
endif

let s:C_IndentErrorLog				= $HOME.'/.indent.errorlog'
"
"  Modul global variables (with default values) which can be overridden. {{{1
"
if	s:MSWIN
	let s:C_CCompiler           = 'gcc.exe'  " the C   compiler
	let s:C_CplusCompiler       = 'g++.exe'  " the C++ compiler
	let s:C_ExeExtension        = '.exe'     " file extension for executables (leading point required)
	let s:C_ObjExtension        = '.obj'     " file extension for objects (leading point required)
	let s:C_Man                 = 'man.exe'  " the manual program
else
	let s:C_CCompiler           = 'gcc'      " the C   compiler
	let s:C_CplusCompiler       = 'g++'      " the C++ compiler
	let s:C_ExeExtension        = ''         " file extension for executables (leading point required)
	let s:C_ObjExtension        = '.o'       " file extension for objects (leading point required)
	let s:C_Man                 = 'man'      " the manual program
endif
let s:C_VimCompilerName				= 'gcc'      " the compiler name used by :compiler
"
let s:C_CExtension     				= 'c'                    " C file extension; everything else is C++
let s:C_CFlags         				= '-Wall -g -O0 -c'      " compiler flags: compile, don't optimize
let s:C_CodeCheckExeName      = 'check'
let s:C_CodeCheckOptions      = '-K13'
let s:C_LFlags         				= '-Wall -g -O0'         " compiler flags: link   , don't optimize
let s:C_Libs           				= '-lm'                  " libraries to use
let s:C_OutputGvim            = 'vim'
let s:C_Printheader           = "%<%f%h%m%<  %=%{strftime('%x %X')}     Page %N"
let s:C_TypeOfH               = 'cpp'
let s:C_XtermDefaults         = '-fa courier -fs 12 -geometry 80x24'
"
let s:C_FormatDate						= '%x'
let s:C_FormatTime						= '%X'
let s:C_FormatYear						= '%Y'
let s:C_SourceCodeExtensions  = 'c cc cp cxx cpp CPP c++ C i ii'
"
"------------------------------------------------------------------------------
"
"  Look for global variables (if any), to override the defaults.
"
function! C_CheckGlobal ( name )
  if exists('g:'.a:name)
    exe 'let s:'.a:name.'  = g:'.a:name
  endif
endfunction    " ----------  end of function C_CheckGlobal ----------
"
call C_CheckGlobal('C_CCompiler            ')
call C_CheckGlobal('C_CExtension           ')
call C_CheckGlobal('C_CFlags               ')
call C_CheckGlobal('C_CodeCheckExeName     ')
call C_CheckGlobal('C_CodeCheckOptions     ')
call C_CheckGlobal('C_CodeSnippets         ')
call C_CheckGlobal('C_CplusCompiler        ')
call C_CheckGlobal('C_ExeExtension         ')
call C_CheckGlobal('C_FormatDate           ')
call C_CheckGlobal('C_FormatTime           ')
call C_CheckGlobal('C_FormatYear           ')
call C_CheckGlobal('C_IndentErrorLog       ')
call C_CheckGlobal('C_LFlags               ')
call C_CheckGlobal('C_Libs                 ')
call C_CheckGlobal('C_Man                  ')
call C_CheckGlobal('C_ObjExtension         ')
call C_CheckGlobal('C_OutputGvim           ')
call C_CheckGlobal('C_Printheader          ')
call C_CheckGlobal('C_Root                 ')
call C_CheckGlobal('C_SourceCodeExtensions ')
call C_CheckGlobal('C_TypeOfH              ')
call C_CheckGlobal('C_VimCompilerName      ')
call C_CheckGlobal('C_XtermDefaults        ')

"
"
" set default geometry if not specified
"
if match( s:C_XtermDefaults, "-geometry\\s\\+\\d\\+x\\d\\+" ) < 0
	let s:C_XtermDefaults	= s:C_XtermDefaults." -geometry 80x24"
endif
"
" escape the printheader
"
let s:C_Printheader  = escape( s:C_Printheader, ' %' )
"
let s:C_HlMessage    = ""
"
"
"------------------------------------------------------------------------------
"  Control variables (not user configurable)
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------

let s:C_SourceCodeExtensionsList	= split( s:C_SourceCodeExtensions, '\s\+' )

"------------------------------------------------------------------------------
"
"
"------------------------------------------------------------------------------
"  C_Compile : C_Compile       {{{1
"------------------------------------------------------------------------------
"  The standard make program 'make' called by vim is set to the C or C++ compiler
"  and reset after the compilation  (setlocal makeprg=... ).
"  The errorfile created by the compiler will now be read by gvim and
"  the commands cl, cp, cn, ... can be used.
"------------------------------------------------------------------------------
let s:LastShellReturnCode	= 0			" for compile / link / run only

function! C_Compile ()

	let s:C_HlMessage = ""
	exe	":cclose"
	let	Sou		= expand("%:p")											" name of the file in the current buffer
	let	Obj		= expand("%:p:r").s:C_ObjExtension	" name of the object
	let SouEsc= escape( Sou, s:C_FilenameEscChar )
	let ObjEsc= escape( Obj, s:C_FilenameEscChar )
	if s:MSWIN
		let	SouEsc	= '"'.SouEsc.'"'
		let	ObjEsc	= '"'.ObjEsc.'"'
	endif

	" update : write source file if necessary
	exe	":update"

	" compilation if object does not exist or object exists and is older then the source
	if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
		" &makeprg can be a string containing blanks
		let makeprg_saved	= '"'.&makeprg.'"'
		if expand("%:e") == s:C_CExtension
			exe		"setlocal makeprg=".s:C_CCompiler
		else
			exe		"setlocal makeprg=".s:C_CplusCompiler
		endif
		"
		" COMPILATION
		"
		exe ":compiler ".s:C_VimCompilerName
		let v:statusmsg = ''
		let	s:LastShellReturnCode	= 0
		exe		"make ".s:C_CFlags." ".SouEsc." -o ".ObjEsc
		exe	"setlocal makeprg=".makeprg_saved
		if empty(v:statusmsg)
			let s:C_HlMessage = "'".Obj."' : compilation successful"
		endif
		if v:shell_error != 0
			let	s:LastShellReturnCode	= v:shell_error
		endif
		"
		" open error window if necessary
		:redraw!
		"exe	":botright cwindow"
    "TODO change
	else
		let s:C_HlMessage = " '".Obj."' is up to date "
	endif

endfunction    " ----------  end of function C_Compile ----------

"===  FUNCTION  ================================================================
"          NAME:  C_CheckForMain
"   DESCRIPTION:  check if current buffer contains a main function
"    PARAMETERS:  
"       RETURNS:  0 : no main function
"===============================================================================
function! C_CheckForMain ()
	return  search( '^\(\s*int\s\+\)\=\s*main', "cnw" )
endfunction    " ----------  end of function C_CheckForMain  ----------
"
"------------------------------------------------------------------------------
"  C_Link : C_Link       {{{1
"------------------------------------------------------------------------------
"  The standard make program which is used by gvim is set to the compiler
"  (for linking) and reset after linking.
"
"  calls: C_Compile
"------------------------------------------------------------------------------
function! C_Link ()

	call	C_Compile()
	:redraw!
	if s:LastShellReturnCode != 0
		let	s:LastShellReturnCode	=  0
		return
	endif

	let s:C_HlMessage = ""
	let	Sou		= expand("%:p")						       		" name of the file (full path)
	let	Obj		= expand("%:p:r").s:C_ObjExtension	" name of the object file
	let	Exe		= expand("%:p:r").s:C_ExeExtension	" name of the executable
	let ObjEsc= escape( Obj, s:C_FilenameEscChar )
	let ExeEsc= escape( Exe, s:C_FilenameEscChar )
	if s:MSWIN
		let	ObjEsc	= '"'.ObjEsc.'"'
		let	ExeEsc	= '"'.ExeEsc.'"'
	endif

	if C_CheckForMain() == 0
		let s:C_HlMessage = "no main function in '".Sou."'"
		return
	endif

	" no linkage if:
	"   executable exists
	"   object exists
	"   source exists
	"   executable newer then object
	"   object newer then source

	if    filereadable(Exe)                &&
      \ filereadable(Obj)                &&
      \ filereadable(Sou)                &&
      \ (getftime(Exe) >= getftime(Obj)) &&
      \ (getftime(Obj) >= getftime(Sou))
		let s:C_HlMessage = " '".Exe."' is up to date "
		return
	endif

	" linkage if:
	"   object exists
	"   source exists
	"   object newer then source

	if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
		let makeprg_saved='"'.&makeprg.'"'
		if expand("%:e") == s:C_CExtension
			exe		"setlocal makeprg=".s:C_CCompiler
		else
			exe		"setlocal makeprg=".s:C_CplusCompiler
		endif
		exe ":compiler ".s:C_VimCompilerName
		let	s:LastShellReturnCode	= 0
		let v:statusmsg = ''
		silent exe "make ".s:C_LFlags." -o ".ExeEsc." ".ObjEsc." ".s:C_Libs
		if v:shell_error != 0
			let	s:LastShellReturnCode	= v:shell_error
		endif
		exe	"setlocal makeprg=".makeprg_saved
		"
		if empty(v:statusmsg)
			let s:C_HlMessage = "'".Exe."' : linking successful"
		" open error window if necessary
		:redraw!
		exe	":botright cwindow"
		else
		  exe ":botright copen"
		endif
	endif
endfunction    " ----------  end of function C_Link ----------
"
"------------------------------------------------------------------------------
"  C_Run : 	C_Run       {{{1
"  calls: C_Link
"------------------------------------------------------------------------------
"
let s:C_OutputBufferName   = "C-Output"
let s:C_OutputBufferNumber = -1
let s:C_RunMsg1						 ="' does not exist or is not executable or object/source older then executable"
let s:C_RunMsg2						 ="' does not exist or is not executable"
"
function! C_Run ()
"
	let s:C_HlMessage = ""
	let Sou  					= expand("%:p")												" name of the source file
	let Obj  					= expand("%:p:r").s:C_ObjExtension		" name of the object file
	let Exe  					= expand("%:p:r").s:C_ExeExtension		" name of the executable
	let ExeEsc  			= escape( Exe, s:C_FilenameEscChar )	" name of the executable, escaped
	let Quote					= ''
	if s:MSWIN
		let Quote					= '"'
	endif
	"
	let l:arguments     = exists("b:C_CmdLineArgs") ? b:C_CmdLineArgs : ''
	"
	let	l:currentbuffer	= bufname("%")
	"
	"==============================================================================
	"  run : run from the vim command line
	"==============================================================================
	if s:C_OutputGvim == "vim"
		"
		if s:C_MakeExecutableToRun !~ "^\s*$"
			call C_HlMessage( "executable : '".s:C_MakeExecutableToRun."'" )
			exe		'!'.Quote.s:C_MakeExecutableToRun.Quote.' '.l:arguments
		else

			silent call C_Link()
			if s:LastShellReturnCode == 0
				" clear the last linking message if any"
				let s:C_HlMessage = ""
				call C_HlMessage()
			endif
			"
			if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
				exe		"!".Quote.ExeEsc.Quote." ".l:arguments
			else
				echomsg "file '".Exe.s:C_RunMsg1
			endif
		endif

	endif
	"
	"==============================================================================
	"  run : redirect output to an output buffer
	"==============================================================================
	if s:C_OutputGvim == "buffer"
		let	l:currentbuffernr	= bufnr("%")
		"
		if s:C_MakeExecutableToRun =~ "^\s*$"
			call C_Link()
		endif
		if l:currentbuffer ==  bufname("%")
			"
			"
			if bufloaded(s:C_OutputBufferName) != 0 && bufwinnr(s:C_OutputBufferNumber)!=-1
				exe bufwinnr(s:C_OutputBufferNumber) . "wincmd w"
				" buffer number may have changed, e.g. after a 'save as'
				if bufnr("%") != s:C_OutputBufferNumber
					let s:C_OutputBufferNumber	= bufnr(s:C_OutputBufferName)
					exe ":bn ".s:C_OutputBufferNumber
				endif
			else
				silent exe ":new ".s:C_OutputBufferName
				let s:C_OutputBufferNumber=bufnr("%")
				setlocal buftype=nofile
				setlocal noswapfile
				setlocal syntax=none
				setlocal bufhidden=delete
				setlocal tabstop=8
			endif
			"
			" run programm
			"
			setlocal	modifiable
			if s:C_MakeExecutableToRun !~ "^\s*$"
				call C_HlMessage( "executable : '".s:C_MakeExecutableToRun."'" )
				exe		'%!'.Quote.s:C_MakeExecutableToRun.Quote.' '.l:arguments
				setlocal	nomodifiable
				"
				if winheight(winnr()) >= line("$")
					exe bufwinnr(l:currentbuffernr) . "wincmd w"
				endif
			else
				"
				if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
					exe		"%!".Quote.ExeEsc.Quote." ".l:arguments
					setlocal	nomodifiable
					"
					if winheight(winnr()) >= line("$")
						exe bufwinnr(l:currentbuffernr) . "wincmd w"
					endif
				else
					setlocal	nomodifiable
					:close
					echomsg "file '".Exe.s:C_RunMsg1
				endif
			endif
			"
		endif
	endif
	"
	"==============================================================================
	"  run : run in a detached xterm  (not available for MS Windows)
	"==============================================================================
	if s:C_OutputGvim == "xterm"
		"
		if s:C_MakeExecutableToRun !~ "^\s*$"
			if s:MSWIN
				exe		'!'.Quote.s:C_MakeExecutableToRun.Quote.' '.l:arguments
			else
				silent exe '!xterm -title '.s:C_MakeExecutableToRun.' '.s:C_XtermDefaults.' -e '.s:C_Wrapper.' '.s:C_MakeExecutableToRun.' '.l:arguments.' &'
				:redraw!
				call C_HlMessage( "executable : '".s:C_MakeExecutableToRun."'" )
			endif
		else

			silent call C_Link()
			"
			if	executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
				if s:MSWIN
					exe		"!".Quote.ExeEsc.Quote." ".l:arguments
				else
					silent exe '!xterm -title '.ExeEsc.' '.s:C_XtermDefaults.' -e '.s:C_Wrapper.' '.ExeEsc.' '.l:arguments.' &'
					:redraw!
				endif
			else
				echomsg "file '".Exe.s:C_RunMsg1
			endif
		endif
	endif

endfunction    " ----------  end of function C_Run ----------
"
"------------------------------------------------------------------------------
"  C_Arguments : Arguments for the executable       {{{1
"------------------------------------------------------------------------------
function! C_Arguments ()
	let	Exe		  = expand("%:r").s:C_ExeExtension
  if empty(Exe)
		redraw
		echohl WarningMsg | echo "no file name " | echohl None
		return
  endif
	let	prompt	= 'command line arguments for "'.Exe.'" : '
	if exists("b:C_CmdLineArgs")
		let	b:C_CmdLineArgs= C_Input( prompt, b:C_CmdLineArgs, 'file' )
	else
		let	b:C_CmdLineArgs= C_Input( prompt , "", 'file' )
	endif
endfunction    " ----------  end of function C_Arguments ----------
"
"
"------------------------------------------------------------------------------
"  C_XtermSize : xterm geometry       {{{1
"------------------------------------------------------------------------------
function! C_XtermSize ()
	let regex	= '-geometry\s\+\d\+x\d\+'
	let geom	= matchstr( s:C_XtermDefaults, regex )
	let geom	= matchstr( geom, '\d\+x\d\+' )
	let geom	= substitute( geom, 'x', ' ', "" )
	let	answer= C_Input("   xterm size (COLUMNS LINES) : ", geom )
	while match(answer, '^\s*\d\+\s\+\d\+\s*$' ) < 0
		let	answer= C_Input(" + xterm size (COLUMNS LINES) : ", geom )
	endwhile
	let answer  = substitute( answer, '\s\+', "x", "" )						" replace inner whitespaces
	let s:C_XtermDefaults	= substitute( s:C_XtermDefaults, regex, "-geometry ".answer , "" )
endfunction    " ----------  end of function C_XtermSize ----------
"
"------------------------------------------------------------------------------
"  run make(1)       {{{1
"------------------------------------------------------------------------------
let s:C_MakeCmdLineArgs   	= ''   " command line arguments for Run-make; initially empty
let s:C_MakeExecutableToRun	= ''
let s:C_Makefile						= ''
"
"------------------------------------------------------------------------------
"  C_ChooseMakefile : choose a makefile       {{{1
"------------------------------------------------------------------------------
function! C_ChooseMakefile ()
	let s:C_Makefile	= ''
	" the path will be escaped:
	let	s:C_Makefile	= C_Input ( "choose a Makefile: ", getcwd(), "file" )
	if  s:MSWIN
		let	s:C_Makefile	= substitute( s:C_Makefile, '\\ ', ' ', 'g' )
	endif
endfunction    " ----------  end of function C_ChooseMakefile  ----------
"
"------------------------------------------------------------------------------
"  C_Make : run make       {{{1
"------------------------------------------------------------------------------
function! C_Make()
	exe	":cclose"
	" update : write source file if necessary
	exe	":update"
	" run make
	if s:C_Makefile == ''
		exe	":make ".s:C_MakeCmdLineArgs
	else
		exe	':lchdir  '.fnamemodify( s:C_Makefile, ":p:h" )
		if  s:MSWIN
			exe	':make -f "'.s:C_Makefile.'" '.s:C_MakeCmdLineArgs
		else
			exe	':make -f '.s:C_Makefile.' '.s:C_MakeCmdLineArgs
		endif
		exe	":lchdir -"
	endif
	exe	":botright cwindow"
	"
endfunction    " ----------  end of function C_Make ----------
"
"------------------------------------------------------------------------------
"  C_MakeClean : run 'make clean'       {{{1
"------------------------------------------------------------------------------
function! C_MakeClean()
	" run make clean
	if s:C_Makefile == ''
		exe	":make clean"
	else
		exe	':lchdir  '.fnamemodify( s:C_Makefile, ":p:h" )
		if  s:MSWIN
			exe	':make -f "'.s:C_Makefile.'" clean'
		else
			exe	':make -f '.s:C_Makefile.' clean'
		endif
		exe	":lchdir -"
	endif
endfunction    " ----------  end of function C_MakeClean ----------

"------------------------------------------------------------------------------
"  C_MakeArguments : get make command line arguments       {{{1
"------------------------------------------------------------------------------
function! C_MakeArguments ()
	let	s:C_MakeCmdLineArgs= C_Input( 'make command line arguments : ', s:C_MakeCmdLineArgs, 'file' )
endfunction    " ----------  end of function C_MakeArguments ----------

"------------------------------------------------------------------------------
"  C_MakeExeToRun : choose executable to run       {{{1
"------------------------------------------------------------------------------
function! C_MakeExeToRun ()
	let	s:C_MakeExecutableToRun = C_Input( 'executable to run [tab compl.]: ', '', 'file' )
	if s:C_MakeExecutableToRun !~ "^\s*$"
		if s:MSWIN
			let s:C_MakeExecutableToRun = substitute(s:C_MakeExecutableToRun, '\\ ', ' ', 'g' )
		endif
		let	s:C_MakeExecutableToRun = escape( getcwd().'/', s:C_FilenameEscChar ).s:C_MakeExecutableToRun
	endif
endfunction    " ----------  end of function C_MakeExeToRun ----------
"
"------------------------------------------------------------------------------
"------------------------------------------------------------------------------
"  C_Indent : run indent(1)       {{{1
"------------------------------------------------------------------------------
"
function! C_Indent ( )
	if !executable("indent")
		echomsg 'indent is not executable or not installed!'
		return
	endif
	let	l:currentbuffer=expand("%:p")
	if &filetype != "c" && &filetype != "cpp"
		echomsg '"'.l:currentbuffer.'" seems not to be a C/C++ file '
		return
	endif
	if C_Input("indent whole file [y/n/Esc] : ", "y" ) != "y"
		return
	endif
	:update

	exe	":cclose"
	if s:MSWIN
		silent exe ":%!indent "
	else
		silent exe ":%!indent 2> ".s:C_IndentErrorLog
		redraw!
		if getfsize( s:C_IndentErrorLog ) > 0
			exe ':edit! '.s:C_IndentErrorLog
			let errorlogbuffer	= bufnr("%")
			exe ':%s/^indent: Standard input/indent: '.escape( l:currentbuffer, '/' ).'/'
			setlocal errorformat=indent:\ %f:%l:%m
			:cbuffer
			exe ':bdelete! '.errorlogbuffer
			exe	':botright cwindow'
		else
			echomsg 'File "'.l:currentbuffer.'" reformatted.'
		endif
		setlocal errorformat=
	endif

endfunction    " ----------  end of function C_Indent ----------
"
"------------------------------------------------------------------------------
"  C_HlMessage : indent message     {{{1
"------------------------------------------------------------------------------
function! C_HlMessage ( ... )
	redraw!
	echohl Search
	if a:0 == 0
		echo s:C_HlMessage
	else
		echo a:1
	endif
	echohl None
endfunction    " ----------  end of function C_HlMessage ----------


"------------------------------------------------------------------------------
"  C_Input: Input after a highlighted prompt     {{{1
"           3. argument : optional completion
"------------------------------------------------------------------------------
function! C_Input ( promp, text, ... )
	echohl Search																					" highlight prompt
	call inputsave()																			" preserve typeahead
	if a:0 == 0 || empty(a:1)
		let retval	=input( a:promp, a:text )
	else
		let retval	=input( a:promp, a:text, a:1 )
	endif
	call inputrestore()																		" restore typeahead
	echohl None																						" reset highlighting
	let retval  = substitute( retval, '^\s\+', "", "" )		" remove leading whitespaces
	let retval  = substitute( retval, '\s\+$', "", "" )		" remove trailing whitespaces
	return retval
endfunction    " ----------  end of function C_Input ----------
"
"
"=====================================================================================
" vim: tabstop=2 shiftwidth=2 foldmethod=marker
