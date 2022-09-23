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

  autocmd BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand("%"))

  " When editing a file, always jump to the last known cursor position, except
  " for commit messages, invalid position, or when inside an event
  " handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

augroup END
" }}}

" Jumping to tags {{{
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

" ----------------------------------------------------------------------------
" mappings bound to <leader> key {{{
" ----------------------------------------------------------------------------
augroup leader_mappings
  autocmd!
  nnoremap <leader>c :cclose<bar>lclose<cr>
  nnoremap <leader>w :w<CR>
  nnoremap <leader>q :wq<CR>
  " Tell FZF to use RG - so we can skip .gitignore files even if not using
  " :GitFiles search
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>bb :Buffers<CR>
  nnoremap <leader>fg :GFiles<CR>
  nnoremap <leader>fr :History<CR>
  nnoremap <leader>rg :Rg<CR>
  nnoremap <leader>se :CocCommand snippets.editSnippets<CR>
  nnoremap <leader>ss :call StripWhitespace()<CR>
  nnoremap <leader>sr :%s:::g<Left><Left><Left>
 " send selection to other buffer
  " vnoremap <leader>sp y<C-w>wp<C-w>w<CR>
  xnoremap <leader>sp y<C-w>wp<C-w>w<CR>

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
augroup END
" }}}

" ----------------------------------------------------------------------------
" Goyo {{{ Settings for goyo.vim with limelight
" ----------------------------------------------------------------------------
augroup zen_mode_settings
  autocmd!
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  " Goyo opens another buffer, so setting an option locally does not change
  " setting for any other buffer 😅
  setlocal nolist
  Limelight
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
endfunction

autocmd User GoyoEnter nested call <SID>goyo_enter()
autocmd User GoyoLeave nested call <SID>goyo_leave()
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
  autocmd FileType markdown nnoremap <leader>mb :AsyncRun pandoc -c styles/pandoc.css -s % -o $(basename % .md).html<CR>
  autocmd FileType markdown nnoremap <leader>mv :silent AsyncRun pandoc -c styles/pandoc.css -s % -o $(basename % .md).html && firefox $(basename % .md).html<CR>
  autocmd FileType markdown nnoremap <leader>mt :AsyncRun typora %<CR>

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
  " Some LaTeX types
  autocmd BufRead,BufNewFile *.cls setfiletype tex
  autocmd BufRead,BufNewFile *.lco setfiletype tex
  " https://vi.stackexchange.com/questions/7258/how-do-i-prevent-vim-from-hiding-symbols-in-markdown-and-json
  autocmd FileType tex set conceallevel=0
augroup END
" }}}
