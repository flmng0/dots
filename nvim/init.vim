call plug#begin("~/.local/share/nvim/plugged")
	" Autocompletion
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

	" Ctags support
	Plug 'majutsushi/tagbar'

	" Syntax highlighting and linting
	Plug 'vim-syntastic/syntastic'
	
	" Rust compatibility
	Plug 'rust-lang/rust.vim'
call plug#end()

" Extension settings
let g:deoplete#enable_at_startup = 1

"" Basic configurations.
" Tabwidth.
set tabstop=4
set shiftwidth=0

" Hybrid relative numbers.
set number relativenumber

" Toggle between relative and absolute numbers
" when entering a buffer or insert mode.
augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

"" Normal mode.
" Unmap arrow keys.
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

" Use semicolon for colon.
nnoremap ; :

"" Insert mode.
" Leave insert mode with 'jk'.
inoremap jk <ESC>

