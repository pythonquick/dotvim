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
    autocmd FocusLost * set nornu
    autocmd BufRead *imap set syntax=java
    cnoreabbrev w echoerr "No Guenther, you don't need to :w with \"autocmd FocusLost * silent! wa\""
    autocmd FocusGained * set rnu
endif


filetype indent on
syntax on
set wrap
set shiftround
set showmatch
set ruler
set incsearch
set hlsearch
set rnu
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

" Leader mappings:
vnoremap <leader>. "my
nnoremap <leader>. "myiw
nnoremap <leader>a "ayiw
nnoremap <leader>A diw"aP
nnoremap <leader>B :call DeleteEmptyBuffers()<CR>
nnoremap <leader>D :Bclose!<CR>
nnoremap <leader>c :cd %:p:h<CR>:echom "Changed Dir to " . expand("%:p:h")<CR>
nnoremap <leader>d :silent! write<CR>:Bclose<CR>
nnoremap <leader>f :FufFile<CR>
nnoremap <leader>j :%!python -m json.tool<CR>
nnoremap <leader>m "mp
nnoremap <leader>M "mP
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>N :NERDTreeFind<CR>
nnoremap <leader>s :setlocal spell!<CR>
nnoremap <leader>t :e ~/Temp/Temp.txt<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>v :e $MYVIMRC<CR>
nnoremap <leader>W :%s/\s\+$//e<CR>:let @/ = ""<CR>:echo "Trimmed trailing whitespace from all lines"<CR>
nnoremap <leader>z 1z=
nnoremap <F6> :colorscheme peachpuff<CR>
nnoremap <F7> :set background=dark<CR>:colorscheme solarized<CR>
nnoremap <F8> :set background=dark<CR>:colorscheme vividchalk<CR>
" Following will surround current word in quote or doublequote:
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel

"Insert Mode Mappings:
" change word to upper-case (useful for typing uppercase contants):
inoremap <c-u> <esc>hviwUe
inoremap <C-h> <left>
inoremap <C-l> <right>

" EasyMotion configuration
"let g:EasyMotion_leader_key = '\'
let g:EasyMotion_mapping_b = '<C-h>'
let g:EasyMotion_mapping_w = '<C-l>'
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890[],.;'

noremap <space> za


" key mappings
noremap! jk <esc>
noremap <c-k> Ox<bs><esc>
noremap <c-j> ox<bs><esc>
noremap <c-,> :bp<cr>
noremap <c-.> :bn<cr>
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

" Highlight long lines
highlight ColorColumn ctermbg=red
call matchadd('ColorColumn', '\%81v', 100)


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
let NERDTreeQuitOnOpen = 1


" CtrlP configuration:

"let g:ctrlp_use_caching = 1             " Enable caching
"let g:ctrlp_clear_cache_on_exit = 0
"let g:ctrlp_cache_dir = $CtrlPCache
"let g:ctrlp_match_window_bottom = 1     " Match window at botom of screen

" Snippet configuration:
let g:snippets_dir = $MYVIM."/snippets"


" Solarized colorscheme configuration:
let g:solarized_termcolors=256
let g:solarized_contrast="high"

" vmath plugin configuration
vmap <expr>  ++  VMATH_YankAndAnalyse()



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


