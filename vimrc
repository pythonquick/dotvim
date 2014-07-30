" Preamble ---------------------------------------------------------------- {{{
if has('win16') || has('win95') || has('win32') || has('win64')
    let $MYVIM=$HOME.'/.vim'
    let projdir = 'C:\project'
else
    let $MYVIM=$HOME.'/.vim'
    let projdir = 'projects'
endif

set rtp+=$MYVIM/bundle/vundle/
set rtp+=$MYVIM
call vundle#rc()

" vundle bundles / Plugins:
so $MYVIM/bundle.vim
so $MYVIM/plugin/bclose.vim

"}}}
" Basic options ----------------------------------------------------------- {{{
filetype indent on
filetype plugin on
syntax on
set autochdir           " Change directory to the current buffer
set autoread            " auto reload if file saved externally
set backspace=indent,eol,start    "allow backspacing everything in insert mode
set cmdheight=1         " Line height of command row at bottom of screen
set cursorline          " Highlight line that cursor is on
set complete=.,w,b,u,k
set complete-=i
set encoding=utf-8      " Default encoding
set guioptions-=L       " remove left-hand scroll bar
set guioptions-=T       " remove toolbar
set guioptions-=m       " remove menu bar
set guioptions-=r       " remove right-hand scroll bar
set hidden              " allow buffer switching without saving
set hlsearch            " Highlight search results
set ignorecase          " Ignore case when searching
set incsearch           " Incrementally search as you type search string
set include=
set laststatus=2        " Always show status line
set lazyredraw          " Do not redraw during macro execution
set list                " Display the following unprintable characters:
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set nocompatible        " We don't need to be compatible with old vi
set number              " Show current line number
                        " Paths to search for gf command (file under cursor):
set path=.
set path+=..\\..\\scripts\\en-us
set path+=..\\..\\root\\**
set path+=..\\..\\include\\mssql
set path+=..\\..\\include\\oracle
set path+=..\\..\\DBInstallScripts\mssql\PMA\\**
set path+=..\\..\\..\\..\\DBInstallScripts\mssql\PMA\\**
set path+=..\\..\\..\\..\\DBInstallScripts\mssql\PMA\\**
set path+=..\\..\\DBInstallScripts\oracle\PMA\\**
set path+=..\\..\\..\\..\\DBInstallScripts\oracle\PMA\\**
set path+=..\\..\\..\\..\\DBInstallScripts\oracle\PMA\\**
set path+=**
set scrolloff=1         " Scroll to show at least 1 line above/below cursor
set shiftround          " When shifting/tabbing, fill to multiple of shiftwidth
set showbreak=↪         " Character showing line wrap
set showcmd             " show number of chars/lines selected in status line
set showmatch           " Briefly show matching bracket/paren
set smartcase           " auto-detect whehter to search case-sensitive or not
set spelllang=en_us     " English U.S. dictionary for spel checking
set suffixesadd+=.HTM
set suffixesadd+=.sql
set t_Co=256            " Use 256 colors in terminal mode
set ttyfast             " Assume fast network connection for terminal mode
set visualbell          " Visual 'bell' instead of beeping

"}}}
" Tabs, spaces, wrapping -------------------------------------------------- {{{
set autoindent
set colorcolumn=80
set expandtab
set linebreak
set shiftwidth=4
set smartindent
set tabstop=4
set wrap
" ------------------------------------------------------------------------- }}}
" Functions --------------------------------------------------------------- {{{


command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
" Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction


function! GenCTags()
    let cwd = getcwd()
    let projects_root = finddir(g:projdir, ';')
    let dir = cwd
    " Find the project_dir which is the sub-directory of the projects_root
    " and an ancester directory of current buffer's file.
    let project_dir = dir
    let root_not_reached = 1 " value 0 means project_dir could not be found
    while (dir != projects_root) && root_not_reached
        let project_dir = dir
        let dir = fnamemodify(dir, ':h')
        if dir == project_dir
            let root_not_reached = 0
        endif
    endwhile
    " Generate tags file in project_dir if found, otherwise in buffer dir
    if root_not_reached
        execute "cd " . project_dir
        silent !ctags -R --languages=javascript,python .
        execute "cd " . cwd
        echo "Generated tags file in " . project_dir
    else
        silent !ctags -R --languages=javascript,python .
        echo "Generated tags file in current buffer directory"
    endif
