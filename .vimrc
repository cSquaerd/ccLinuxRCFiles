set nocompatible
syntax on

filetype plugin indent on

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

set ttymouse=sgr
set mouse=a
set textwidth=120
set noautoindent
set formatoptions=cqrn1
set wrap
set noexpandtab
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
set guifont=Cascadia\ Code\ PL\ Medium\ 16
" colorscheme fruity
colorscheme default
hi conditional ctermfg=cyan    cterm=bold
hi repeat      ctermfg=cyan    cterm=bold
hi identifier  ctermfg=white
hi function    ctermfg=white   cterm=bold
hi statement   ctermfg=magenta
hi operator    ctermfg=red
hi preproc     ctermfg=cyan
hi type        ctermfg=green
hi comment     ctermfg=gray
hi string      ctermfg=yellow
hi number      ctermfg=33
hi boolean     ctermfg=33
hi special     ctermfg=208
hi normal      guifg=white   guibg=black
hi conditional guifg=cyan    gui=bold
hi repeat      guifg=cyan    gui=bold
hi identifier  guifg=white
hi function    guifg=white   gui=bold
hi statement   guifg=magenta
hi operator    guifg=red
hi preproc     guifg=cyan
hi type        guifg=green
hi comment     guifg=gray
hi string      guifg=yellow
hi number      guifg=lightblue
hi boolean     guifg=lightblue
hi special     guifg=orange
let g:powerline_pycmd="py3"
let g:Tex_DefaultTargetFormat="pdf"
" let g:Tex_CompileRule_pdf="pdflatex --interaction=nonstopmode $*"
let g:Tex_FoldedSections=""
let g:Tex_FoldedEnvironments=""
let g:Tex_FoldedMisc=""
autocmd BufWritePost *.tex silent! execute "!pdflatex --interaction=nonstopmode %" | redraw!
autocmd FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab
set viminfo='255,<9999,s255
