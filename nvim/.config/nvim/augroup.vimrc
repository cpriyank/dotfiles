" ----------------------------------------------------------------------------
" General Config {{{
" ----------------------------------------------------------------------------
augroup general_config
  autocmd!
  " Leader key
  let g:mapleader = "\<Space>"
  let g:maplocalleader = ','

  " Show absolute numbers in insert mode, otherwise relative line numbers.
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber

  " When editing a file, always jump to the last known cursor position, except
  " for commit messages, invalid position, or when inside an event
  " handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

augroup END
" }}}

" ----------------------------------------------------------------------------
" plugin_vim_which_key {{{
" ----------------------------------------------------------------------------
augroup plugin_vim_which_key
  autocmd!
  let g:which_key_vertical = 1 " show all entries in a single column
  autocmd! FileType which_key
  autocmd FileType which_key set laststatus=0 noshowmode noruler
        \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
  autocmd User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
  nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
  " Show commands provided by vim-unimpaired
  nnoremap <silent> [ :<c-u>WhichKey  '['<CR>
  let g:which_key_map = {}
  let g:which_key_map.b = {
        \ 'name' : '+buffer' ,
        \ '1' : ['b1'        , 'buffer 1']        ,
        \ '2' : ['b2'        , 'buffer 2']        ,
        \ 'b' : ['Buffers'        , 'fzf-buffer']        ,
        \ 'd' : [',d'        , 'delete-buffer']   ,
        \ 'l' : ['blast'     , 'last-buffer']     ,
        \ 'n' : ['bnext'     , 'next-buffer']     ,
        \ 'p' : ['bprevious' , 'previous-buffer'] ,
        \ 's' : ['w' , 'save-buffer'] ,
        \ 't' : ['Btags' , 'buffer-tag-search'] ,
        \ 'S' : ['wall' , 'save-all-buffers'] ,
        \ 'z' : ['<Plug>(zoom-toggle)' , 'zoom-buffer'] ,
        \ '?' : ['Buffers'   , 'fzf-buffer']      ,
        \ }
  " ----------------------------------------------------------------------------
  " <Leader>c Close quickfix/location window
  " ----------------------------------------------------------------------------
  nnoremap <leader>c :cclose<bar>lclose<cr>
  let g:which_key_map.e = {
        \ 'name' : '+errors',
        \ }
  let g:which_key_map.f = {
        \ 'name' : '+file/fzf',
        \ 'f' : ['Files', 'fzf-files'],
        \ 'g' : ['GFiles', 'fzf-git-files'],
        \ 'r' : ['History', 'fzf-recent-files'],
        \ 's' : ['w', 'save-file'],
        \ 'S' : ['wall', 'save-all-files'],
        \ }
  let g:which_key_map.g = {
        \ 'name' : '+git',
        \ 'b' : ['BCommits', 'buffer-commits'],
        \ '?' : ['Commits', 'fzf-commits'],
        \ }
  let g:which_key_map.j = {
        \ 'name' : '+jump',
        \ }
  let g:which_key_map.l = {
        \ 'name' : '+lsp',
        \ 'l' : ['<Plug>(coc-codeaction-selected)<CR>', 'code-action'],
        \ 'f' : ['<Plug>(coc-fix-current)', 'quickfix'],
        \ 'e' : ['CocCommand#python.execInTerminal<CR>', 'execute-current-file'],
        \ }
  let g:which_key_map.q = {
        \ 'name' : '+quit',
        \ 'q' : ['wq', 'save-and-quit'],
        \ 'Q' : ['qall!', 'quit-all'],
        \ }
  let g:which_key_map.r = {
        \ 'name' : '+ripgrep/refactor/replace',
        \ 'g' : ['Rg', 'search-with-rg'],
        \ 'c' : ['<Plug>(coc-rename)', 'coc-rename'],
        \ 'r' : ['<Plug>(FNR)', 'replace-under-cursor'],
        \ }
  " send selection to other buffer
  " vnoremap <leader>sp y<C-w>wp<C-w>w<CR>
  xnoremap <leader>sp y<C-w>wp<C-w>w<CR>
  let g:which_key_map.s = {
        \ 'name' : '+search/selection/strip',
        \ 'r' : ['Rg', 'with-ripgrep'],
        \ 's' : ['StripWhitespace()', 'strip-whitespace'],
        \ }
  " " ----------------------------------------------------------------------------
  " tmux
  " ----------------------------------------------------------------------------
  function! s:tmux_send(content, dest) range
    let dest = empty(a:dest) ? input('To which pane? ') : a:dest
    let tempfile = tempname()
    call writefile(split(a:content, "\n", 1), tempfile, 'b')
    call system(printf('tmux load-buffer -b vim-tmux %s \; paste-buffer -d -b vim-tmux -t %s',
          \ shellescape(tempfile), shellescape(dest)))
    call delete(tempfile)
  endfunction

  function! s:tmux_map(key, dest)
    execute printf('nnoremap <silent> %s "tyy:call <SID>tmux_send(@t, "%s")<cr>', a:key, a:dest)
    execute printf('xnoremap <silent> %s "ty:call <SID>tmux_send(@t, "%s")<cr>gv', a:key, a:dest)
  endfunction

  call s:tmux_map('<leader>tt', '')
  call s:tmux_map('<leader>th', '.left')
  call s:tmux_map('<leader>tj', '.bottom')
  call s:tmux_map('<leader>tk', '.top')
  call s:tmux_map('<leader>tl', '.right')
  call s:tmux_map('<leader>ty', '.top-left')
  call s:tmux_map('<leader>to', '.top-right')
  call s:tmux_map('<leader>tn', '.bottom-left')
  call s:tmux_map('<leader>t.', '.bottom-right')
  " note that tt, th, tj, tk, tl, ty, to, tn, t. are reserved by tmux_map
  let g:which_key_map.t = {
        \ 'name' : '+tag/toggle/todo',
        \ 'j' : ['g<C-]>', 'jump-to-tag'],
        \ 'n' : ['g[', 'next-tag'],
        \ '?' : ['Tags', 'search-tags'],
        \ 's' : ['Todo', 'show-todo'],
        \ }
  let g:which_key_map['w'] = {
        \ 'name' : '+windows' ,
        \ 'w' : ['<C-W>w'     , 'other-window']          ,
        \ 'd' : ['<C-W>c'     , 'delete-window']         ,
        \ '-' : ['<C-W>s'     , 'split-window-below']    ,
        \ '|' : ['<C-W>v'     , 'split-window-right']    ,
        \ '2' : ['<C-W>v'     , 'layout-double-columns'] ,
        \ 'h' : ['<C-W>h'     , 'window-left']           ,
        \ 'j' : ['<C-W>j'     , 'window-below']          ,
        \ 'l' : ['<C-W>l'     , 'window-right']          ,
        \ 'k' : ['<C-W>k'     , 'window-up']             ,
        \ 'H' : ['<C-W>5<'    , 'expand-window-left']    ,
        \ 'J' : ['resize +5'  , 'expand-window-below']   ,
        \ 'L' : ['<C-W>5>'    , 'expand-window-right']   ,
        \ 'K' : ['resize -5'  , 'expand-window-up']      ,
        \ '=' : ['<C-W>='     , 'balance-window']        ,
        \ 's' : ['<C-W>s'     , 'split-window-below']    ,
        \ 'v' : ['<C-W>v'     , 'split-window-below']    ,
        \ 'q' : ['wq'     , 'save-and-quit']    ,
        \ '?' : ['Windows'    , 'fzf-window']            ,
        \ }
  let g:which_key_map.x = {
        \ 'name' : '+text',
        \ }
augroup END
" }}}

" Keybindings based on commands and functions in commands.vimrc {{{
augroup command_mappings
  autocmd!
  " help in new tab and closed with q
  autocmd BufEnter *.txt call Helptab()
augroup END
" }}}

" FileTypes ------------------------------------------------------------------
" ----------------------------------------------------------------------------
" graphviz {{{
" ----------------------------------------------------------------------------
augroup filetype_graphviz
  autocmd!
  " build and view graphviz file
  autocmd FileType dot nmap <leader>mb :!dot -Tpng -Gdpi=600 % > $(basename % .dot).png<CR>
  autocmd FileType dot nmap <leader>mv :!xdg-open $(basename % .dot).png &<CR>
augroup END
" }}}
" ----------------------------------------------------------------------------
" json {{{
" ----------------------------------------------------------------------------
augroup filetype_json
  autocmd!
  " https://vi.stackexchange.com/questions/7258/how-do-i-prevent-vim-from-hiding-symbols-in-markdown-and-json
  autocmd FileType json set conceallevel=0
augroup END
" }}}

" ----------------------------------------------------------------------------
" markdown {{{
" ----------------------------------------------------------------------------
augroup filetype_markdown
  autocmd!
  " https://vi.stackexchange.com/questions/7258/how-do-i-prevent-vim-from-hiding-symbols-in-markdown-and-json
  autocmd FileType markdown set conceallevel=0
  " Build and view markdown files
  autocmd FileType markdown nnoremap <leader>mb :!pandoc -c styles/solarized.css -s % -o $(basename % .md).html<CR>
  autocmd FileType markdown nnoremap <leader>mv :!firefox $(basename % .md).html<CR>

  " TODO: reliably detect if Typora is installed
  if has('mac')
    autocmd FileType markdown nnoremap <leader>mv !open -a Typora %<CR>
  endif
  " autocmd BufRead,BufNewFile *.md :Goyo 80
  " autocmd BufRead,BufNewFile *.md :g/^Example/d
  autocmd FileType markdown nnoremap <leader>h1 0i# <Esc>
  autocmd FileType markdown nnoremap <leader>h2 0i## <Esc>
  autocmd FileType markdown nnoremap <leader>h3 0i### <Esc>
  autocmd FileType markdown nnoremap <leader>h4 0i##### <Esc>
  autocmd FileType markdown nnoremap <leader>hq 0i> <Esc>
  autocmd FileType markdown vnoremap <leader>hq 0i> <Esc>
  autocmd FileType markdown nnoremap <leader>bf o<CR>## Brute Force<CR><CR>
  autocmd FileType markdown nnoremap <leader>kk o<CR>## Key Insight<CR><CR>
  autocmd FileType markdown nnoremap <leader>ki o<CR>## Key Insight<CR><CR>
  autocmd FileType markdown nnoremap <leader>pp o<CR>```python<CR><CR>```<Esc>ki
  autocmd FileType markdown nnoremap <leader>eq o<CR>$$<CR><CR>$$<Esc>ki
  autocmd FileType markdown set dictionary+=/usr/share/dict/american-english
  autocmd FileType markdown set complete+=k
augroup END
" }}}

" ----------------------------------------------------------------------------
" latex {{{
" ----------------------------------------------------------------------------
augroup filetype_tex
  autocmd!
  " https://vi.stackexchange.com/questions/7258/how-do-i-prevent-vim-from-hiding-symbols-in-markdown-and-json
  autocmd FileType tex set conceallevel=0
  " Build latex file
  autocmd FileType tex nnoremap <leader>mb :!pdflatex %<CR>
  autocmd FileType tex nnoremap <leader>mv :!zathura $(basename % .tex).pdf<CR>
augroup END
" }}}
