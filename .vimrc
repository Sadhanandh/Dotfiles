"helptags ~/.vim/doc
""easy motion \\w
""matchit %
""shft-K man pages in python too
"" ys add    (till) can be s //yss"    surround
"" cs change            be t //cst"
"" ds delete            be iw // ys3iw
"nerdcomment
"" \cc -> comment
"" \cu -> uncomment
"" \c$  -> end of line
"" \cA -> append after line

"" ce sparkup-
"" cy zen

"" \\e -> easymotion
"" \\w ->
"" \\fo -> 

"" cntl +f/b for cntl p plugin


set laststatus=2    "" for powerline
set bs=2            "" for compatibility
set title
set et!
set list
set expandtab
set tabstop=4
set shiftwidth=4
"map <F2> :retab <CR> :wq! <CR>

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

"
Bundle 'vim-scripts/AutoComplPop'
Bundle 'davidhalter/jedi-vim'
Bundle 'yandy/vim-omnicppcomplete'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'serby/vim-historic'
Bundle 'tsaleh/vim-matchit'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'
Bundle 'hallison/vim-markdown'
Bundle 'nvie/vim-flake8'
Bundle 'scrooloose/nerdtree'
Bundle 'majutsushi/tagbar'
Bundle 'Lokaltog/vim-powerline'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/syntastic'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'altercation/vim-colors-solarized'
Bundle 'Sadhanandh/vim-ivundler'
Bundle 'vim-scripts/python_match.vim'
Bundle 'myusuf3/numbers.vim'
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-fugitive'
Bundle 'changa/markdown-preview.vim'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'tomtom/tcomment_vim'
Bundle 'superjudge/tasklist-pathogen'
"Bundle 'HenningM/cvim-pathogen'
Bundle 'xuhdev/SingleCompile'
"
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'

Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/vim-snippets'
Bundle 'garbas/vim-snipmate'
"Bundle 'vim-multiple-cursors'




let loaded_minibufexplorer = 1

"let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_detect_filetype = 1
let g:gist_show_privates = 1
let g:gist_post_private = 1
let g:gist_open_browser_after_post = 1


"let g:MarkdownPreviewAlwaysOpen = 1
"let g:MarkdownPreviewTMP = '/tmp'
"let g:MarkdownPreviewUserStyles = ~/Sites/themes/markdown/
"let g:MarkdownPreviewDefaultStyles = $HOME.'/.vim/stylesheets/'
"let g:MarkdownPreviewRefreshDelay = 20
"




au BufRead,BufNewFile *.md set filetype=markdown
hi link mkdLineBreak Underlined

"http://stackoverflow.com/questions/726894/what-are-the-dark-corners-of-vim-your-mom-never-told-you-about?rq=1
cmap w!! w !sudo tee %


set wildmode=longest,list,full
set wildmenu
set wildignorecase

let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_depth = 5

"cabbrev q lcl\|q
"let $VIMHOME=expand('<sfile>:p:h:h')
"let g:C_CodeSnippets = $HOME."/Dropbox/codesnippets/"
set nu
set mouse=a
set cursorline  
set nocp
filetype plugin on
set undolevels=1000
set showmatch
set showmode
set autoindent
set smartindent
set ts=4
set sw=4
filetype indent on 
syntax enable
set background=dark
set showfulltag
set autoread
set ignorecase

"highlight search
set hlsearch
set spell
" can be made manual
set foldmethod=syntax
set foldlevel=20
set ttyfast

nnoremap j gj
nnoremap k gk
nnoremap 0 g0
nnoremap $ g$
" also in visual mode
vnoremap j gj
vnoremap k gk
vnoremap 0 g0
vnoremap $ g$

" set Term color to 256 (supports)
set t_Co=256 
" if solarized is enabled
let g:solarized_termcolors=256
colorscheme molokai
"colorscheme solarized
call togglebg#map("<F5>")
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#CompleteCpp


imap <C-Space> <C-x><C-o>
imap <C-@> <C-Space>
"imap <leader>d <C-x><C-i> 
"word completion
"imap <leader>d <C-x><C-l>
"line completion
"imap <leader>d <C-x><C-f>
"file completion
"imap <leader>d <C-x><C-k>
"dict completion
"" helpme
"if need full completion then do a control +d or control +l

hi clear SpellBad
hi SpellBad cterm=underline
autocmd FileType text set dictionary+=/usr/share/dict/words
"set thesaurus+=$HOME."/.vim/thesaurus/mthesaur.txt"
let $THe = $HOME."/.vim/thesaurus/mthesaur.txt"
set thesaurus+=$THe

let Tlist_Highlight_Tag_On_BufEnter = 1

"au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
"

"http://vim.wikia.com/wiki/Disable_automatic_comment_insertion
au FileType c,cpp setlocal comments-=:// comments+=f://
au FileType vim setlocal comments-=:" "comments+=f:"


inoremap <C-k>  <UP>
inoremap <C-j>  <DOWN>

