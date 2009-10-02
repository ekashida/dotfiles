syntax enable

set encoding=utf-8

set ruler                       " Displays column and row number.
set nowrap                      " Prevents lines from wrapping.
set paste                       " Pastes using intended indentation.

set smarttab                    " Treats tab and backspace as shiftwidth columns when indenting/dedenting.
set shiftround                  " Indents to a multiple of shiftwidth.
set shiftwidth=4                " Defines the number of columns in an indent.

set expandtab                   " Expands inserted tabs into tabstop columns.
set tabstop=4                   " Defines the number of columns in a tab.

set ignorecase                  " Ignores case in search patterns.
set smartcase                   " Overrides ignorecase option when pattern contains upper-case letters.
set incsearch                   " Jumps to the first occurance of a match in real time.
set hlsearch                    " Highlights the match.

set list                        " Displays whitespace characters.
set listchars=tab:>-,trail:$    " Defines how to display whitespace characters.
"set virtualedit=all             " Allows traversal of non-existant areas.

imap jj <Esc>

nmap ,s :source ~/.vimrc<Return>
nmap ,v :e ~/.vimrc<Return>

nmap ,2 :set shiftwidth=2<Return>
nmap ,4 :set shiftwidth=4<Return>