endfunction


function! EnsureExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path))
    endif
endfunction


function! Relpath(filename)
    let cwd = getcwd()
    let s = substitute(a:filename, l:cwd . "/" , "", "")
    return s
endfunction


function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction


function! MyFoldText()
    let line = getline(v:foldstart)
    let windowwidth = 85
    let foldedlinecount = v:foldend - v:foldstart
    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    let line = line . repeat(" ",fillcharcount) . foldedlinecount . ' lines' . ' '
    let line = line . repeat(" ", 97 - len(line))
    return line
endfunction


" Show syntax highlighting groups for word under cursor
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


" Functions --------------------------------------------------------------- }}}
" Folding ----------------------------------------------------------------- {{{
set foldmethod=marker
set foldlevelstart=0
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
set foldtext=MyFoldText()
" }}}
" Searching --------------------------------------------------------------- {{{
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

" ------------------------------------------------------------------------- }}}
" Auto commands ----------------------------------------------------------- {{{


if has("autocmd")
    augroup filetype
        autocmd!
        autocmd BufRead *imap set syntax=java
    augroup END

    augroup focus
        autocmd!
        autocmd FocusLost * silent! wa " auto-save but don't complain about new buffers
    augroup END

    " Make sure Vim returns to the same line when you reopen a file.
    augroup line_return
        autocmd!
        autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     execute 'normal! g`"zvzz' |
            \ endif
    augroup END
endif
"}}}
" Key remapping ----------------------------------------------------------- {{{
" Remap window cursor jumps without the Ctrl-W prefix
nnoremap <C-j> <C-w><C-j>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Use sane regexes.
nnoremap / /\v
vnoremap / /\v

" Remap home keys for cursor positioning on line:
nnoremap H ^
vnoremap H ^
nnoremap L g_
vnoremap L g_

" Remap Y to yank from cursor to end of line instead of yank complete line:
nnoremap Y y$

" Omnicompletion (C-x C-x) handling for popup menu. Allows C-n and C-p
"inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
"inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap ,. <C-X><C-O>

" Alternative esc mapping:
inoremap jk <esc>

" Fast save:
inoremap ,w <esc>:write<CR>

" Training mappings:
inoremap <esc> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
nnoremap <up> <nop>
nnoremap <down> <nop>

" scroll line instead of half page, keeping cursor on current screen position:
nnoremap <C-d> <C-e>j
nnoremap <C-u> <C-y>k

let mapleader = ","
let maplocalleader = "\\"

" Leader mappings:
nnoremap <leader>= mlgg=G'l
nnoremap <leader>a :%ya *<CR>
nnoremap <leader>c :call HexHighlight()<CR>
nnoremap <leader>D :Bclose!<CR>
nnoremap <leader>d :silent! write<CR>:Bclose<CR>
nnoremap <leader>eA :e ~/A4Installs<CR>
nnoremap <leader>eM :e ~/projects/A4MobileTime<CR>
nnoremap <leader>eb :e $MYVIM/bundle.vim<CR>
nnoremap <leader>ee :e .<CR>
nnoremap <leader>ef :e /Users/Guenther/.vim/bundle/vundle/syntax/a4html.vim<CR>
nnoremap <leader>eP :e ~/projects<CR>
if has('win16') || has('win95') || has('win32') || has('win64')
    nnoremap <leader>eT :e c:\temp<CR>
    nnoremap <leader>et :e c:/Temp/Temp.txt<CR>
else
    nnoremap <leader>eT :e ~/Temp<CR>
    nnoremap <leader>et :e ~/Temp/Temp.txt<CR>
