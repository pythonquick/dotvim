" Preamble ---------------------------------------------------------------- {{{
if has('win16') || has('win95') || has('win32') || has('win64')
    let $MYVIM=$HOME.'/.vim'
    let projdir = 'C:\project'
else
    let $MYVIM=$HOME.'/dotfiles/dotvim'
    let projdir = 'projects'
endif
so $MYVIM/autoload/bclose.vim
set rtp+=$MYVIM
runtime macros/matchit.vim
"}}}
" Basic options ----------------------------------------------------------- {{{
filetype plugin indent on
syntax on
set autochdir           " Change directory to the current buffer
set autoread            " auto reload if file saved externally
set backspace=indent,eol,start    "allow backspacing everything in insert mode
set cmdheight=1         " Line height of command row at bottom of screen
set cursorline          " Highlight line that cursor is on
set complete=.,w,b,u,k
set complete-=i
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
set mouse=a
set nocompatible        " We don't need to be compatible with old vi
set nu                  " Show current line number
set path=.
set path+=**
set path+=~/projects/MinimoServer/app/lib
set scrolloff=1         " Scroll to show at least 1 line above/below cursor
set shiftround          " When shifting/tabbing, fill to multiple of shiftwidth
set showbreak=↪         " Character showing line wrap
set showcmd             " show number of chars/lines selected in status line
set showmatch           " Briefly show matching bracket/paren
set smartcase           " auto-detect whehter to search case-sensitive or not
set spelllang=en_us     " English U.S. dictionary for spel checking
set suffixesadd+=.HTM
set suffixesadd+=.sql
set suffixesadd+=.js
set t_Co=256            " Use 256 colors in terminal mode
set ttyfast             " Assume fast network connection for terminal mode
set visualbell          " Visual 'bell' instead of beeping
set updatetime=100      " Change default update time from 4 seconds to 100ms
set wrapscan            " Continue search if end of file reached
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
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
function! EnsureExists(path)
    if !isdirectory(expand(a:path))
        call mkdir(expand(a:path))
    endif
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
" Functions --------------------------------------------------------------- }}}
" Folding ----------------------------------------------------------------- {{{
set foldmethod=marker
set foldlevelstart=0
" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za
set foldtext=MyFoldText()
" }}}
" Auto commands ----------------------------------------------------------- {{{
if has("autocmd")
    augroup filetype
        autocmd!
        autocmd BufRead *imap set syntax=java
        autocmd BufRead *sql set syntax=plsql
        autocmd BufReadPost * set iskeyword=@,48-57,_,192-255
    augroup END

    " Make sure Vim returns to the same line when you reopen a file.
    augroup line_return
        autocmd!
        autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     execute 'normal! g`"zvzz' |
            \ endif
    augroup END

    augroup rubyfiles
        autocmd!
        autocmd FileType ruby setlocal sw=2 ts=2 sts=2
        autocmd FileType ruby setlocal suffixesadd+=.rb
        autocmd FileType ruby setlocal path+=~/projects/MinimoServer/app
        autocmd FileType ruby setlocal path+=~/projects/MinimoServer/app/controllers/api/v1
        autocmd FileType ruby setlocal omnifunc=LanguageClient#complete
    augroup END

    augroup cssfiles
        autocmd!
        autocmd FileType css setlocal sw=2 ts=2 sts=2
        autocmd FileType css setlocal suffixesadd+=.css
        autocmd FileType ruby setlocal omnifunc=LanguageClient#complete
    augroup END

    augroup javascriptfiles
        autocmd!
        autocmd FileType javascript setlocal sw=2 ts=2 sts=2
        autocmd FileType javascript setlocal suffixesadd+=.js
        autocmd FileType javascript setlocal path+=~/projects/MinimoServer/frontend/app
        autocmd FileType javascript setlocal omnifunc=LanguageClient#complete
    augroup END

    augroup handlebarsfiles
        autocmd!
        autocmd FileType html.handlebars setlocal sw=2 ts=2 sts=2
        autocmd FileType html.handlebars setlocal suffixesadd+=.hbs
    augroup END

    " Disable auto-completion for text files:
    autocmd FileType text let b:coc_suggest_disable = 1

    " When switching to neovim terminal buffer, go into insert mode
    " autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
