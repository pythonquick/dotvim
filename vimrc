inoremap <c-i> <esc>hviwUe
" Preamble ---------------------------------------------------------------- {{{
if has('win16') || has('win95') || has('win32') || has('win64')
    let $MYVIM=$HOME.'/.vim'
else
    let $MYVIM=$HOME.'/.vim'
endif

set rtp+=$MYVIM/bundle/vundle/
call vundle#rc()


" vundle bundles / Plugins:
so $MYVIM/bundle.vim
so $MYVIM/plugin/bclose.vim
so $MYVIM/plugin/minibufexplpp.vim

"}}}
" Basic options ----------------------------------------------------------- {{{
filetype indent on
syntax on
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set shiftround
set showmatch
set ruler
set incsearch
set hlsearch
set relativenumber
set number
set cmdheight=1
set scrolloff=1
set hidden             " allow buffer switching without saving
set autoread           " auto reload if file saved externally
set showcmd            " show asdnumber of chars/lines selected in status line:
set ttyfast
set nocompatible
set laststatus=2
set encoding=utf-8
set ttimeoutlen=50
set t_Co=256
set visualbell
set go-=T
set lines=999 columns=999
set cursorline
set autochdir " Change directory to the current buffer when opening files.
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set showbreak=↪

"}}}
" Tabs, spaces, wrapping -------------------------------------------------- {{{
set colorcolumn=80
set expandtab
set smartindent
set tabstop=4
set autoindent
set backspace=indent,eol,start    "allow backspacing everything in insert mode
set shiftwidth=4
set linebreak
set wrap
" ------------------------------------------------------------------------- }}}
" Folding ----------------------------------------------------------------- {{{
set foldmethod=marker
set foldlevelstart=0

" Space to toggle folds.
nnoremap <Space> za
vnoremap <Space> za

" Make zO recursively open whatever fold we're in, even if it's partially open.
nnoremap zO zczO

" "Focus" the current line.  Basically:
"
" 1. Close all folds.
" 2. Open just the folds containing the current line.
" 3. Move the line to a little bit (15 lines) above the center of the screen.
" 4. Pulse the cursor line.  My eyes are bad.
"
" This mapping wipes out the z mark, which I never use.
"
" I use :sus for the rare times I want to actually background Vim.
nnoremap <c-z> mzzMzvzz15<c-e>`z:Pulse<cr>

function! MyFoldText() " {{{
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * &numberwidth
    let windowwidth = winwidth(0) - nucolwidth - 3
    let foldedlinecount = v:foldend - v:foldstart

    " expand tabs into spaces
    let onetab = strpart('          ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction " }}}
set foldtext=MyFoldText()
" }}}
" Functions --------------------------------------------------------------- {{{
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


function! DeleteEmptyBuffers()
    let [i, n; empty] = [1, bufnr('$')]
    while i <= n
        if bufexists(i) && bufname(i) == ''
            call add(empty, i)
        endif
        let i += 1
    endwhile
    if len(empty) > 0
        exe 'bdelete' join(empty)
    endif
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
" ---------- FUNCTIONS }}}
" Searching --------------------------------------------------------------- {{{

" ------------------------------------------------------------------------- }}}
" Auto commands ----------------------------------------------------------- {{{


if has("autocmd")
    "autocmd BufWritePost $MYVIMRC source $MYVIMRC " auto-source vimrc
    autocmd FocusLost * silent! wa " auto-save but don't complain about new buffers
    autocmd FocusLost * set nornu
    autocmd BufRead *imap set syntax=java
    "cnoreabbrev w echoerr "No Guenther, you don't need to :w with \"autocmd FocusLost * silent! wa\""
    autocmd FocusGained * set rnu
    
    " Make sure Vim returns to the same line when you reopen a file.
    augroup line_return
        au!
        au BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \     execute 'normal! g`"zvzz' |
            \ endif
    augroup END 
endif
"}}}
" Key remapping ----------------------------------------------------------- {{{
" Remap home keys for cursor positioning on line:
nnoremap H 0
nnoremap L $


" Remap arrow keys:
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

" Scroll by screen line (even if line wraps multiple screen lines):
"nnoremap <silent> j gj
"nnoremap <silent> k gk

let mapleader = ","
let maplocalleader = "\\"

" Insert new line before/after cursor:
nmap <S-Enter> O<Esc>
nmap <c-Enter> o<Esc>

