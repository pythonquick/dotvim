if has('win16') || has('win95') || has('win32') || has('win64')
    let $MYVIM=$HOME.'/.vim'
else
    let $MYVIM=$HOME.'/.vim'
endif

set rtp+=$MYVIM/bundle/vundle/
call vundle#rc()


" vundle bundles / Plugins:
so $MYVIM/bundle.vim
so $MYVIM/plugin/minibufexpl.vim
so $MYVIM/plugin/bclose.vim


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




" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>

" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Default to tree mode
let g:netrw_liststyle=3

" Change directory to the current buffer when opening files.
set autochdir




if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC " auto-source vimrc
    autocmd FocusLost * silent! wa " auto-save but don't complain about new buffers
    autocmd BufRead *imap set syntax=java
    cnoreabbrev w echoerr "No Guenther, you don't need to :w with \"autocmd FocusLost * silent! wa\""
endif


filetype indent on
syntax on
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
if has('win16') || has('win95') || has('win32') || has('win64')
    set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*
else
    set wildignorecase
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif
set nocompatible
set laststatus=2
set encoding=utf-8
set ttimeoutlen=50
set t_Co=256
set visualbell
set go-=T
set lines=999 columns=999




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
nmap <leader>B :call DeleteEmptyBuffers()<CR>
nmap <leader>D :Bclose!<CR>
nmap <leader>c :cd %:p:h<CR>:echom "Changed Dir to " . expand("%:p:h")<CR>
nmap <leader>d :silent! write<CR>:Bclose<CR>
nmap <leader>f :FufFile<CR>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFind<CR>
nmap <leader>s :setlocal spell!<CR>
nmap <leader>t :e ~/Temp/Temp.txt<CR>
nmap <leader>q :q<CR>
nmap <leader>v :e $MYVIMRC<CR>
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
"}}}


" Airline (Vim status line) configuration:
let g:airline_theme='powerlineish'
"let g:airline_theme='dark'
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


" CtrlP configuration:

"let g:ctrlp_use_caching = 1             " Enable caching
"let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_cache_dir = $CtrlPCache
"let g:ctrlp_match_window_bottom = 1     " Match window at botom of screen

" EasyMotion configuration:
let g:EasyMotion_leader_key = '\'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890[],.;'

" Solarized colorscheme configuration:
let g:solarized_termcolors=256


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


