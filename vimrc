let mapleader = ","

" Allow pathogen.vim to also exist in a private directory
runtime bundle/vim-pathogen/autoload/pathogen.vim

" Initialize pathogen.vim
execute pathogen#infect()

" Switches on syntax highlighting
syntax enable

" Color settings
highlight LineNr ctermfg=DarkGrey

set encoding=utf-8
set noswapfile                  " Cowboy mode!

set ruler                       " Display column and row number
set nowrap                      " Prevent lines from wrapping
"set textwidth=79                " Wrap width

if exists('+colorcolumn')
set colorcolumn=79              " Visual width indicator (7.3+)
endif

set scrolloff=5                 " Lookahead while scrolling
set nojoinspaces                " Prevent two spaces after [.?!] when joining lines

set smarttab                    " Treat tab and backspace as shiftwidth columns when indenting/dedenting
set shiftround                  " Indent to a multiple of shiftwidth
set shiftwidth=2                " Number of columns in an indent

set expandtab                   " Expand inserted tabs into tabstop columns
set tabstop=2                   " Number of columns in a tab character

set ignorecase                  " Ignore case in search patterns
set smartcase                   " Override ignorecase option when pattern contains upper-case letters
set incsearch                   " Jump to the first occurance of a match in real time
set hlsearch                    " Highlight the match

set list                        " Display whitespace characters
set listchars=tab:>-,trail:$    " Display whitespace characters
set wildmode=list:longest       " Autocompletion for filenames; complete till longest common substring
set background=dark             " Syntax coloring scheme for dark backgrounds

"set paste                       " Paste using intended indentation
"set virtualedit=all             " Allow traversal of non-existant areas
"set relativenumber              " Number column displays distance from the cursor
"set undofile                    " Persistent undo
"set undodir=/tmp                " Undo metadata directory

" Clear hlsearch highlighting
nnoremap <leader><space> :noh<cr>

" Navigate the displayed lines for wrapped lines
nmap j gj
nmap k gk

" Toggle paste.
nmap <leader><leader>p :set paste!<cr>

" Toggle wrap.
nmap <leader><leader>w :set wrap!<cr>

" Toggle relativenumber.
nmap <leader><leader>r :set relativenumber!<cr>

" Source the .vimrc
nmap <leader><leader>s :source ~/.vimrc<cr>

nmap <leader>n :NERDTree<cr>
nmap <leader>m :CtrlPMRU<cr>
nmap <leader>f :CtrlP<cr>

" Quit all windows
nmap <leader><leader>q :q<cr>:q<cr>:q<cr>:q<cr>

" Remove trailng spaces
nmap <leader>s :%s/\s\+$//g<cr>

" Convert tabs into spaces
nmap <leader>t :%retab!<cr>

" Remove underlines from anchor tag link text
hi def linkBlue ctermfg=DarkBlue
hi def link htmlLink linkBlue

" associate *.jsx with javascript filetype
au BufRead,BufNewFile *.jsx setfiletype javascript


" https://github.com/scrooloose/syntastic#3-recommended-settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_javascript_checkers = ['eslint']