endif
"}}}
" Key remapping ----------------------------------------------------------- {{{
" Remap window cursor jumps without the Ctrl-W prefix
nnoremap <C-j> <C-w><C-j>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
inoremap <C-j> <esc><C-w><C-j>
inoremap <C-h> <esc><C-w><C-h>
inoremap <C-k> <esc><C-w><C-k>
inoremap <C-l> <esc><C-w><C-l>

" Resize panes using arrow keys:
nnoremap <Left> :vertical resize -1<CR>
nnoremap <Right> :vertical resize +1<CR>
nnoremap <Up> :resize -1<CR>
nnoremap <Down> :resize +1<CR>

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

" Alternative esc mapping:
inoremap jk <esc>

" Alternative esc mapping for terminal buffer:
tnoremap jk <C-\><C-n>

" Fast save:
inoremap ,w <esc>:write<CR>

" scroll line instead of half page, keeping cursor on current screen position:
nnoremap <C-d> <C-e>j
nnoremap <C-u> <C-y>k

let mapleader = ","
let maplocalleader = "\\"

" Leader mappings:
nnoremap <leader>= mlgg=G'l
nnoremap <leader>ay :%ya *<CR>
nnoremap <leader>ad :%de *<CR>
nnoremap <leader>ar :%de<CR>"*P<CR>
nnoremap <leader>c :!`git rev-parse --show-toplevel`/.git/hooks/ctags >/dev/null<CR>
nnoremap <leader>b :cd..<CR>
nnoremap <leader>D :Bclose!<CR>
nnoremap <leader>d :Bclose<CR>

if has('win16') || has('win95') || has('win32') || has('win64')
    nnoremap <leader>eT :e c:\temp<CR>
    nnoremap <leader>et :e c:/Temp/Temp.txt<CR>
else
    nnoremap <leader>ea :e ~/Temp/airtable.txt<CR>
    nnoremap <leader>ed :e ~/Temp/disc.txt<CR>
    nnoremap <leader>et :e ~/Temp/Temp.txt<CR>
    nnoremap <leader>en :e ~/Temp/notifications.txt<CR>
    nnoremap <leader>es :e ~/Temp/st.txt<CR>
    nnoremap <leader>ef :e ~/Temp/spec-failures.txt<CR>
endif
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>eV :e $MYVIM<CR>
nnoremap <leader>h :nohl<CR>

" indentation mappings:
nnoremap <leader>ij :%!python -m json.tool<CR>

" Shortcuts for invoking ag (silver searcher) in common directories:
"nnoremap <leader>ff :Grepper -grepprg ag $* --vimgrep ~/projects/MinimoServer/frontend/app<CR>
nnoremap <leader>ff :Grepper -grepprg ag $* --vimgrep ~/projects/MinimoServer/frontend/app<CR>
nnoremap <leader>fa :Grepper -grepprg ag $* --vimgrep ~/projects/MinimoServer/app ~/projects/MinimoServer/config<CR>
nnoremap <leader>fc :Grepper -grepprg ag $* --vimgrep ~/projects/MinimoServer/spec/cypress_tests/cypress<CR>
nnoremap <leader>fr :Grepper -dir repo -grepprg ag $* --vimgrep<CR>
"nnoremap <leader>fs :Grepper -grepprg ag $* --vimgrep ~/projects/MinimoServer/spec<CR>
nnoremap <leader>fs :Grepper -grepprg ag $* --vimgrep ~/projects/MinimoServer/spec --ruby<CR>

