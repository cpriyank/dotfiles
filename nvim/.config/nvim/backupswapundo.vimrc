" BACKUP, SWAP, PERSISTENT_UNDO {{{
" ============================================================================

" Keep clutter under one roof
" set backupdir=~/.config/nvim/backup " Centralize backups, currently disabled
" with nobackup
" But don’t create backups when editing files in certain directories
" set backupskip=/tmp/*,/private/tmp/*
" Some servers have issues with backup files
set nobackup
set nowritebackup

set directory=~/.config/nvim/swap " Centralize swaps

if exists("&undodir") " Keen undo history in one place
  set undodir=~/.config/nvim/undo
endif

" Persistent Undo
" Keep undo history across sessions, by storing in file.
if has('persistent_undo')
  set undodir=~/.config/nvim/undo
  set undofile
endif

" TODO: Checkout help pages of mkview, shada, mksession commands

" }}}
