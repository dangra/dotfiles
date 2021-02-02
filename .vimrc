" VIM configuration file
"
set nocompatible
call pathogen#infect()
call pathogen#helptags()

let g:airline_theme='monokai_tasty'
let g:vim_monokai_tasty_italic = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
colorscheme vim-monokai-tasty

" Status line options from https://github.com/tpope/vim-flagship
set laststatus=2
set showtabline=2
set guioptions-=e

" Toggle line numbers
map <leader>n :set number!<CR>

" Tabbed windows
nmap sn :tabnew<CR>
nmap se :tabedit<SPACE>
