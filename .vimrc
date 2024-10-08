" size of a hard tabstop
set tabstop=4

" size of an 'indent'
set shiftwidth=4

" a combination of spaces and tabs are used to simulate tab stops at a width
" other than the (hard)tabstop
set softtabstop=4

" make 'tab' insert indents instead of tabs at the beginning of a line
set smarttab

" always uses spaces instead of tab characters
set expandtab

" max number of tabs
set tabpagemax=100

" syntax coloring
colo slate
syntax on

set autoindent
set mouse=a
set number

if !has('clipboard')
    echo "no clipboard!"
endif

" yank to system clipboard
let uname = substitute(system('uname -s'), '\n', '', '')
if uname == "Darwin"
    set clipboard=unnamed
elseif uname == "Linux"
    set clipboard=unnamedplus
endif

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" scrolling will turn off when 8 characters from the top or bottom
set scrolloff=8

:imap jk <Esc>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Visual Indenting
vmap < <gv
vmap > >gv

