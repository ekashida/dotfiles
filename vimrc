let mapleader = ","

" Allow pathogen.vim to also exist in a private directory
runtime bundle/vim-pathogen/autoload/pathogen.vim

" Initialize pathogen.vim
execute pathogen#infect()

" Required for jslint.vim
filetype plugin on

" Switches on syntax highlighting
syntax enable

set encoding=utf-8
set noswapfile                  " Cowboy mode!

set ruler                       " Display column and row number
set nowrap                      " Prevent lines from wrapping
set scrolloff=5                 " Lookahead while scrolling
set nojoinspaces                " Prevent two spaces after [.?!] when joining lines
"set paste                       " Paste using intended indentation

set smarttab                    " Treat tab and backspace as shiftwidth columns when indenting/dedenting
set shiftround                  " Indent to a multiple of shiftwidth
set shiftwidth=4                " Number of columns in an indent

set expandtab                   " Expand inserted tabs into tabstop columns
set tabstop=4                   " Number of columns in a tab character

set ignorecase                  " Ignore case in search patterns
set smartcase                   " Override ignorecase option when pattern contains upper-case letters
set incsearch                   " Jump to the first occurance of a match in real time
set hlsearch                    " Highlight the match

set list                        " Display whitespace characters
set listchars=tab:>-,trail:$    " Display whitespace characters
set wildmode=list:longest       " Autocompletion for filenames; complete till longest common substring
set background=dark             " Syntax coloring scheme for dark backgrounds
"set virtualedit=all             " Allow traversal of non-existant areas

set relativenumber              " Number column displays distance from the cursor

set undofile                    " Persistent undo
set undodir=/tmp                " Undo metadata directory


" Navigate the displayed lines for wrapped lines
nmap j gj
nmap k gk

" Toggle paste.
nmap <leader><leader>p :set paste!<CR>

" Toggle wrapping.
nmap <leader><leader>w :set wrap!<CR>

" Source the .vimrc (only useful from within .vimrc)
nmap <leader><leader>s :source ~/.vimrc<CR>

nmap <leader><leader>n :NERDTree<CR>
nmap <leader><leader>m :MRU<CR>

" Quit all windows
nmap <leader><leader>q :q<CR>:q<CR>:q<CR>:q<CR>

" Remove trailng spaces
nmap <leader>s :%s/\s\+$//g<CR>

" Convert tabs into spaces
nmap <leader>t :%retab!<CR>

" Remove underlines from anchor tag link text
hi def linkBlue ctermfg=DarkBlue
hi def link htmlLink linkBlue