nnoremap <leader>wff :Grepper -cword -grepprg ag $* --vimgrep ~/projects/MinimoServer/frontend/app<CR>
nnoremap <leader>wfa :Grepper -cword -grepprg ag $* --vimgrep ~/projects/MinimoServer/app<CR>
nnoremap <leader>wfs :Grepper -cword -grepprg ag $* --vimgrep ~/projects/MinimoServer/spec<CR>
nnoremap <leader>wfr :Grepper -dir repo -cword -grepprg ag $* --vimgrep<CR>

nnoremap <leader>fS "syiw:Grepper -grepprg ag $* --vimgrep ~/projects/MinimoServer/spec<CR>a<C-r>s

" Shortcut for invoking ag (silver searcher) from current directory:
nnoremap <leader>fp :Grepper -grepprg ag $* --vimgrep<CR>

" Shortcuts for git (fugitive plugin):
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gs :Gstatus<CR>

" Insert timestamp:
nnoremap <leader>ts a<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>

nnoremap <leader>k :set iskeyword=@,48-57,_,192-255<CR>
nnoremap <leader>M :%s/\n//
nnoremap <leader>n :NERDTreeFind<CR>
nnoremap <leader>N :NERDTree<CR>
nnoremap <leader>p :pc<CR>
nnoremap <leader>Q :q<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>W ml:%s/\s\+$//e<CR>`l
nnoremap <leader>v :source $MYVIMRC<CR>
nnoremap <leader>u yyp0v$hr
nnoremap <leader>w :write<CR>
nnoremap <leader>W :%s/\s\+$//e<CR><C-o>

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
" Register h word-replace shortcuts
nnoremap <leader>rh viw"hp
vnoremap <leader>rh "hp
" Register i word-replace shortcuts
nnoremap <leader>ri viw"ip
vnoremap <leader>ri "ip
" Register j word-replace shortcuts
nnoremap <leader>rj viw"jp
vnoremap <leader>rj "jp
" Register k word-replace shortcuts
nnoremap <leader>rk viw"kp
vnoremap <leader>rk "kp
" Register l word-replace shortcuts
nnoremap <leader>rl viw"lp
vnoremap <leader>rl "lp

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
" Register h word-cut shortcuts
nnoremap <leader>ch viw"hd
vnoremap <leader>ch "hd
" Register i word-cut shortcuts
nnoremap <leader>ci viw"id
vnoremap <leader>ci "id
" Register j word-cut shortcuts
nnoremap <leader>cj viw"jd
vnoremap <leader>cj "jd
" Register k word-cut shortcuts
nnoremap <leader>ck viw"kd
vnoremap <leader>ck "kd
" Register l word-cut shortcuts
nnoremap <leader>cl viw"ld
vnoremap <leader>cl "ld

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
" Register h copy shortcuts
nnoremap <leader>,h mz"hyiw`z
vnoremap <leader>,h mz"hy`z
" Register i copy shortcuts
nnoremap <leader>,i mz"iyiw`z
vnoremap <leader>,i mz"iy`z
" Register j copy shortcuts
nnoremap <leader>,j mz"jyiw`z
vnoremap <leader>,j mz"jy`z
" Register k copy shortcuts
nnoremap <leader>,k mz"kyiw`z
vnoremap <leader>,k mz"ky`z
" Register l copy shortcuts
nnoremap <leader>,l mz"lyiw`z
vnoremap <leader>,l mz"ly`z

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
" Register h paste shortcuts:
nnoremap <leader>mH "hP
nnoremap <leader>mh "hp
vnoremap <leader>mh "hp
" Register i paste shortcuts:
nnoremap <leader>mI "iP
nnoremap <leader>mi "ip
vnoremap <leader>mi "ip
" Register j paste shortcuts:
nnoremap <leader>mJ "jP
nnoremap <leader>mj "jp
vnoremap <leader>mj "jp
" Register k paste shortcuts:
nnoremap <leader>mK "kP
nnoremap <leader>mk "kp
vnoremap <leader>mk "kp
" Register l paste shortcuts:
nnoremap <leader>mL "lP
nnoremap <leader>ml "lp
vnoremap <leader>ml "lp

