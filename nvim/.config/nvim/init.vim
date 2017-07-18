" init.vim for neovim
"
" Priyank Chaudhary

" Create nviminit autocmd group and remove any existing autocmds,
" in case init.vim is re-sourced.
augroup nviminit
	autocmd!
augroup END

" Keep clutter under one roof-------------------------------------------
set backupdir=~/.config/nvim/backup " Centralize backups
set directory=~/.config/nvim/swap " Centralize swaps

if exists("&undodir") " Keen undo history in one place
	set undodir=~/.config/nvim/undo
endif

" But don’t create backups when editing files in certain directories
set backupskip=/tmp/*,/private/tmp/*


" Persistent Undo-------------------------------------------------------
" Keep undo history across sessions, by storing in file.
" Only works all the time!
if has('persistent_undo')
  set undodir=~/.config/nvim/undo
  set undofile
endif


" Looks-----------------------------------------------------------------
set background=dark
set t_Co=256 " Use 256 colors

let base16colorspace=256 " " Access colors present in 256 colorspace

try  " Don't use a color scheme if not found
  colorscheme base16-monokai
catch /^Vim\%((\a\+)\)\=:E185/
endtry

set noshowmode " Don't show the mode you're in. lightline.vim has your back
set number " Show line numbers
set relativenumber " Use relative line numbers

" Show absolute numbers in insert mode, otherwise relative
autocmd nviminit InsertEnter * :set norelativenumber
autocmd nviminit InsertLeave * :set relativenumber

" Show “invisible” characters
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

set title " Show the filename in the window titlebar
set cursorline " Highlight current line
set nowrap " Don't wrap lines by default


" Essentials------------------------------------------------------------
set linespace=0 " No extra spaces between rows
set hidden " Allow switching buffers without saving
set report=0 " Show all changes
set clipboard=unnamed " Make yanks go to OS clipboard
" set esckeys " Allow cursor keys in insert mode
let mapleader=","  " Change default backslash mapleader. Easier to type
set autochdir " Auto switch to current file's directory on opening new buffer
set ruler " Show column and line number
set lazyredraw " Don't force redraw when updating buffers

" Ignore some files in tab completion
set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/node_modules/*
set wildignore+=*.gem
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*


" Mouse and scrolling in terminal---------------------------------------
set mouse=a " Mouse is not enabled by default anymore
" Start scrolling three lines before the horizontal window border
set scrolloff=3
" Start scrolling three lines before the vertical window border
set sidescrolloff=3


" Indentation-----------------------------------------------------------
set expandtab " Expand tabs into spaces
set tabstop=2 " Make tabs as wide as two spaces
set shiftwidth=2 " Apply the same for autoindent
set softtabstop=2 " <TAB> and <BS> key results in 2 spaces as well


" Fomatting-------------------------------------------------------------
set textwidth=79 " Make it obvious where 79 character width is
set colorcolumn=+1 " Highlight column at textwidth
" Only insert single space after a '.', '?' and '!' with a join command.
set nojoinspaces
set fo+=2 " Use the indent of the second line of a paragraph
set fo+=1 " Don't break a line after a one-letter word
set fo+=n " Recognize numbered lists
set fo+=r " (in mail) comment leader after


" Code folding----------------------------------------------------------
set foldmethod=indent " Fold based on indent
set foldnestmax=3 " Deepest fold level
set nofoldenable " Don't fold by default


" vimdiff options-------------------------------------------------------
set diffopt=filler " Add vertical spaces to keep right and left aligned
set diffopt+=iwhite " Ignore whitespaces


" Search and/or Replace-------------------------------------------------
set gdefault " Add the g (global) flag to search/replace by default
set ignorecase " Ignore case of searches
set smartcase " Override if pattern has only uppercase letters
map <silent> <leader>/ <Esc>:nohlsearch<CR> " Clear last search


" Allow per-file configurations-----------------------------------------
" Respect modeline in files so files can have their own vim options
set modeline
set modelines=4

" Enable per-directory .nviminit files and disable unsafe commands in them
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
map <leader><leader> :b#<CR> " Switch between the last two files with ,,

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


" Vimprovments----------------------------------------------------------
" Jumping to tags (Thanks to Paul Irish){{{
augroup jump_to_tags
  autocmd!

  " Basically, <c-]> jumps to tags (like normal) and <c-\> opens the tag in a new
  " split instead.
  "
  " Both of them will align the destination line to the upper middle part of the
  " screen.  Both will pulse the cursor line so you can see where the hell you
  " are.  <c-\> will also fold everything in the buffer and then unfold just
  " enough for you to see the destination line.
  nnoremap <c-]> <c-]>mzzvzz15<c-e>`z:Pulse<cr>
  nnoremap <c-\> <c-w>v<c-]>mzzMzvzz15<c-e>`z:Pulse<cr>

  " Pulse Line (thanks Steve Losh)
  function! s:Pulse() " {{{
    redir => old_hi
    silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    let steps = 8
    let width = 1
    let start = width
    let end = steps * width
    let color = 233

    for i in range(start, end, width)
      execute "hi CursorLine ctermbg=" . (color + i)
      redraw
      sleep 6m
    endfor
    for i in range(end, start, -1 * width)
      execute "hi CursorLine ctermbg=" . (color + i)
      redraw
      sleep 6m
    endfor

    execute 'hi ' . old_hi
  endfunction " }}}

  command! -nargs=0 Pulse call s:Pulse()
augroup END
" }}}

" Move more naturally up/down when wrapping is enabled.
nnoremap j gj
nnoremap k gk

" Use jk (and the other default <C-[>) to go to the normal mode
inoremap jk <ESC>
" Use hh to complete the word in insert mode
inoremap hh <C-p>

" Hard to type things
" iabbrev >> →
" iabbrev << ←

" Yank from cursor to end of line
nnoremap Y y$<Paste>

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

noremap <leader>W :w !sudo tee % > /dev/null<CR> " Save a file as root (,W)

" When editing a file, always jump to the last known cursor position, except
" for commit messages, invalid position, or when inside an event
" handler (happens when dropping a file on gvim).
autocmd nviminit BufReadPost *
  \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

" After search and replace, go back to where you started (with confirmation)
noremap ;; :%s:::g<Left><Left><Left>
noremap ;' :%s:::cg<Left><Left><Left><Left>

" Search and replace word under the cursor
:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/

" Plugins and their respective configuration----------------------------
" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMouseMode = 2
let NERDTreeMinimalUI = 1
map <leader>n :NERDTreeToggle<CR>
autocmd nviminit StdinReadPre * let s:std_in=1
" If no file or directory arguments are specified, open NERDtree.
" If a directory is specified as the only argument, open it in NERDTree.
 autocmd nviminit VimEnter *
  \ if argc() == 0 && !exists("s:std_in") |
  \   NERDTree |
  \ elseif argc() == 1 && isdirectory(argv(0)) |
  \   bd |
  \   exec 'cd' fnameescape(argv(0)) |
  \   NERDTree |
  \ end

" go specific and vim-go config ---------------------------------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

autocmd FileType go nmap <leader>b  <Plug>(go-build)
autocmd FileType go nmap <leader>r  <Plug>(go-run)
let g:go_list_type = "quickfix"

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

" for python completion
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'


" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)<Paste>

" Airline
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
" enable modified detection >
" let g:airline_detect_modified=1
"enable paste detection >
" let g:airline_detect_paste=1

" let g:deoplete#enable_at_startup = 1

" Begin adding plugins here. Managed by vim-plug
call plug#begin()

"" Filesystem and project management
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree explorer

"" Language specific
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'davidhalter/jedi-vim', {'for': 'python'}
Plug 'octave.config/nvim', {'for': 'octave'}
" Plug 'puppetlabs/puppet-syntax-vim'
" Plug 'derekwyatt/vim-scala', {'for': 'scala'}
" Plug 'honza/dockerfile.config/nvim'
Plug 'ap/vim-css-color', {'for': 'css'} " preview colors when editing
" Plug 'JuliaEditorSupport/julia-vim' " It is recommended not to load it on-demand
" CamelCase and snake_case motions
Plug 'bkad/CamelCaseMotion', {'for': ['go', 'python']}

" For web dev
Plug 'pangloss/vim-javascript', {'for': 'javascript'}
Plug 'leafgarland/typescript-vim'
Plug 'sheerun/vim-json'
" Autocomplete (npm install -g tern)
Plug 'carlitux/deoplete-ternjs', {'for': 'javascript'}
" Autocomplete using flow (npm install -g flow-bin)
Plug 'steelsojka/deoplete-flow', {'for': 'javascript'}
" JS Documentation comments
Plug 'heavenshell/vim-jsdoc', { 'on': ['JsDoc'] }
Plug 'othree/html5.vim', {'for': 'html'}
" Color highlighter
Plug 'lilydjwg/colorizer', { 'for': ['css', 'sass', 'scss', 'less', 'html', 'xdefaults', 'javascript', 'javascript.jsx'] }

"" Snippets and abbreviations
Plug 'mattn/emmet-vim', {'for': ['html', 'css']} " Expand abbreviations
" Track the engine.
Plug 'SirVer/ultisnips'
" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'


"" Writing/editing helpers
Plug 'tpope/vim-commentary' " Commenting helper
Plug 'tpope/vim-surround' " Simplified quoting and parenthesizing
Plug 'tpope/vim-abolish' " Search for, substitute, and abbreviate words
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-go', { 'do': 'make'}
" Plug 'JuliaEditorSupport/deoplete-julia'

"" Visual
" Plug 'vim-airline/vim-airline' " Pretty status line
" Plug 'vim-airline/vim-airline-themes'
Plug 'itchyny/lightline.vim'
Plug 'nathanaelkane/vim-indent-guides', {'on': 'IndentGuidesToggle'}

"" Misc
Plug 'tpope/vim-unimpaired' " Handy bracket mappings
Plug 'junegunn/vim-easy-align'
Plug 'cohama/lexima.vim' " Automatically close brackets, quotes, etc
Plug 'chrisbra/CheckAttach' " Will always have your back
Plug 'terryma/vim-multiple-cursors' " Sublime style multiple selections
Plug 'Shougo/denite.nvim' " Unite files, buffers, etc. sources
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' } " Intelligent buffer closing
call plug#end()
