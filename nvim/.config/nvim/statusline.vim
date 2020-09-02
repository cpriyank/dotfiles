augroup status_line
	autocmd!
	" To view unicode glyphs, make sure you are using any of nerd fonts
	" To enter unicode by its code point, in insert mode, see
	" https://vim.fandom.com/wiki/Entering_special_characters
	" and for code points, see https://www.nerdfonts.com/cheat-sheet
	" for example, nf-dev-swift has a code point of e755. Press Ctrl-V and U and
	" e755 to enter it 

	let s:status_line_separator = '   '
	let s:file_type_mappings = {
				\ 'python' : '',
				\ 'vim' : '',
				\}

	function s:FilePath() abort
		" return '%.40F' " At most 40 characters of full file path
		return '%F' " Full path
	endfunction

	function! s:BuildModeString() abort
		let l:current_mode = mode()
		return l:current_mode
	endfunction

	" See if paste/nopaste option is set
	function! s:PasteStatus() abort
		return &paste ? 'PASTE ' : ''
		endfunction

	function! s:GitStatus() abort
		return exists('g:loaded_fugitive') ? FugitiveStatusLine() : ''
	endfunction

	function! s:IsTmpFile() abort
  if !empty(&buftype)
        \ || index(['startify', 'gitcommit'], &filetype) > -1
        \ || expand('%:p') =~# '^/tmp'
    return 1
  else
    return 0
  endif
endfunction

function! s:ReadOnly() abort
	  return &readonly ? '[RO] ' : ''
endfunction

" required plugin: coc-nvim
function! s:CocStatus() abort
  if s:IsTmpFile() | return '' | endif
  if get(g:, 'coc_enabled', 0) | return coc#status().' ' | endif
  return ''
endfunction

	function! s:OsLogo() abort
		return ''
	endfunction

	function! s:ModifiedStatus() abort
		return &modified ? '[+] ' : !&modifiable ? '  ' : ''
	endfunction

	function! s:FileType() abort
				  return len(&filetype) ? s:file_type_mappings[&filetype] : ''
	endfunction

function! s:statusline_expr() abort
	let l:coc_status = s:CocStatus()
	let l:mode = s:BuildModeString()
	let l:paste_status = s:PasteStatus()
	let l:full_file_path = s:FilePath()
	let l:modified_status = s:ModifiedStatus()
	let l:read_only = s:ReadOnly()
	let l:git_status = s:GitStatus()
	let l:file_type = s:FileType()
	let l:os_logo = s:OsLogo()
  let l:fugitive_status = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let l:separator = ' %= '
  let l:cursor_position = '%-12(%l : %c%V%)'
  let l:percentage_file_through_current_window = '%P'
	let l:status_string = join([l:coc_status, l:mode, l:paste_status, l:full_file_path,
				\ l:modified_status, l:read_only, l:git_status, l:file_type, l:os_logo,
				\ l:separator, l:fugitive_status, l:cursor_position, l:percentage_file_through_current_window,
				\], s:status_line_separator)

	return l:status_string
  " return '%F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

augroup END