endif
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>eV :e $MYVIM<CR>
nnoremap <leader>h :nohl<CR>
nnoremap <leader>fj :%!python -m json.tool<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>q :call ToggleQuickfixList()<CR>
nnoremap <leader>Q :q<CR>
nnoremap <leader>sa :e ~/.vim/UltiSnips/all.snippets<CR>
nnoremap <leader>ss :UltiSnipsEdit<CR>
nnoremap <leader>tc :TernDoc<CR>
nnoremap <leader>ty :TernType<CR>
nnoremap <leader>tr :TernRef<CR>
nnoremap <leader>tR :TernRename<CR>
nnoremap <leader>tt :TernDef<CR>zt
nnoremap <leader>v :source $MYVIMRC<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>W ml:%s/\s\+$//e<CR>`l
nnoremap <leader>x :silent !./%<CR>
nnoremap <leader>X :!./%<CR>
nnoremap <leader>q :call ToggleQuickfixList()<CR>
nnoremap <leader>v :source $MYVIMRC<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>W :%s/\s\+$//e<CR><C-o>
nnoremap <leader>x :silent !./%<CR>
nnoremap <leader>X :!./%<CR>

" Quick-close current window
nnoremap Q :q<CR>

" Alias the * (Star) clipboard register with s
nnoremap "s "*
vnoremap "s "*

" Register a word-replace shortcuts
nnoremap <leader>ra viw"ap
vnoremap <leader>ra "ap
" Register b word-replace shortcuts
nnoremap <leader>rb viw"bp
vnoremap <leader>rb "bp
" Register c word-replace shortcuts
nnoremap <leader>rc viw"cp
vnoremap <leader>rc "cp
" Register d word-replace shortcuts
nnoremap <leader>rd viw"dp
vnoremap <leader>rd "dp
" Register e word-replace shortcuts
nnoremap <leader>re viw"ep
vnoremap <leader>re "ep
" Register f word-replace shortcuts
nnoremap <leader>rf viw"fp
vnoremap <leader>rf "fp
" Register g word-replace shortcuts
nnoremap <leader>rg viw"gp
vnoremap <leader>rg "gp

" Register a word-cut shortcuts
nnoremap <leader>ca viw"ad
vnoremap <leader>ca "ad
" Register b word-cut shortcuts
nnoremap <leader>cb viw"bd
vnoremap <leader>cb "bd
" Register c word-cut shortcuts
nnoremap <leader>cc viw"cd
vnoremap <leader>cc "cd
" Register d word-cut shortcuts
nnoremap <leader>cd viw"dd
vnoremap <leader>cd "dd
" Register e word-cut shortcuts
nnoremap <leader>ce viw"ed
vnoremap <leader>ce "ed
" Register f word-cut shortcuts
nnoremap <leader>cf viw"fd
vnoremap <leader>cf "fd
" Register g word-cut shortcuts
nnoremap <leader>cg viw"gd
vnoremap <leader>cg "gd

" Register * (Star) clipboard copy shortcuts
nnoremap <leader>,s mz"*yiw`z
vnoremap <leader>,s mz"*y`z
" Register a copy shortcuts
nnoremap <leader>,a mz"ayiw`z
vnoremap <leader>,a mz"ay`z
" Register b copy shortcuts
nnoremap <leader>,b mz"byiw`z
vnoremap <leader>,b mz"by`z
" Register c copy shortcuts
nnoremap <leader>,c mz"cyiw`z
vnoremap <leader>,c mz"cy`z
" Register d copy shortcuts
nnoremap <leader>,d mz"dyiw`z
vnoremap <leader>,d mz"dy`z
" Register e copy shortcuts
nnoremap <leader>,e mz"eyiw`z
vnoremap <leader>,e mz"ey`z
" Register f copy shortcuts
nnoremap <leader>,f mz"fyiw`z
vnoremap <leader>,f mz"fy`z
" Register g copy shortcuts
nnoremap <leader>,g mz"gyiw`z
vnoremap <leader>,g mz"gy`z

