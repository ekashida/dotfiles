syntax enable                   " Switches on syntax highlighting

set encoding=utf-8
set noswapfile                  " Cowboy mode

set ruler                       " Display column and row number
set nowrap                      " Prevent lines from wrapping
set scrolloff=5                 " Lookahead while scrolling
set nojoinspaces                " Prevent two spaces after [.?!] when joining lines
"set paste                       " Paste using intended indentation

set smarttab                    " Treat tab and backspace as shiftwidth columns when indenting/dedenting
set shiftround                  " Indent to a multiple of shiftwidth
set shiftwidth=4                " Define the number of columns in an indent

set expandtab                   " Expand inserted tabs into tabstop columns
set tabstop=4                   " Define the number of columns in a tab character

set ignorecase                  " Ignore case in search patterns
set smartcase                   " Override ignorecase option when pattern contains upper-case letters
set incsearch                   " Jump to the first occurance of a match in real time
set hlsearch                    " Highlight the match

set list                        " Display whitespace characters
set listchars=tab:>-,trail:$    " Define how to display whitespace characters
set wildmode=list:longest       " Autocompletion for filenames; complete till longest common substring
set background=dark             " Syntax coloring scheme for dark backgrounds
"set virtualedit=all             " Allow traversal of non-existant areas

" Navigate the displayed lines for wrapped lines
nmap j gj
nmap k gk

" Toggle paste.
nmap ,,p :set paste!<CR>

" Toggle wrapping.
nmap ,,w :set wrap!<CR>

" Source the .vimrc (only useful from within .vimrc)
nmap ,,s :source ~/.vimrc<CR>

nmap ,,n :NERDTree<CR>
nmap ,,m :MRU<CR>

" Quit all windows
nmap ,,q :q<CR>:q<CR>:q<CR>:q<CR>

nmap ,2 :set shiftwidth=2<CR>
nmap ,4 :set shiftwidth=4<CR>

" Remove trailng spaces
nmap ,s :%s/\s\+$//g<CR>

" Convert tabs into spaces
nmap ,t :%retab!<CR>

" Remove underlines from anchor tag link text
hi def linkBlue ctermfg=DarkBlue
hi def link htmlLink linkBlue
