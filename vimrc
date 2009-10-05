syntax enable

set encoding=utf-8

set ruler                       " Displays column and row number.
set nowrap                      " Prevents lines from wrapping.
"set paste                       " Pastes using intended indentation.

set smarttab                    " Treats tab and backspace as shiftwidth columns when indenting/dedenting.
set shiftround                  " Indents to a multiple of shiftwidth.
set shiftwidth=4                " Defines the number of columns in an indent.

set expandtab                   " Expands inserted tabs into tabstop columns.
set tabstop=4                   " Defines the number of columns in a tab character.

set ignorecase                  " Ignores case in search patterns.
set smartcase                   " Overrides ignorecase option when pattern contains upper-case letters.
set incsearch                   " Jumps to the first occurance of a match in real time.
set hlsearch                    " Highlights the match.

set list                        " Displays whitespace characters.
set listchars=tab:>-,trail:$    " Defines how to display whitespace characters.
set wildmode=list:longest       " Autocompletion for filenames; complete till longest common substring.
"set virtualedit=all             " Allows traversal of non-existant areas.

nmap ,,s :source ~/.vimrc<CR>
nmap ,,v :e ~/.vimrc<CR>
nmap ,,n :NERDTree<CR>

nmap ,2 :set shiftwidth=2<CR>
nmap ,4 :set shiftwidth=4<CR>

" Remove trailng spaces.
nmap ,s :%s/\s\+$//g<CR>

" Convert tabs into spaces.
nmap ,t :%retab!<CR>

" Navigate buffers using up/down arrows.
nmap <UP>   :tabp<CR>
nmap <DOWN> :tabn<CR>

" The trailing space is required.
iab ahtml 
\<CR><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
\<CR><html lang="en-US">
\<CR><head>
\<CR><title></title>
\<CR></head>
\<CR>
\<CR><body>
\<CR></body>
\<CR></html>

iab alink <link rel="stylesheet" type="text/css" href="" />
iab ascript <script type="text/javascript" src=""></script>
