set nocompatible
syntax on

filetype plugin indent on

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

set mouse=a
set textwidth=80
set noautoindent
set formatoptions=cqrn1
set wrap
set tabstop=4
set shiftwidth=4
set scrolloff=6
set backspace=indent,eol,start
set ttyfast
set laststatus=2
set showmode
set showcmd
set matchpairs=(:),[:],{:},<:>
set number
set encoding=utf-8
set hlsearch
set incsearch
set ignorecase
set smartcase
set whichwrap+=<,>,[,]
set guifont=IBM\ 3270\ Medium\ 16
colorscheme fruity
let g:powerline_pycmd="py3"
let g:Tex_DefaultTargetFormat="pdf"
" let g:Tex_CompileRule_pdf="pdflatex --interaction=nonstopmode $*"
let g:Tex_FoldedSections=""
let g:Tex_FoldedEnvironments=""
let g:Tex_FoldedMisc=""
autocmd BufWritePost *.tex silent! execute "!pdflatex --interaction=nonstopmode %" | redraw!
autocmd FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
set viminfo='255,<9999,s255
