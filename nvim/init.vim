set background=dark             " Syntax coloring scheme for dark backgrounds
set colorcolumn=79              " Visual width indicator (7.3+)
set expandtab                   " Expand inserted tabs into tabstop columns
set ignorecase                  " Ignore case in search patterns
set list                        " Display whitespace characters
set listchars=tab:>-,trail:$    " Display whitespace characters
set nojoinspaces                " Prevent two spaces after [.?!] when joining lines
set noswapfile                  " Cowboy mode!
set nowrap                      " Prevent lines from wrapping
set scrolloff=5                 " Lookahead while scrolling
set smartcase                   " Override ignorecase option when pattern contains upper-case letters


let mapleader = ","

" Source the vim config
nmap <leader><leader>u :source ~/.config/nvim/init.vim<cr>

" Quit all windows
nmap <leader><leader>q :q<cr>:q<cr>:q<cr>:q<cr>

" Toggle nerdtree
nmap <leader>n :NERDTreeToggle<cr>

" Toggle relativenumber.
nmap <leader><leader>r :set relativenumber!<cr>

" Clear search highlighting
nnoremap <leader><space> :noh<cr>

" Toggle wrap.
nmap <leader><leader>w :set wrap!<cr>

" Remove trailng spaces
nmap <leader>s :%s/\s\+$//g<cr>

" Convert tabs into spaces
nmap <leader>t :%retab!<cr>


au BufRead,BufNewFile *.jsx setfiletype javascript
au BufRead,BufNewFile *.cmp setfiletype xml
au BufRead,BufNewFile *.app setfiletype xml


call plug#begin()
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
call plug#end()


" ctrlp settings
let g:ctrlp_user_command = 'ag %s --nocolor -g ""'  " ctrlp_show_hidden, ctrlp_custom_ignore, and wildignore are not used when ctrlp_user_command is defined; use .agignore instead
