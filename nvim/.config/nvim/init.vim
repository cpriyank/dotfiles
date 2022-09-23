" vim: set foldmethod=marker foldlevel=0
" ============================================================================
" init.vim of Priyank Chaudhary. Many thanks to Junegunn Choi, Ben Alman,
" Matthias Bynes, Brandon Amos, and Paul Irish, Liu-Cheng Xu
" ============================================================================
" VIM-PLUG BLOCK {{{
" ============================================================================

" Setup vim plug if not already
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

silent! if plug#begin('~/.local/share/nvim/plugged')

" File/project management
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-gtfo' " (xdg-)open terminal/tmux pane/file manager of current directory with got and gof
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKeyVisual', 'WhichKey!', 'WhichKeyVisual!'] } " Show keybinds in a popup
" Plug 'mhinz/vim-startify' " :startify, :SSave, :SLoad, and nice startup screen

" Colors
Plug 'AlessandroYorba/Despacio'
Plug 'cocopon/iceberg.vim'
Plug 'junegunn/seoul256.vim'
Plug 'w0ng/vim-hybrid'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'tomasr/molokai'

" Other visual enhancement
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
set noshowmode
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable', 'for': 'python' }
" TODO: autocmd
autocmd! User indentLine doautocmd indentLine Syntax
" Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " semantic highlight for Python
Plug 'romainl/vim-cool' " disables search highlighting when you are done searching and re-enables it when you search again.

" Edit
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch' " :Rename, Delete, Chmod, Mkdir, SudoWrite, SudoEdit, Move commands
Plug 'rhysd/clever-f.vim' " Extended f, F, t and T key mappings for Vim
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'vim-scripts/ReplaceWithRegister' " replace selection or motion with register with gr
Plug 'AndrewRadev/splitjoin.vim' "gS and gJ to split/join single/multiple lines
" Plug 'AndrewRadev/switch.vim'
Plug 'junegunn/vim-online-thesaurus'
Plug 'sgur/vim-editorconfig'
if exists('##TextYankPost')
  Plug 'machakann/vim-highlightedyank'
  let g:highlightedyank_highlight_duration = 100
endif
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vim-emoji'
Plug 'junegunn/vim-peekaboo' " extends \" and @ in normal mode and <CTRL-R> in insert mode so you can see the contents of the registers
Plug 'junegunn/vim-after-object' " Target text *after* the designated characters
Plug 'justinmk/vim-sneak' " motion enhancement
let g:sneak#label = 1
" motion within camel and snake case with ",w"
Plug 'vim-scripts/camelcasemotion', {'for': ['Java', 'Python', 'Go', 'C++']}
Plug 'AndrewRadev/splitjoin.vim' " Split/join line(s) with gS and gJ
" Plug 'ConradIrwin/vim-bracketed-paste'  " Automatic `:set paste`¬
Plug 'cohama/lexima.vim' " Automatically close brackets, quotes, etc
" Plug 'ervandew/supertab' " all vim insert mode completions with Tab

" Plug 'Shougo/neoinclude.vim'
" Plug 'jsfaint/coc-neoinclude'
" Use release branch
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'honza/vim-snippets'

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim' " Git commit browser
Plug 'tpope/vim-rhubarb' " Hub command interface
Plug 'airblade/vim-gitgutter' " Git diff in signing column

" Lang
" Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoInstallBinaries' }
" Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'dag/vim-fish'
" Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'liuchengxu/vista.vim' " Viewer & Finder for LSP symbols and tags
" TODO: this can be removed in favor of vista.vim
Plug 'lyuts/vim-rtags', { 'for': ['c', 'cpp'] }
" Plug 'derekwyatt/vim-scala'
" Plug 'jackguo380/vim-lsp-cxx-highlight', { 'for': ['c', 'cpp'] }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Notes
" Plug 'lervag/wiki.vim'
" let g:wiki_root = '~/z/notes/work'
" let g:wiki_filetypes = ['md']
" let g:wiki_link_extension = '.md'

Plug 'ryanoasis/vim-devicons' " Has to be loaded last
set guifont=InconsolataLGC\ Nerd\ Font:h16 " nerd fonts are required for vim-devicons

call plug#end()
endif

" Source other config files now
for s:path in split(expand('~/.config/nvim/*.vimrc'), "\n")
  execute 'source ' .. s:path
endfor