" Register * (Star) paste shortcuts:
nnoremap <leader>mS "*P
nnoremap <leader>ms "*p
vnoremap <leader>ms "*p
" Register a paste shortcuts:
nnoremap <leader>mA "aP
nnoremap <leader>ma "ap
vnoremap <leader>ma "ap
" Register b paste shortcuts:
nnoremap <leader>mB "bP
nnoremap <leader>mb "bp
vnoremap <leader>mb "bp
" Register c paste shortcuts:
nnoremap <leader>mC "cP
nnoremap <leader>mc "cp
vnoremap <leader>mc "cp
" Register d paste shortcuts:
nnoremap <leader>mD "dP
nnoremap <leader>md "dp
vnoremap <leader>md "dp
" Register e paste shortcuts:
nnoremap <leader>mE "eP
nnoremap <leader>me "ep
vnoremap <leader>me "ep
" Register f paste shortcuts:
nnoremap <leader>mF "fP
nnoremap <leader>mf "fp
vnoremap <leader>mf "fp
" Register g paste shortcuts:
nnoremap <leader>mG "gP
nnoremap <leader>mg "gp
vnoremap <leader>mg "gp

" Search word, but stay on initial word:
nnoremap * *<c-o>

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>

 " Center cursor when jumping to next/prev search result:
nnoremap n nzz
nnoremap N Nzz

" Insert timestamp:
nmap <F3> a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>
imap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>


" Change font in GUI mode:
if has("gui_running")
    if has('win16') || has('win95') || has('win32') || has('win64')
        nmap <F6> :set guifont=Inconsolata-dz_for_Powerline:cANSI:h13
    else
        nmap <F6> :set guifont=Inconsolata-dz\ for\ Powerline:h16
    endif
endif

" ctags:
nnoremap <F5> :call GenCTags()<CR>

" Jump easier to matching bracket/paren/tag using M instead of %:
nmap M %
vmap M %

" change word to upper-case (useful for typing uppercase contants):
" inoremap <c-k> <esc>hviwUea

inoremap <c-f> <c-x><c-f>
noremap <space> za

vmap ,x :!tidy -q -i -xml<CR>