" Leader mappings:
nnoremap <tab> %
vnoremap <leader>. "my
nnoremap <leader>. "myiw
nnoremap <leader>a "ayiw
nnoremap <leader>A diw"aP
nnoremap <leader>B :call DeleteEmptyBuffers()<CR>
nnoremap <leader>D :Bclose!<CR>
nnoremap <leader>c :cd %:p:h<CR>:echom "Changed Dir to " . expand("%:p:h")<CR>
nnoremap <leader>d :silent! write<CR>:Bclose<CR>
nnoremap <leader>ev :e $MYVIMRC<CR>
nnoremap <leader>ep :e ~/projects<CR>
nnoremap <leader>f :FufFile<CR>
nnoremap <leader>j :%!python -m json.tool<CR>
nnoremap <leader>m "mp
nnoremap <leader>M "mP
"nnoremap <leader>n :NERDTreeToggle<CR>
"nnoremap <leader>N :NERDTreeFind<CR>
nnoremap <leader>s :SETLOCAL spell!<CR>
nnoremap <leader>t :e ~/Temp/Temp.txt<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>v :source $MYVIMRC<CR>
nnoremap <leader>W :%s/\s\+$//e<CR>:let @/ = ""<CR>:echo "Trimmed trailing whitespace from all lines"<CR>
"nnoremap <leader>z 1z=
nnoremap <leader>z zMzvzz
nnoremap * *<c-o> " Search word, but stay on initial word
nnoremap <F6> :colorscheme peachpuff<CR>
nnoremap <F7> :set background=dark<CR>:colorscheme solarized<CR>
nnoremap <F8> :set background=dark<CR>:colorscheme koehler<CR>
" Following will surround current word in quote or doublequote:
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel

" Move to next/previous item in quickfix list:
nnoremap <c-n> :cn<cr>
nnoremap <c-p> :cp<cr>


" center cursor line when jumping to next/prev search result:
nnoremap n nzz
nnoremap N Nzz

"Insert Mode Mappings:
" change word to upper-case (useful for typing uppercase contants):
inoremap <c-i> <esc>hviwUe
inoremap <c-f> <c-x><c-f>

noremap <space> za


"noremap <c-k> Ox<bs><esc>
"noremap <c-j> ox<bs><esc>
iab <expr> dts strftime("%c")
vmap ,x :!tidy -q -i -xml<CR>

" shortcut for angle bracket text objects: 
onoremap ir i[
onoremap ar a[
vnoremap ir i[
vnoremap ar a[

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

" ------------------------------------------------------------------------- }}}
" Plugin configuration ---------------------------------------------------- {{{

" EasyMotion configuration
"let g:EasyMotion_leader_key = '\'
let g:EasyMotion_mapping_b = '<C-h>'
let g:EasyMotion_mapping_w = '<C-l>'
let g:EasyMotion_mapping_j = '<C-j>'
let g:EasyMotion_mapping_k = '<C-k>'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890[],.;-='''

" Airline (Vim status line) configuration:
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:airline_section_b = '%{getcwd()}'
let g:airline_section_c = '%t'
let g:airline_detect_whitespace=0

" Syntastic configuration:
let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['javascript', 'c'],
                            \ 'passive_filetypes': ['puppet'] }

" NERD Tree configuration:
"let NERDTreeQuitOnOpen = 1

" CtrlP configuration:

let g:ctrlp_map = '\'
"let g:ctrlp_use_caching = 1             " Enable caching
"let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_cache_dir = $CtrlPCache
"let g:ctrlp_match_window_bottom = 1     " Match window at botom of screen

" Snippet configuration:
let g:snippets_dir = $MYVIM."/snippets"

" Solarized colorscheme configuration:
let g:solarized_termcolors=256
let g:solarized_contrast="high"

" --------------------------------------------------------------------------}}}
" Vim file/folder management ---------------------------------------------- {{{
call EnsureExists('$MYVIM/.cache')
" persistent undo
if exists('+undofile')
    set undofile
    set undodir=$MYVIM/.cache/undo
    call EnsureExists(&undodir)
endif
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
" Highlight long lines
"highlight ColorColumn ctermbg=red
"call matchadd('ColorColumn', '\%81v', 100)

" vmath plugin configuration
vmap <expr>  ++  VMATH_YankAndAnalyse()

command! PrettyXML call DoPrettyXML()
" ------------------------------------------------------------------------- }}} 
" GUI mode ---------------------------------------------------------------- {{{
if has("gui_running")
    "colo koehler
    colo solarized
    set background=dark
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
" ------------------------------------------------------------------------- }}}