" Copy visual selection to clipboard:
vnoremap * "*y

" Search word, but stay on initial word:
nnoremap * *<c-o>

 " Center cursor when jumping to next/prev search result:
nnoremap n nzz
nnoremap N Nzz




" Change font in GUI mode:
if has("gui_running")
    if has('win16') || has('win95') || has('win32') || has('win64')
        nmap <F6> :set guifont=Inconsolata-dz_for_Powerline:cANSI:h13
    else
        nmap <F6> :set guifont=Inconsolata-dz\ for\ Powerline:h16
    endif
endif

" Jump easier to matching bracket/paren/tag using M instead of %:
nmap M %
vmap M %

" change word to upper-case (useful for typing uppercase contants):
" inoremap <c-k> <esc>hviwUea

inoremap <c-f> <c-x><c-f>
noremap <space> za

vmap ,x :!tidy -q -i -xml<CR>

" other operator-pending mappings:
" F for Function name before the first "(" character of current line:
onoremap F :<c-u>normal! 0f(hviw<CR>

if has('nvim')
    " Window split settings
    highlight TermCursor ctermfg=red guifg=red
    set splitbelow
    set splitright

    " Terminal settings
    tnoremap <Leader><ESC> <C-\><C-n>

    " Window navigation function
    " Make ctrl-h/j/k/l move between windows and auto-insert in terminals
    func! s:mapMoveToWindowInDirection(direction)
        func! s:maybeInsertMode(direction)
            stopinsert
            execute "wincmd" a:direction

            if &buftype == 'terminal'
                startinsert!
            endif
        endfunc

        execute "tnoremap" "<silent>" "<C-" . a:direction . ">"
                    \ "<C-\\><C-n>"
                    \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
        execute "nnoremap" "<silent>" "<C-" . a:direction . ">"
                    \ ":call <SID>maybeInsertMode(\"" . a:direction . "\")<CR>"
    endfunc
    for dir in ["h", "j", "l", "k"]
        call s:mapMoveToWindowInDirection(dir)
    endfor
endif

" Filetype-specific mappings:
autocmd Filetype elixir inoremap <buffer> pyp \|><Space>
autocmd Filetype javascript nmap <buffer> <c-]> gd

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
set wildignore+=*.CAB
set wildignore+=*.orig
set wildignore+=*.tar
set wildignore+=*.jar
set wildignore+=*.cab
set wildignore+=*.log
set wildignore+=*.ipa
set wildignore+=*.exe
set wildignore+=tags
set wildignore+=*\\repsrce\\**
set wildignore+=errmsgs\\**
set wildignore+=drillaround\\**
set wildignore+=ImportData\\**
set wildignore+=Logs\\**
set wildignore+=tmp\\**

set wildignore+=*/tmp/*
set wildignore+=*/bower_components/*
set wildignore+=*/node_modules/*
set wildignore+=*/vendor/*
set wildignore+=*/dist/*

set wildignore+=tmp/**
set wildignore+=bower_components/**
set wildignore+=node_modules/**
set wildignore+=vendor/**
set wildignore+=dist/**
set wildignore+=*/vendor/**
set wildignore+=vendor
set wildignore+=vendor/**
set wildignore+=vendor/*


" ------------------------------------------------------------------------- }}}
" Ctags ------------------------------------------------------------------- {{{
set tags=./tags;tags
" ------------------------------------------------------------------------- }}}
" Plugin configuration ---------------------------------------------------- {{{

" EasyMotion configuration
" ------------------------
map <Leader>.l <Plug>(easymotion-lineforward)
map <Leader>.j <Plug>(easymotion-j)
map <Leader>.k <Plug>(easymotion-k)
map <Leader>.h <Plug>(easymotion-linebackward)

nmap <Leader>.s <Plug>(easymotion-sn)
map <Leader>.b <Plug>(easymotion-b)
map <Leader>.w <Plug>(easymotion-w)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion

" Airblade configuration
" ----------------------
let g:gitgutter_terminal_reports_focus=0

" NERDTree configuration:
" -----------------------
let NERDTreeQuitOnOpen = 0
let NERDTreeIgnore = ['\.bak$', '\.jpg$', '\.png$', '\.gif$', '\.ico$', '\.orig$', '\.exe$', '\.dll$', '\.log$', '\.zip$', '\.tar$', '^node_modules$', '^tmp$']

" Solargraph:
" -----------
let g:LanguageClient_autoStop = 0
let g:LanguageClient_serverCommands = {
    \ 'ruby': ['tcp://localhost:7658']
    \ }

" Swift plugin:
let g:swift_version_check = 0

" Airline (Vim status line) configuration:
" ----------------------------------------

if !exists("g:airline_symbols")
  let g:airline_symbols = {}
endif
let g:airline_theme='cool'
let g:airline_powerline_fonts=1
let g:Powerline_symbols = 'fancy'
let g:airline#extensions#branch#empty_message = "No SCM"
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_inactive_collapse=0
let g:airline_section_c = '%{pathshorten(getcwd())}'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" CtrlP configuration:
" --------------------
nnoremap \ :CtrlP<CR>
let g:ctrlp_use_caching = 1             " Enable caching
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $CtrlPCache
let g:ctrlp_match_window_bottom = 1     " Match window at bottom of screen
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif

" vim-mustache-handlebars
" Enable abbreviations:
let g:mustache_abbreviations = 1

" --------------------------------------------------------------------------}}}
" Vim file/folder management ---------------------------------------------- {{{
call EnsureExists('$MYVIM/.cache')

" backups:
set backup
set backupdir=$MYVIM/.cache/backup
call EnsureExists(&backupdir)

" swap files:
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

" ------------------------------------------------------------------------- }}}
" GUI mode and Colorscheme ------------------------------------------------ {{{
set guifont=Fira\ Mono\ for\ Powerline
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
" Plugins-------------------------------------------------------------------{{{
call plug#begin('$MYVIM/plugged')
" List below are plugins to be loaded using the vim-plug plugin loader:
" See https://github.com/junegunn/vim-plug for more details.
Plug 'https://github.com/bling/vim-airline'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-unimpaired'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/tmhedberg/matchit'
Plug 'https://github.com/tpope/vim-abolish'
Plug 'https://github.com/Valloric/ListToggle'
Plug 'https://github.com/wellle/targets.vim'
Plug 'https://github.com/vim-scripts/hexHighlight.vim'
Plug 'https://github.com/tommcdo/vim-exchange'
Plug 'https://github.com/mustache/vim-mustache-handlebars'
Plug 'https://github.com/benekastah/neomake'
Plug 'https://github.com/tomtom/tcomment_vim'
Plug 'https://github.com/ap/vim-css-color'
Plug 'https://github.com/elixir-editors/vim-elixir'
Plug 'https://github.com/tpope/vim-fugitive.git'
Plug 'https://github.com/mhinz/vim-grepper'

" Ruby:
Plug 'https://github.com/kana/vim-textobj-user'
Plug 'https://github.com/nelstrom/vim-textobj-rubyblock'
Plug 'https://github.com/tpope/vim-rails'
Plug 'https://github.com/vim-ruby/vim-ruby'
Plug 'https://github.com/tpope/vim-bundler'
Plug 'https://github.com/tpope/vim-rake'
Plug 'https://github.com/tpope/rbenv-ctags'

if has('nvim')
  Plug 'https://github.com/Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'https://github.com/uplus/deoplete-solargraph'
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()
" --------------------------------------------------------------------------}}}
