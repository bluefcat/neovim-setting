"
"
" bundle
"
"

set nocompatible
filetype off

call plug#begin()
	" colorscheme plugin
	Plug 'themercorp/themer.lua'
	Plug 'scrooloose/nerdtree' |
		\ Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'sheerun/vim-polyglot'

call plug#end()

filetype plugin indent on
	"
	" Brief help
	" :BundleList          - list configured bundles
	" :BundleInstall(!)    - install(update) bundles
	" :BundleSearch(!) foo - search(or refresh cache first) for foo
	" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
	"
	" see :h vundle for more details or wiki for FAQ
	" NOTE: comments after Bundle command are not allowed..
	"
	" :PlugInstall [name ...] [#threads]
	" :PlugUpdate [name ...] [#threads]
	" :PlugClean[!]
	" :PlugUpgrade
	" :PlugStatus
	" :PlugDiff
	" :PlugSnapshot[!] [output path]
	"

"
"
" configure plugin 
"
"

" rainbow braket
let g:rainbow_active = 1
let g:rainbow_load_separately = [
    \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
    \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
    \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
    \ ]

"let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
"let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']

" NERDTree setting
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree and leave the cursor in it.
auto VimEnter * NERDTree

" Close the tab if NERDTree is the only window remaining in it.
auto BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

"
"
" configure function 
"
"

function Compiler(ext)
	if a:ext == 'c'
		return "!gcc % -o ./a.out -lm"
	endif

	if a:ext == 'cpp'
		return "!g++ % -o ./a.out -pthread -lm"
	endif

	if a:ext == 'py'
		return "!python3 %"
	endif

	return '0'
endfunction

let extension = expand('%:e')
let complier_oper = Compiler(extension)
let complier_run_oper = Compiler(extension) . ' && ./a.out'

let terminal_with_sp = "10sp | terminal"

"
"
" mapping key
"
"

nnoremap <F5> :execute complier_oper<CR>
nnoremap <F6> :execute complier_run_oper<CR>
nnoremap <F10> :execute terminal_with_sp<CR>
nnoremap <F12> :!code %<CR>

tnoremap <Esc> <C-\><C-n>
"tnoremap <Esc> <C-\><C-n>:q!<CR>
"
"
" configure vimrc
"
"

set number

if has("syntax")
	syntax on
endif

au BufNewFile, BufRead *.cpp set syntax=cpp11

set encoding=utf8
set autoindent

set shiftwidth=4
set tabstop=4
set cindent

set smartindent
set smartcase
set smarttab

set fileencodings=utf-8,euc-kr
set bs=indent,eol,start
set nobackup

"
"
" colorsheme with themer
"
"

lua << EOF
	require("themer").setup({
		colorscheme = "rose_pine",
		styles = {
			["function"] = { style = 'italic' },
			functionbuiltin = { style = 'italic' },
			variable = { style = 'italic' },
			variableBuiltIn = { style = 'italic' },
			parameter  = { style = 'italic' },
	  	},
	})
EOF
