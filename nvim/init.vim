set colorcolumn=79              " Visual width indicator (7.3+)
set expandtab                   " Expand inserted tabs into tabstop columns
set ignorecase                  " Ignore case in search patterns
set list                        " Display whitespace characters
set listchars=tab:>-,trail:$    " Display whitespace characters
set mouse-=a                    " Prevent neovim from screwing with my mouse
set nojoinspaces                " Prevent two spaces after [.?!] when joining lines
set noswapfile                  " Cowboy mode!
set nowrap                      " Prevent lines from wrapping
set relativenumber              " Show relative line numbers
set scrolloff=5                 " Lookahead while scrolling
set smartcase                   " Override ignorecase option when pattern contains upper-case letters


let mapleader = ","

" Source the vim config
nmap <leader><leader>u :source ~/.config/nvim/init.vim<cr>

" Quit all windows
nmap <leader><leader>q :qall

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
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'junegunn/seoul256.vim'
Plug 'scrooloose/nerdtree', {'on':  'NERDTreeToggle'}
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'vim-airline/vim-airline'
call plug#end()


" ctrlp settings
let g:ctrlp_user_command = 'ag %s --nocolor -g ""'  " ctrlp_show_hidden, ctrlp_custom_ignore, and wildignore are not used when ctrlp_user_command is defined; use .agignore instead

" syntastic settings
let g:airline#extensions#syntastic#enabled = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exec = "node_modules/.bin/eslint" " Use the local eslint install since global eslint does not look at local eslint configs
let g:syntastic_json_checkers = ['jsonlint']
"let g:syntastic_debug = 1

" seoul256 settings
"let g:seoul256_background = 235 " 233 (darkest) <-> 256 (lightest)
"colo seoul256

" tomorrow-theme settings
"colorscheme tomorrow-night
colorscheme tomorrow-night-eighties
