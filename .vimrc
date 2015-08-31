" vimrc
" 
" Priyank Chaudhary
" www.seas.upenn.edu/~priyc


" Disable Vi compatibility. Must be enabled to prevent adverse effects.
set nocompatible


" Create vimrc autocmd group and remove any existing vimrc autocmds,
" in case .vimrc is re-sourced.
augroup vimrc
	autocmd!
augroup END


" Keep clutter under one roof-------------------------------------------
set backupdir=~/.vim/backup " Centralize backups
set directory=~/.vim/swap " Centralize swaps

if exists("&undodir") " Keen undo history in one place
	set undodir=~/.vim/undo
endif

" But don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*


" Persistent Undo-------------------------------------------------------
" Keep undo history across sessions, by storing in file.
" Only works all the time!
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif


" Looks-----------------------------------------------------------------
" Many useful defaults are covered in tpop/vim-sensible plugin. This file has 
" been edited to avoid redundancy while keeping desired overrides

set background=dark
set t_Co=256 " Use 256 colors

try  " Don't use a color scheme if not found
  colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
endtry

set noshowmode " Don't show the mode you're in. Vim-airline has your back
set number " Show line numbers
set relativenumber " Use relative line numbers

" Show absolute numbers in insert mode, otherwise relative
autocmd vimrc InsertEnter * :set norelativenumber
autocmd vimrc InsertLeave * :set relativenumber

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

set title " Show the filename in the window titlebar
set cursorline " Highlight current line
set nowrap " Don't wrap lines by default


" Essentials------------------------------------------------------------
set linespace=0 " No extra spaces between rows
set spell " Show spelling mistakes by default
set hidden " Allow switching buffers without saving
set report=0 " Show all changes
set clipboard=unnamed " Make yanks go to OS clipboard
set esckeys " Allow cursor keys in insert mode
set ttyfast " Optimize for fast terminal connections
let mapleader=","     " Change default backslash mapleader. Easier to type
set autochdir " Auto switch to current file's directory on opening new buffer

