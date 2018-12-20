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

" Begin adding plugins here. Managed by vim-plug-----------------------------
call plug#begin()

"" Filesystem and project management
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' } " Tree explorer
Plug 'airblade/vim-gitgutter' " shows a git diff in the 'gutter' (sign column)
Plug 'majutsushi/tagbar' " explore tags with <leader>t
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

"" Language specific
Plug 'fatih/vim-go', {'for': 'go'}
Plug 'octave.config/nvim', {'for': 'octave'}
" Plug 'derekwyatt/vim-scala', {'for': 'scala'}
Plug 'ap/vim-css-color', {'for': 'css'} " preview colors when editing
" CamelCase and snake_case motions
Plug 'vim-scripts/camelcasemotion', {'for': ['Java', 'Python', 'Go', 'C++']}
Plug 'JamshedVesuna/vim-markdown-preview', {'for': 'markdown'}

"" Snippets and abbreviations
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

"" Writing/editing helpers
Plug 'tpope/vim-commentary' " Commenting helper
Plug 'tpope/vim-surround' " Simplified quoting and parenthesizing
Plug 'tpope/vim-repeat' " repeat some of tpope plugin actions with '.'
Plug 'tpope/vim-abolish' " Search for, substitute, and abbreviate words
Plug 'nsf/gocode', { 'rtp': 'nvim', 'do': '~/.config/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
" Plug 'zchee/deoplete-go', { 'do': 'make'}
" function! BuildYCM(info)
"   if a:info.status == 'installed' || a:info.force
"     !./install.py --clang-completer --gocode-completer
"   endif
" endfunction
" Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" Plug 'w0rp/ale'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
" Plug 'ervandew/supertab' " all vim insert mode completions with Tab

"" Visual
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/limelight.vim' " Hyperfocus-writing in Vim.
Plug 'junegunn/goyo.vim' " Distraction-free writing in Vim
Plug 'junegunn/seoul256.vim' " Seoul256 colorscheme

"" Misc
Plug 'ConradIrwin/vim-bracketed-paste'  " Automatic `:set paste`¬
Plug 'tpope/vim-unimpaired' " Handy bracket mappings
Plug 'junegunn/vim-easy-align'
Plug 'cohama/lexima.vim' " Automatically close brackets, quotes, etc
Plug 'chrisbra/CheckAttach' " Will always have your back
Plug 'terryma/vim-multiple-cursors' " Sublime style multiple selections
call plug#end()

" Essentials------------------------------------------------------------
set encoding=utf-8 nobomb " BOM often causes trouble
set linespace=0 " No extra spaces between rows
set hidden " Allow switching buffers without saving
set report=0 " Show all changes
set clipboard=unnamed " Make yanks go to OS clipboard
" set esckeys " Allow cursor keys in insert mode
let mapleader=" "  " Change default backslash mapleader. Easier to type
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


" Looks-----------------------------------------------------------------
set background=dark
" True color support. Neovim ignores t_Co
set termguicolors

" let base16colorspace=256 " " Access colors present in 256 colorspace
" seoul256 (light):
"   Range:   252 (darkest) ~ 256 (lightest)
"   Default: 253
" seoul256 (dark):
"   Range:   233 (darkest) ~ 239 (lightest)
"   Default: 237
let g:seoul256_background = 237

try  " Don't use a color scheme if not found
  colorscheme seoul256
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


" Custom shortcuts for moving around buffers----------------------------
" Switch between the last two files with double space
map <leader><leader> :b#<CR>


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
" Save file with <leader>w in normal mode
nnoremap <leader>w :w<CR>

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

" Delete current buffer
nmap <Leader>d :b#<bar>bd#<CR>

" Delete current file and buffer
nnoremap <leader>dd :call delete(expand('%')) \| bdelete!<CR>

" build graphviz file --------------------------------------------------------
autocmd FileType dot nmap <leader>mb :!dot -Tpng -Gdpi=600 % > (basename % .dot).png<CR>
autocmd FileType dot nmap <leader>mv :!open (basename % .dot).png<CR>

" Tagbar ---------------------------------------------------------------------
nnoremap <silent> <leader>t :TagbarToggle<CR>

" Plugins and their respective configuration----------------------------------
" NERDTree
let NERDTreeShowHidden = 1
let NERDTreeMouseMode = 2
let NERDTreeMinimalUI = 1
map <leader>n :NERDTreeToggle<CR>

" go specific and vim-go config ----------------------------------------------
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd FileType go nmap <leader>mb :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>mr  <Plug>(go-run)
let g:go_list_type = "quickfix"

" Recommended setting to improve deoplete-go performance
" let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
" let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#cmd#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

" for python completion ------------------------------------------------------
" TODO: Use :terminal or system() to fix this for different platform
let g:python2_host_prog =  '/usr/local/bin/python2'
let g:python3_host_prog = '/usr/local/bin/python3'

" EasyAlign ------------------------------------------------------------------
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)<Paste>

" LimeLight and Goyo----------------------------------------------------------
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
nnoremap <leader>vg :Goyo<CR>

" Lightline ------------------------------------------------------------------
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ }

" " Ale-------------------------------------------------------------------------
" let g:ale_sign_column_always = 1
" " Write this in your vimrc file
" let g:ale_lint_on_text_changed = 'never'
" " You can disable this option too
" " if you don't want linters to run on opening a file
" let g:ale_lint_on_enter = 0

" Fzf ------------------------------------------------------------------------
" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Similarly, we can apply it to fzf#vim#grep. To use ripgrep instead of ag:
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

" for commands supplied by fzf
nnoremap <leader>f :Files<CR>  " Files in current project
nnoremap <leader>fg :GFiles<CR> " Git files
nnoremap <leader>gst :GFiles?<CR> " Git status files
nnoremap <leader>fl :Lines<CR>
nnoremap <leader>fbl :BLines<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>rg :Rg
nnoremap <leader>r :History<CR>
nnoremap <leader>rc :History:<CR>
" nnoremap <leader>fgg Commits<CR>
" nnoremap <leader>fcb BCommits<CR>

" " YCM-------------------------------------------------------------------------
" " Remapping Ultisnips trigger for YouCompleteMe
" let g:UltiSnipsExpandTrigger="<c-j>"

" " Accept completions with <Enter>
" " let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
" let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
" let g:ycm_autoclose_preview_window_after_completion = 1
" let g:ycm_filepath_completion_use_working_dir=1

" " Markdown--------------------------------------------------------------------
" " Use github flavored markdown
" let vim_markdown_preview_github=1
" " display images automatically on buffer write
" let vim_markdown_preview_toggle=2


let g:LanguageClient_serverCommands = {
			\ 'python': ['/usr/local/bin/pyls'],
			\ 'cpp': ['clangd'],
			\ }
let g:deoplete#enable_at_startup = 1
nnoremap <silent> gr :call LanguageClient_textDocument_rename()<CR>
nnoremap <silent> gh :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <leader>lf :call LanguageClient#textDocument_formatting()<CR>

" neosnippets-----------------------------------------------------------------
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
