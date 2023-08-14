" VIM configuration file
"
set nocompatible
call pathogen#infect()
call pathogen#helptags()

"let g:airline_theme='monokai_tasty'
"let g:airline_theme='base16_gruvbox_dark_pale'
"let g:vim_monokai_tasty_italic = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1

"" Go
let g:go_auto_type_info = 1
" disable all linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []
" don't jump to errors after metalinter is invoked
let g:go_jump_to_error = 0
" run go imports on file save
let g:go_fmt_command = "gofumpt"
" Others
let g:go_auto_sameids = 0
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_fmt_experimental=1

" rust
let g:rustfmt_autosave = 1

" Theme
colorscheme nord
" autocmd ColorScheme * highlight CocErrorFloat guifg=#ffffff
" autocmd ColorScheme * highlight CocInfoFloat guifg=#ffffff
" autocmd ColorScheme * highlight CocWarningFloat guifg=#ffffff
" autocmd ColorScheme * highlight SignColumn guibg=#adadad


" Status line options from https://github.com/tpope/vim-flagship
set laststatus=2
set showtabline=2
set guioptions-=e
set hidden
set encoding=utf-8
set cmdheight=1
set updatetime=300
set shortmess+=c
set signcolumn=number
set foldmethod=syntax
set foldnestmax=1
set nofoldenable
let mapleader = ","

" https://jameschambers.co.uk/vim-typescript-slow
set re=0

" Show line numbers by default
set number
map <leader>n :set number!<CR>

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Other
nmap sn :new<CR>
nmap se :edit<SPACE>
nmap sb :Buffers<CR>
nmap sf :Files<CR>
nmap sr :Rg \b<C-R><C-W>\b
nmap <C-p> :bp<CR>
nmap <C-n> :bn<CR>
nmap <C-g> :b#<CR>
nmap Q :bd!<CR>
nnoremap <Leader>g :e#<CR>

autocmd FileType go nmap gD :GoDecls<CR>
autocmd FileType go nmap gR :GoReferrers<CR>
autocmd FileType go nmap gDD :GoDeclsDir<CR>
autocmd FileType go nmap <Leader>i <Plug>(go-info)


" Mappings to access buffers (don't use "\p" because a
" delay before pressing "p" would accidentally paste).
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
" nnoremap <Leader>1 :1b<CR>
" nnoremap <Leader>2 :2b<CR>
" nnoremap <Leader>3 :3b<CR>
" nnoremap <Leader>4 :4b<CR>
" nnoremap <Leader>5 :5b<CR>
" nnoremap <Leader>6 :6b<CR>
" nnoremap <Leader>7 :7b<CR>
" nnoremap <Leader>8 :8b<CR>
" nnoremap <Leader>9 :9b<CR>
" nnoremap <Leader>0 :10b<CR>

" Mirror the NERDTree before showing it. This makes it the same on all tabs.
nnoremap <C-e> :NERDTreeMirror<CR>:NERDTreeFocus<CR>
" Start NERDTree when Vim is started without file arguments or first arg is a
" directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
