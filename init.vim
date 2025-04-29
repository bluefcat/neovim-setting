"
" bundle
"
"
set mouse=
set nocompatible
set splitbelow
set noerrorbells vb t_vb=
set belloff=all

if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif

filetype plugin indent on
syntax on

call plug#begin()
	" colorscheme plugin
	Plug 'themercorp/themer.lua'
	Plug 'scrooloose/nerdtree' |
		\ Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'sheerun/vim-polyglot'
	Plug 'windwp/nvim-autopairs'
	Plug 'vim-airline/vim-airline'	
	Plug 'vim-airline/vim-airline-themes'
	
	"TSInstall <language-name>
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'neovim/nvim-lspconfig'

	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'saadparwaiz1/cmp_luasnip'
	Plug 'L3MON4D3/LuaSnip'

	" Telescope 플러그인 설치
	Plug 'nvim-telescope/telescope.nvim', {'tag': '0.1.0'}
	Plug 'nvim-lua/plenary.nvim'    " telescope.nvim의 의존성

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

"au BufNewFile, BufRead *.cpp set syntax=cpp11

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

lua << EOF
vim.opt.nu = true
vim.opt.relativenumber = true
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr="nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false

require("nvim-autopairs").setup({})

require("nvim-treesitter.configs").setup({
	ensure_installed={"lua", "c", "cpp", "python", "vim"},
	highlight = { 
		enable = true ,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
	folding = { enable = true, },
})

require('mason').setup()
require('mason-lspconfig').setup({
	ensure_installed = { "pyright" }
})

local lspconfig = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

lspconfig.pyright.setup({
	capabilities = capabilities,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true
			}
		}
	}
})

lspconfig.clangd.setup({
	capabilities = capabilities,
	cmd = {"clangd"}
})

-- nvim-cmp 설정
local cmp = require('cmp')

cmp.setup({
  -- 자동완성 설정
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },      -- LSP 소스
    { name = 'buffer' },        -- 버퍼 소스
    { name = 'path' },          -- 경로 소스
    { name = 'luasnip' },       -- 스니펫
  },
})

local telescope = require('telescope.builtin')
-- 정의로 이동 기능 설정
vim.keymap.set('n', 'gd', function()
  telescope.lsp_definitions()
end)

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

nkeyset("n", "<leader>n", [[:NERDTreeFocus<CR>]], nopts)
nkeyset("n", "<C-t>", [[:NERDTreeToggle<CR>]], nopts)
-- nkeyset("n", "<C-n>", [[:NERDTree<CR>]], nopts)
-- nkeyset("n", "<C-f>", [[:NERDTreeFind<CR>]], nopts)


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