"http://vimcasts.org/episodes/bubbling-text/
" Bubble single lines
nmap <C-Up> ddkP
nmap <C-Down> ddp
" Bubble multiple lines
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]


if has('win32')
    colorscheme desert
    set bs=2
    autocmd FileType cpp set tags+=./vimfiles/tags/cpp
else
    autocmd FileType cpp set tags+=~/.vim/tags/cpp
endif


" NerdTree
let NERDTreeShowBookmarks=1
" Syntastic
let g:syntastic_check_on_open=0
let g:syntastic_echo_current_error=1
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
let g:syntastic_enable_balloons = 1
let g:syntastic_loc_list_height=2
let g:syntastic_python_checkers=['pyflakes']
" Tagbar
let g:tagbar_width = 30

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std"]


let OmniCpp_LocalSearchDecl = 1 " use local search function, bracket on 1st column
let OmniCpp_DisplayMode = 1 

"Tabularize
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>


" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

"map <F12> :!ctags -R --c++-kinds=+pl --fields=+iaS --extra=+q .<CR>

"highlight CursorColumn guibg=#404040

" custom Abbreviations
cnoreabbrev cdc cd %:p:h <CR>
cnoreabbre vff !firefox %:p
"indent 
cnoreabbrev ind :!indent %
cnoreabbrev nt :NERDTreeToggle <CR>
cnoreabbrev tb :TagbarToggle <CR> 
cnoreabbrev na :NERDTreeToggle <CR>:TagbarToggle <CR> 

"autocmd FileType java map <silent><F9> :!javac %<cr>
"autocmd FileType java map <silent><C-F9> :!java %:t:r<cr>
"autocmd FileType java map <silent><F8> :!javac -Xlint:unchecked %<cr>
"autocmd FileType java map <silent><C-F8> :!java %:t:r 



"autocmd FileType cpp map <silent><F9> :!g++ -o %:r %<cr>
"autocmd FileType cpp map <silent><C-F9> :!./%:r<cr>
autocmd FileType cpp noremap <silent><F8> :call C_Run()<cr>
" File insert
map <leader>ff :r !echo ~/
" reg view
map <leader>] :reg<CR>
" Change Directory
nnoremap <leader>cdc :cd %:p:h<CR>:pwd<CR>
inoremap <C-space> <C-x><C-o>
" Zencoding
let g:user_zen_expandabbr_key = '<C-y>' 

"http://vim.wikia.com/wiki/Automatically_quit_Vim_if_quickfix_window_is_the_last
au BufEnter * call MyLastWindow()
function! MyLastWindow()
  " if the window is quickfix go on
  if &buftype=="quickfix"
    " if this window is last on screen quit without warning
    if winbufnr(2) == -1
      quit!
    endif
  endif
endfunction

nmap <F10> :SCViewResult <cr>
nmap <F9> :SCCompileRun<cr> 
nmap <F8> :SCCompile<cr>

noremap <C-F12> :SyntasticToggleMode <CR>
"noremap <C-F12> :SyntasticCheck <CR>
"autocmd FileType python map <silent><F9> :!python %<cr>
"autocmd FileType python map <silent>\rr :!python %<cr>
noremap <silent><F7> :SyntasticToggleMode <cr> 
noremap <silent><F6> :NumbersToggle<cr> 
noremap <silent><F5> :ToggleBG<CR>
noremap <silent><F4> :TagbarToggle<CR>
noremap <silent><F3> :NERDTreeToggle<cr>
noremap <silent><F2> :NERDTreeToggle %:p:h<CR> :TagbarToggle<CR> 
"noremap <silent><F3> :NERDTree %:p:h<CR> :TagbarOpen<CR> 
"nnoremap <leader>n :NumbersToggle<CR>

nmap <silent> <A-Up> :wincmd K<CR>
nmap <silent> <A-Down> :wincmd J<CR>
nmap <silent> <A-Left> :wincmd H<CR>
nmap <silent> <A-Right> :wincmd L<CR>

"numbers toggle
"let g:loaded_numbers = 1

let mapleader = "," " rebind <Leader> key

"jedi
"let g:jedi#auto_initialization = 0
let g:jedi#popup_on_dot = 0
let g:jedi#auto_vim_configuration = 0
"let g:jedi#popup_on_dot = 1
let g:jedi#popup_select_first = 0
let g:jedi#show_function_definition = 0
autocmd FileType python map <Leader>b Oimport ipdb; ipdb.set_trace() # BREAKPOINT<C-c>

vnoremap < <gv " better indentation
vnoremap > >gv " better indentation
map <Leader>a ggVG " select all
map <Leader>b gg=G " format
map <Leader>c :%!xmllint --format -<CR>

    
"let g:SimpylFold_docstring_preview = 1


"" set nobackup
"" set nowritebackup
"" set noswapfile


map <leader>s :set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<CR>

map <leader>h :AutoHeader<CR>

""inoremap ( ()<Esc>i
""inoremap " ""<Esc>i
""inoremap ' ''<Esc>i

iabbrev im I'm
