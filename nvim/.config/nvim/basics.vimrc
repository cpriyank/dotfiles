" BASIC SETTINGS {{{
" ============================================================================
set encoding=utf-8 nobomb  " BOM often causes trouble
set number
set relativenumber " Use relative line numbers
" always show signcolumns so that gitgutter and linters can put signs before
" row numbers
set signcolumn=yes
highlight clear SignColumn  " SignColumn should match background

" Show absolute numbers in insert mode, otherwise relative
" autocmd nviminit InsertEnter * :set norelativenumber
" autocmd nviminit InsertLeave * :set relativenumber
" set linespace=0 " No extra spaces between rows
set report=0 " Show all changed lines with messages like ~1 line less, 1 line yanked
" set autochdir " Auto switch to current file's directory on opening new buffer
set tabstop=2
" set softtabstop=2 " <TAB> and <BS> key results in 2 spaces as well
set shiftwidth=2
set expandtab " smarttab "Default in neovim
" set autoindent "Default in neovim
set smartindent
set lazyredraw  " Don't force redraw when updating buffers
" set laststatus=2 " Always show status line. Default in neovim
" set ruler " Show column and line number on the statusline. Default in neovim
set fillchars=stl:\ ,stlnc:\ ,fold:\ ,vert:│ " Characters to fill the statuslines (nc = non-current window) and vertical separators
set showcmd " Show partial commands in status line and Selected characters/lines in visual mode "Default in neovim
set showmatch " Briefly jump to matching bracket when it's inserted
set visualbell
set backspace=indent,eol,start
set timeoutlen=500 " Time in milliseconds to wait for mapped sequence to complete
set whichwrap=b,s " Allow backspace and space to cross line boundaries
set shortmess=acIOT " Avoid miscellaneous startup messages, don't give |ins-completion-menu| messages.
" set hlsearch incsearch "Default in neovim
set gdefault ignorecase smartcase " 'g' flag for search and replace
set inccommand=split " Live preview of search and replace in a split
set pumheight=20   " Avoid the pop up menu occupying the whole screen
set hidden " Allow switching buffers without saving
set autowrite " Automatically write a file when leaving a modified buffer
set switchbuf=useopen,usetab " reuse open buffers in all tabs while switching
set autoread " auto reload files changed outside vim
" Minimal number of screen lines to keep above and below the cursor.
set scrolloff=5
" same as above for horizontal scrolling
set sidescrolloff=3
" Minimal number of lines to scroll when the cursor gets off the screen
set scrolljump=5
" Show “invisible” whitespace characters with list and listchars
set listchars=tab:▸\ ,trail:·,eol:¬,nbsp:_
set list

set virtualedit=block " Allow rectangular block selection with <C-v>
" Only insert single space after a '.', '?' and '!' with a join command.
set nojoinspaces
set diffopt=filler " Add vertical spaces to keep right and left aligned
set diffopt+=vertical " start diff in vertical mode by default
set diffopt+=iwhite " Ignore white spaces
set clipboard^=unnamed,unnamedplus " Make yanks go to OS clipboard

set foldlevelstart=99
" set foldmethod=indent " Fold based on indent
" set foldnestmax=3 " Deepest fold level
" set nofoldenable " Don't fold by default

set grepformat=%f:%l:%c:%m,%f:%l:%m
set completeopt=menu,preview " In autocomplete menu of insert mode, when there is just one match, complete it rather than waiting for key press for confirmation
set cursorline " highlight current line
set title " set window/terminal app title with filename
" <C-a>/<C-x> will increment/decrement numbers under or to the
" right of the cursor, hex by default
set nrformats=hex

set fileformats=unix,dos,mac " Use Unix as the standard file type

set formatoptions+=1 " Don't break a line after a one-letter word
set formatoptions+=2 " Use the indent of the second line of a paragraph
" set formatoptions+=n " Recognize numbered lists
" set formatoptions+=c " Format comments. This is default
" set formatoptions+=r " (in mail) comment leader after. This is default
" set formatoptions+=l " Don't break lines that are already long. This is default
let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

" Disable unwanted behaviour--------------------------------------------
" Allow editing or opening binary files without corruption that may
" happen if vim assumes it to have a utf-8 encoding and tries to encode as
" such
set binary
set noeol " Do not add new line
set noerrorbells " Disable error bells. I can notice visual bells.
set nostartofline " Don’t reset cursor to start of line when moving around.
set guicursor=a:blinkon0 " Disable cursor blinking

if has('termguicolors') " fix colors in tmux. Neovim ignores t_XX
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set modelines=2 " allow per file vim config
set synmaxcol=1000 " syntax highlighting limit (in columns) for long lines

" ctags
set tags=./tags;/

set complete-=i " don't complete from included files

" mouse
silent! set ttymouse=xterm2
" set ttyfast "Default in neovim
set mouse=a
set mousehide " hide mouse cursor while typing

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
  set colorcolumn=80
endif

" Keep the cursor on the same column when moving around
set nostartofline

" gf opens file under cursor in the same window. isfname controls what can be
" part of the file
set isfname-==

" set wildmenu " Used for command completion such as :color <TAB>. Default in neovim
set wildmode=full
" Ignore some files in tab completion
" set wildignore+=*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/node_modules/*
set wildignore+=*.gem
set wildignore+=*/vendor/*,*/.git/*,*/.hg/*,*/.svn/*,*/log/*,*/tmp/*
set suffixes+=.aux,.log,.dvi,.pdf,.bbl,.out,.toc " ignore some more files

" For conceal markers.
" see https://vi.stackexchange.com/questions/7258/how-do-i-prevent-vim-from-hiding-symbols-in-markdown-and-json
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Number of screen lines to use for the command-line.  Helps avoiding
" hit-enter prompts.
set cmdheight=2

" If nothing typed in these milliseconds, swap file will be written
" Also used for CursorHold command event.
set updatetime=300

" }}}