" shortcut for angle bracket text objects:
onoremap ir i[
onoremap ar a[
vnoremap ir i[
vnoremap ar a[

" other operator-pending mappings:
" F for Function name before the first "(" character of current line:
onoremap F :<c-u>normal! 0f(hviw<CR>

"}}}
" Wildmenu completion ----------------------------------------------------- {{{

set wildmenu
set wildmode=list:longest

if !(has('win16') || has('win95') || has('win32') || has('win64'))
    set wildignorecase
endif

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files
set wildignore+=*.mdf                            " SQL Server database
set wildignore+=*.ldf                            " SQL Server database
set wildignore+=*.zip
set wildignore+=*.tar
set wildignore+=*.jar
set wildignore+=*.cab
set wildignore+=*.log
set wildignore+=tags
set wildignore+=errmsgs\\**
set wildignore+=drillaround\\**
set wildignore+=ImportData\\**
set wildignore+=Logs\\**
set wildignore+=help\\**
set wildignore+=Patches\\**
set wildignore+=Reports\\**
set wildignore+=repsrce\\**
set wildignore+=root\kendo\\**
set wildignore+=..\\..\\errmsgs\\**
set wildignore+=..\\..\\drillaround\\**
set wildignore+=..\\..\\ImportData\\**
set wildignore+=..\\..\\Logs\\**
set wildignore+=..\\..\\help\\**
set wildignore+=..\\..\\Patches\\**
set wildignore+=..\\..\\Reports\\**
set wildignore+=..\\..\\repsrce\\**
set wildignore+=..\\..\\root\kendo\\**

" ------------------------------------------------------------------------- }}}
" Ctags ------------------------------------------------------------------- {{{

set tags=./tags;tags

" ------------------------------------------------------------------------- }}}
" Plugin configuration ---------------------------------------------------- {{{

" EasyMotion configuration
" ------------------------
let g:EasyMotion_mapping_b = '[w'
let g:EasyMotion_mapping_w = ']w'
let g:EasyMotion_mapping_j = ']r'
let g:EasyMotion_mapping_k = '[r'
let g:EasyMotion_keys = 'abcdefghijklmNopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,.;'
let g:EasyMotion_leader_key = '!'

" NERDTree configuration:
" -----------------------
let NERDTreeQuitOnOpen = 1

" UltiSnips configuration:
" ------------------------
let g:UltiSnipsEditSplit = 'vertical'

" TernJS configuration:
" ---------------------
let g:tern_show_argument_hints = 'no'

" Airline (Vim status line) configuration:
" ----------------------------------------
if !exists("g:airline_symbols")
  let g:airline_symbols = {}
endif
let g:airline_theme="powerlineish"
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#empty_message = "No SCM"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_inactive_collapse=0
let g:airline#extensions#hunks#non_zero_only = 1 " git gutter
let g:airline_section_b = '%{getcwd()}'
let g:airline_section_c = ''
let g:airline_detect_whitespace=0
if has("gui_running")
    let g:Powerline_symbols = 'fancy'
else
    let g:airline_left_sep=''
    let g:airline_right_sep=''
    let g:airline#extensions#tabline#left_sep = ''
    let g:airline#extensions#tabline#left_alt_sep = ''
    let g:airline#extensions#tabline#right_sep = ''
    let g:airline#extensions#tabline#right_alt_sep = ''
endif

" Syntastic configuration:
" ------------------------
let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['javascript', 'c'],
                            \ 'passive_filetypes': ['puppet'] }
let g:syntastic_html_tidy_ignore_errors = [
    \"trimming empty <i>",
    \"trimming empty <span>",
    \"trimming empty <h1>",
    \"trimming empty <li>",
    \"<img> lacks \"alt\" attribute",
    \"<input> proprietary attribute \"pattern\"",
    \"<input> proprietary attribute \"min\"",
    \"<input> proprietary attribute \"max\"",
    \"<input> proprietary attribute \"autocomplete\"",
    \"proprietary attribute \"role\"",
    \"proprietary attribute \"hidden\"",
\]
let g:syntastic_javascript_checkers = ['jshint']

" CtrlP configuration:
" --------------------
let g:ctrlp_map = '\'
let g:ctrlp_use_caching = 1             " Enable caching
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $CtrlPCache
let g:ctrlp_match_window_bottom = 1     " Match window at bottom of screen

" Snippet configuration:
" ----------------------
let g:snippets_dir = $MYVIM."/snippets"

" Molokai colorscheme configuration:
" ----------------------------------
let g:molokai_original = 0


" --------------------------------------------------------------------------}}}
" Vim file/folder management ---------------------------------------------- {{{
call EnsureExists('$MYVIM/.cache')
" persistent undo
" if exists('+undofile')
"     set undofile
"     set undodir=$MYVIM/.cache/undo
"     call EnsureExists(&undodir)
" endif
" backups
set backup
set backupdir=$MYVIM/.cache/backup
call EnsureExists(&backupdir)
" swap files
set directory=$MYVIM/.cache/swap
set noswapfile
call EnsureExists(&directory)
" CtrlP cache:
let $CtrlPCache='$MYVIM/.cache/ctrlp'
call EnsureExists($CtrlPCache)
" ------------------------------------------------------------------------- }}}
" Miscellaneous ----------------------------------------------------------- {{{

" vmath plugin configuration
vmap <expr>  ++  VMATH_YankAndAnalyse()

command! PrettyXML call DoPrettyXML()
" ------------------------------------------------------------------------- }}}
" GUI mode and Colorscheme ------------------------------------------------ {{{
if has("gui_running")
    if has('win16') || has('win95') || has('win32') || has('win64')
        set guifont=Inconsolata-dz_for_Powerline:h13:cANSI
    else
        set guifont=Inconsolata-dz\ for\ Powerline:h16
    endif
    " Override colorscheme cursor background on highlighted search result:
    exec "hi Cursor guifg=bg guibg=Green"
    autocmd ColorScheme * hi Cursor guifg=bg guibg=Green

    " Override listcar (e.g. end of line char) color:
    exec "hi NonText ctermfg=7 guifg=#135560"
    autocmd ColorScheme * hi NonText ctermfg=7 guifg=#135560
endif

set background=dark
colo badwolf
" ------------------------------------------------------------------------- }}}
" Abbreviations ----------------------------------------------------------- {{{
iabbrev adn and
iabbrev functino function
iabbrev teh the
iabbrev tehn then
iabbrev waht what
" ------------------------------------------------------------------------- }}}
" Disabled / Unused --------------------------------------------------------{{{
"set go-=T
"set ttimeoutlen=50
"nnoremap <leader>z 1z=]s
" --------------------------------------------------------------------------}}}