" Ignore some files in tab completion
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/node_modules/*
set wildignore+=*.gem
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*


" Mouse and scrolling in terminal---------------------------------------
set mouse=a " Enable mouse and touchpad
" Start scrolling three lines before the horizontal window border
" This option overrides vim-sensible
set scrolloff=3
" Start scrolling three lines before the vertical window border
" This option overrides vim-sensible
set sidescrolloff=3


" Indentation-----------------------------------------------------------
set expandtab " Expand tabs into spaces
set tabstop=2 " Make tabs as wide as two spaces
set shiftwidth=2 " Apply the same for autoindent
set softtabstop=2 " Tab key results in 2 spaces as well


" Fomatting-------------------------------------------------------------
set textwidth=79 " Make it obvious where 79 character width is
set colorcolumn=+1 " Highlight column at textwidth
" Automatically insert comment leader after 'o' or 'O' in Normal mode.
" set fo+=o
" Only insert single space after a '.', '?' and '!' with a join command.
set nojoinspaces


" Code folding----------------------------------------------------------
set foldmethod=indent " Fold based on indent
set foldnestmax=3 " Deepest fold level
set nofoldenable " Don't fold by default


" Search and/or Replace-------------------------------------------------
set gdefault " Add the g (global) flag to search/replace by default
set hlsearch " Highlight searches
set ignorecase " Ignore case of searches
set smartcase " Override if pattern has only uppercase letters
map <silent> <leader>/ <Esc>:nohlsearch<CR> " Clear last search


" Allow per-file configurations-----------------------------------------
" Respect modeline in files so files can have their own vim options
set modeline
set modelines=4

" Enable per-directory .vimrc files and disable unsafe commands in them
set exrc
set secure


" Disable unwanted behaviour--------------------------------------------
set binary
set noeol
set noerrorbells " Disable error bells. I can notice visual bells.
set nostartofline " Don’t reset cursor to start of line when moving around.
set shortmess=atI " Disable startup message
set gcr=a:blinkon0 " Disable cursor blinking


" Custom shortcuts for moving around buffers----------------------------
nnoremap <leader>b :CtrlPBuffer<CR> " List other buffers with ,b
map <leader><leader> :b#<CR> " Switch between the last two files with ,,
map gb :bnext<CR> " Next buffer
map gB :bprev<CR> " Previous one

" Jump to buffer number 1-9 with ,<N> or 1-99 with <N>gb
let c = 1
while c <= 99
  if c < 10
    execute "nnoremap <silent> <leader>" . c . " :" . c . "b<CR>"
  endif
  execute "nnoremap <silent> " . c . "gb :" . c . "b<CR>"
  let c += 1
endwhile


" File type specific specs----------------------------------------------
" Use LaTeX rather than plain TeX.
let g:tex_flavor = "latex"

" vim
autocmd vimrc BufRead .vimrc,*.vim set keywordprg=:help

" Treat md as markdown
autocmd vimrc BufRead,BufNewFile *.md set filetype=markdown


" Vimprovments----------------------------------------------------------
" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Use jk (and the other default <C-[>) to go to the normal mode
inoremap jk <ESC>

" Toggle spelling visuals with <leader>s
nnoremap <leader>s :set spell!

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" New mappings for page up and down
map <PageUp> <C-U>
map <PageDown> <C-D>
imap <PageUp> <C-O><C-U>
imap <PageDown> <C-O><C-D>

noremap <leader>W :w !sudo tee % > /dev/null<CR> " Save a file as root (,W)

" When editing a file, always jump to the last known cursor position, except
" for commit messages, invalid position, or when inside an event
" handler (happens when dropping a file on gvim).
autocmd vimrc BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif


" Plugins and their respective configuration----------------------------
" NERDTree
let NERDTreeShowHidden = 1
"let NERDTreeMouseMode = 2
let NERDTreeMinimalUI = 1
map <leader>n :NERDTreeToggle<CR>
"autocmd vimrc StdinReadPre * let s:std_in=1
"" If no file or directory arguments are specified, open NERDtree.
"" If a directory is specified as the only argument, open it in NERDTree.
autocmd vimrc VimEnter *
"  \ if argc() == 0 && !exists("s:std_in") |
"  \   NERDTree |
"  \ elseif argc() == 1 && isdirectory(argv(0)) |
"  \   bd |
"  \   exec 'cd' fnameescape(argv(0)) |
"  \   NERDTree |
"  \ end
"
"" CtrlP.vim easier binding
"map <leader>p <C-P>
"map <leader>r :CtrlPMRUFiles<CR>
"
"" Indent Guides
"let g:indent_guides_start_level = 2
"let g:indent_guides_guide_size = 1


" Airline
let g:airline#extensions#tabline#enabled = 1
" enable modified detection >
let g:airline_detect_modified=1
"enable paste detection >
let g:airline_detect_paste=1
let g:airline_theme="gruvbox"


" Begin adding plugins here. Managed by vim-plug
" 
" Reload vimrc and :PlugInstall to install plugins

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible' " Sensible defaults

" Wrappers
Plug 'tpope/vim-fugitive' " Git wrapper

"" Filesystem and project management
"Plug 'tpope/vim-eunuch' " Unix task helper
"Plug 'Rename2' " Rename the file currently being edited
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree explorer
"Plug 'ctrlpvim/ctrlp.vim' " Fuzzy finder

"" Writing/editing helpers
"Plug 'tpope/vim-commentary' " Commenting helper
"Plug 'tpope/vim-surround' " Simplified quoting and parenthesizing
"Plug 'tpope/vim-abolish' " Search for, substitute, and abbreviate words

"Plug 'junegunn/goyo.vim' " Distraction free writing
"Plug 'junegunn/limelight.vim' " Hyperfocus writing

" Visual
"Plug 'nathanaelkane/vim-indent-guides' " Highlight all indent levels
Plug 'bling/vim-airline' " Pretty status line
Plug 'morhetz/gruvbox' " colorscheme

" Misc
Plug 'ConradIrwin/vim-bracketed-paste'  " Automatic `:set paste`
"Plug 'tpope/vim-unimpaired' " Handy bracket mappings
"Plug 'chrisbra/CheckAttach' " Will always have your back
"Plug 'terryma/vim-multiple-cursors' " Sublime style multiple selections
call plug#end()
