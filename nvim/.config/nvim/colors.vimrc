" seoul256 (dark):
"   Range:   233 (darkest) ~ 239 (lightest)
"   Default: 237
" seoul256 (light):
"   Range:   252 (darkest) ~ 256 (lightest)
"   Default: 253
let g:seoul256_background = 235

if has('gui_running')
  set guifont=Consolas:h14 columns=80 lines=40
  silent! colorscheme seoul256-light
else
  silent! colorscheme iceberg
endif

