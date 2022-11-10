"Use vim settings rather than vi settings
set nocompatible

set backspace=indent,eol,start  " make backspace behave in sane manner
set history=50                  " keep 50 lines of command line history
set showcmd                     " display incomplete commands
set noerrorbells	            " no sound
set visualbell t_vb=            " no sound
set autoread                    " read open files again when changed outside Vi
set hidden                      " buffers can exist in background
set hlsearch                    " highlight the last used search pattern
set incsearch                   " do incremental searching
set ignorecase                  " ignore case when searching
set smartcase                   " unless we type a capital
set number                      " display current line number
set relativenumber				" display line numbers relative to cursor

set shiftwidth=4                " number of spaces to use for each step of indent
set tabstop=4                   " number of spaces that a <Tab> counts for
set softtabstop=4				" number of spaces to use for each <Tab> in insert
set expandtab                   " expand tabs to spaces
set autoindent                  " copy indent from current line
set smartindent                 " smart autoindenting when starting a new line
" fix comment indentation with smartindent
inoremap # X#

syntax on                       " turn on syntax highlighting
filetype plugin indent on

" Unbind some useless/annoying default key bindings.
" 'Q' in normal mode enters Ex mode. You almost never want this.
nmap Q <Nop>

" Enable folding
"set foldmethod=indent
"set foldlevel=99
" Enable folding with spacebar
"nnoremap <space> za

"let python_highlight_all=1


set viminfo='20,\"50

if has("autocmd")
    augroup redhat
    autocmd!
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line ("'\"") <= line("$") |
                \   exe "normal! g'\"" |
                \ endif
endif

set statusline=%F      " Path
set statusline+=%=     " right-side align
set statusline+=%l     " current line
set statusline+=/%L    " of total lines
set statusline+=\ :\   " seperator
set statusline+=%c     " column
set laststatus=2  	   " display statusline always

"Delete trailing white space on save and maintain cursor position
function! StripTrailingWhiteSpace()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l,c)
endfun

autocmd BufWritePre * :call StripTrailingWhiteSpace()
