if has('win16') || has('win95') || has('win32') || has('win64')
    let $MYVIM=$HOME.'/vimfiles'
else
    let $MYVIM=$HOME.'/.vim'
endif

set rtp+=$MYVIM/bundle/vundle/
call vundle#rc()


" vundle bundles / Plugins:
so $MYVIM/bundle.vim


"" ---------- FUNCTIONS {{{
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


if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC " auto-source vimrc
    autocmd FocusLost * silent! wa " auto-save but don't complain about new buffers
    autocmd BufRead *imap set syntax=java
endif


filetype indent on
set wrap
set shiftround
set showmatch
set ruler
set incsearch
set hlsearch
set nu
set cmdheight=1
set scrolloff=1
set hidden                  " allow buffer switching without saving
set autoread                " auto reload if file saved externally
set showcmd                 " show asdnumber of chars/lines selected in status line:
set linebreak
set wildmenu
set wildmode=list:full
set wildignorecase
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store
set nocompatible
set laststatus=2
set encoding=utf-8
set ttimeoutlen=50
set t_Co=256
set visualbell
set go-=T
set lines=999 columns=999

if has("gui_running")
    "hi normal guibg=black
    set transp=0
    "colo koehler
    colo solarized
    set background=dark
    set transparency=0
    "set guifont=Envy\ Code\ R:h16
    set guifont=Inconsolata-dz\ for\ Powerline:h16
    "set guifont=Literation\ Mono\ Powerline:h16
endif



" whitepace
set smartindent
set tabstop=4
set list
set listchars=tab:▸\ ,eol:¬
set autoindent
set backspace=indent,eol,start                      "allow backspacing everything in insert mode
set expandtab
set shiftwidth=4

" Remap arrow keys:
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

" change cursor posision in insert mode
inoremap <C-h> <left>
inoremap <C-l> <right>

" Scroll by screen line (even if line wraps multiple screen lines):
nnoremap <silent> j gj
nnoremap <silent> k gk

" Leader mappings:
let mapleader = ","
nmap <leader>a "ayiw
nmap <leader>A diw"aP
nmap <leader>b :call DeleteEmptyBuffers()<CR>
nmap <leader>D :BD!<CR>
nmap <leader>c :cd %:p:h<CR>:echom "Changed Dir to " . expand("%:p:h")<CR>
nmap <leader>d :BD<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>s :setlocal spell!<CR>
nmap <leader>t :e ~/Temp/Temp.txt<CR>
nmap <leader>v :e $MYVIMRC<CR>
nmap <leader>w :w<CR>
nmap <leader>W :%s/\s\+$//e<CR>:let @/ = ""<CR>:echo "Trimmed trailing whitespace from all lines"<CR>
nmap <leader>z 1z=
nmap <leader>1 :b1<CR>
nmap <leader>2 :b2<CR>
nmap <leader>3 :b3<CR>
nmap <leader>4 :b4<CR>
nmap <leader>5 :b5<CR>
nmap <leader>6 :b6<CR>
nmap <leader>7 :b7<CR>
nmap <leader>8 :b8<CR>
nmap <leader>9 :b9<CR>
noremap <space> za


" key mappings
map! jj <esc>
map <c-k> Ox<bs><esc>
map <c-j> ox<bs><esc>
map <c-,> :bp<cr>
map <c-.> :bn<cr>
iab <expr> dts strftime("%c")
vmap ,x :!tidy -q -i -xml<CR>


command! PrettyXML call DoPrettyXML()


cabbr b Bs

" Abbreviations:
" Abolish expands case-combinations:


" vim file/folder management {{{
" persistent undo
if exists('+undofile')
    set undofile
    set undodir=$MYVIM/.cache/undo
endif

" backups
set backup
set backupdir=$MYVIM/.cache/backup

" swap files
set directory=$MYVIM/.cache/swap
set noswapfile

call EnsureExists('$MYVIM/.cache')
call EnsureExists(&undodir)
call EnsureExists(&backupdir)
call EnsureExists(&directory)
"}}}


" Airline (Vim status line) configuration:
let g:airline_theme='dark'
"let g:airline_theme='solarized'
"let g:airline_theme='luna'
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
let NERDTreeQuitOnOpen = 1

echo ".vimrc sourced"
