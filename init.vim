"
" bundle
"
"
set nocompatible
set splitbelow

call plug#begin()
	" colorscheme plugin
	Plug 'themercorp/themer.lua'
	Plug 'scrooloose/nerdtree' |
		\ Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'sheerun/vim-polyglot'
	Plug 'windwp/nvim-autopairs'
	Plug 'vim-airline/vim-airline'	
	Plug 'vim-airline/vim-airline-themes'
	
	" CocInstall <LSP server>
	" python coc-pyright, 
	" Cmake coc-cmake
	" C, Cpp sudo apt-get install clangd-12 and coc-clangd
	Plug 'neoclide/coc.nvim', {'branch': 'release'} 
	"TSInstall <language-name>
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	"Python envornment
	Plug 'AckslD/swenv.nvim' |
		\ Plug 'nvim-lua/plenary.nvim'
	
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


let g:airline_theme = "atomic"
let g:airline#extensions#tabline#enabled = 1              " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'          " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format

let g:airline_powerline_fonts = "1"

nnoremap <C-S-t> :enew<Enter>         
nnoremap <C-h> :bprevious!<Enter>   
nnoremap <C-l> :bnext!<Enter>   
nnoremap <C-x> :bp <BAR> bd #<Enter>

"
"
" mapping key
"
"

nnoremap <F5> :execute complier_oper<CR>
nnoremap <F6> :execute complier_run_oper<CR>
nnoremap <F10> :execute terminal_with_sp<CR>
nnoremap <F12> :!code %<CR>
nnoremap <C-A> ggVG<CR>

vnoremap <Bs> d<CR>

tnoremap <Esc> <C-\><C-n>
"tnoremap <Esc> <C-\><C-n>:q!<CR>
"
"
" configure vimrc
"
"

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

let has_term = 0
"
"

lua << EOF
vim.opt.nu = true
vim.opt.relativenumber = true
require("nvim-autopairs").setup({})

require("themer").setup({
	colorscheme = "rose_pine_moon",
	styles = {
		["function"] = { style = 'italic' },
		functionbuiltin = { style = 'italic' },
		variable = { style = 'italic' },
		variableBuiltIn = { style = 'italic' },
		parameter  = { style = 'italic' },
	},
})

require("swenv").setup({
	-- Should return a list of tables with a `name` and a `path` entry each.
	-- Gets the argument `venvs_path` set below.
	-- By default just lists the entries in `venvs_path`.
	get_venvs = function(venvs_path)
		return require('swenv.api').get_venvs(venvs_path)
	end,
	-- Path passed to `get_venvs`.
	venvs_path = vim.fn.expand('~/venvs'),
	post_set_venv = nil,
})

function _G.check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')~= nil
end

local keyset = vim.keymap.set
local nkeyset = vim.api.nvim_set_keymap
local opts = {silent=true, noremap=true, expr=true, replace_keycodes=false}
local nopts = {silent=true, noremap=true}

-- custom key

keyset(
	"i",
	"<TAB>",
	'coc#pum#visible()?coc#pum#next(1) :v:lua.check_back_space() ? "<TAB>" : coc#refresh()',
	opts
)

keyset(
	"i",
	"<S-TAB>",
	[[coc#pum#visible()?coc#pum#prev(1) : "\<C-h>"]],
	opts
)

nkeyset("n", "<leader>n", [[:NERDTreeFocus<CR>]], nopts)
nkeyset("n", "<C-n>", [[:NERDTree<CR>]], nopts)
nkeyset("n", "<C-t>", [[:NERDTreeToggle<CR>]], nopts)
nkeyset("n", "<C-f>", [[:NERDTreeFind<CR>]], nopts)

local function findTerminal()
    local buffIds = vim.api.nvim_list_bufs()
    for i, x in pairs(buffIds) do
        if string.find(vim.api.nvim_buf_get_name(x), "term") then
            return x
        end
    end
    return nil
end


local function openTerminallocal()
    local currentDir = vim.fn.expand('%:p:h')
    -- vim.cmd("belowright 10split")
    vim.cmd("belowright 12split")
    vim.cmd("wincmd j")
    local currentTerminal = findTerminal()
    if currentTerminal ~= nil then
        -- print("terminal found")
        vim.cmd("buf " .. currentTerminal)
        vim.cmd("startinsert")
    else
        -- print("no terminal found")
        vim.cmd("term")
        vim.cmd("startinsert")
        vim.api.nvim_input("cd " .. currentDir .. "\n")
        vim.api.nvim_input("clear\n")
    end
end

local function openTerminal()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'terminal' then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, true, true), 'n', true)
        return
    end
    vim.cmd("belowright 12split")
	vim.cmd("wincmd j")
    local currentTerminal = findTerminal()
    if currentTerminal ~= nil then
        -- print("terminal found")
        vim.cmd("buf " .. currentTerminal)
    else
        -- print("no terminal found")
        vim.cmd("term")
    end
    vim.cmd("startinsert")
end

vim.keymap.set('n', '<A-t>', openTerminallocal, {noremap=true, silent=true})
vim.keymap.set('n', '<A-T>', openTerminal, {noremap=true, silent=true})
vim.keymap.set('t', '<A-t>', '<C-\\><C-n>:q<CR>') -- quit the terminal window
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })

EOF

