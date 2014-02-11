" VIM configuration file
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on

let mapleader = ","     " map leader
set showtabline=2       " always show tabline
set modelines=5
set nocompatible        " Use Vim defaults instead of 100% vi compatibility
set number             " Show line numbers
set textwidth=0         " Wrap words by default
set viminfo='20,\"50    " Read/write a .viminfo file, don't store more than 50 lines of registers
set history=50          " Keep 50 lines of command line history
set ruler               " Show the cursor position all the time
set showmode            " Show which mode are we in
set showcmd             " Show (partial) command in status line.
set noignorecase        " Do case insensitive matching
set incsearch           " Incremental search
set hlsearch            " Highlight search matches
set noautowrite         " Automatically save before commands like :next and :make
set showmatch           " Show matching brackets.
set backupdir=~/tmp,/tmp  " Group backup files on this directories
set directory=.,~/tmp,/tmp  " Group swap files on this directories
set cpt=.,k,d
set smarttab            " <BS> deletes a tab not only a space
set shiftwidth=4        " Number of space characters inserted for indentation
set expandtab           " Insert space characters whenever the tab key is pressed
set tabstop=4           " Number of space characters that will be inserted when tab is pressed
set autoindent          " Always set autoindenting on
set backspace=indent,eol,start " more powerful backspacing
set smartindent         " Always set autoindenting on
set scrolloff=3         " Maintain more context around the cursor
set guioptions=         " Disable toolbar, scrollbars, statuslines, etc for gvim
set guifont=Monospace\ 9
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" Lower priority suffixes for tab completion
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,$py.class

if version >= 703
    set colorcolumn=100
    set cryptmethod=blowfish
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Theme
set t_Co=16
"set background=dark
"colorscheme molokai
set background=light
colorscheme solarized
call togglebg#map("<F5>")
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spell checker
nmap <leader>spes :set spell spelllang=es<CR>
nmap <leader>spen :set spell spelllang=en<CR>
nmap <leader>sp0 :setlocal nospell<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" misc
let g:closetag_html_style=1
let g:python_highlight_all=1
let g:gist_detect_filetype = 1
"' jumps to the precise location of a marks (`)
map ' `
"rewrap entire paragraph
map Q vapgq
"comment (#)
vmap <silent> sc :s/^/# /<CR>:silent noh<CR>
"uncomment (#)
vmap <silent> su :s/^# \(.*\)/\1/<CR>:silent noh<CR>
"Line numbers ON/OFF
map <leader>n :set number!<CR>
"Read and write one block of text between vim sessions
nmap <leader>r   :r $HOME/.vimxfer<CR>
vmap <leader>w   :w! $HOME/.vimxfer<CR>
nmap <silent> <leader><leader> :silent noh<CR>
" highlight tabs and trailing whitespaces
set list
set listchars=tab:\ \ ,trail:\  " Do not remove trailing whitespace on this line
" Remove trailing spaces and tabs, and replace tabs with 4 spaces
nmap sT :%s/\s\+$//<CR>
nmap s4 :%s/\t/    /g<CR>
" pylint
map <leader>y :!python -m pylint.lint %<CR>
" hg
map <leader>au :!hg annotate -nu % \| less<CR>
map <leader>hd :!hg cat % \| vimdiff - -R -c ':vnew % \|windo diffthis'<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab Completion
function! SuperTab()
    if (strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
        return "\<Tab>"
    else
        return "\<C-n>"
    endif
endfunction
imap <Tab> <C-R>=SuperTab()<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM < 700 => downgrade and stop vimrc execution
if version < 700
    source ~/.vim/nocoolrc
    finish
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabbed windows
nmap sn :tabnew<CR>
nmap se :tabedit<SPACE>
" This is an attempt to emulate the default Vim-7 tabs as closely as possible but with numbered tabs.
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        for i in range(tabpagenr('$'))
            " set up some oft-used variables
            let tab = i + 1 " range() starts at 0
            let winnr = tabpagewinnr(tab) " gets current window of current tab
            let buflist = tabpagebuflist(tab) " list of buffers associated with the windows in the current tab
            let bufnr = buflist[winnr - 1] " current buffer number
            let bufname = bufname(bufnr) " gets the name of the current buffer in the current window of the current tab

            let s .= '%' . tab . 'T' " start a tab
            let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#') " if this tab is the current tab...set the right highlighting
            let s .= ' ' . tab " current tab number
            let n = tabpagewinnr(tab,'$') " get the number of windows in the current tab
            if n > 1
                let s .= ':' . n " if there's more than one, add a colon and display the count
            endif
            let bufmodified = getbufvar(bufnr, "&mod")
            if bufmodified
                let s .= ' +'
            endif
            if bufname != ''
                let s .= ' ' . pathshorten(bufname) . ' ' " outputs the one-letter-path shorthand & filename
            else
                let s .= ' [No Name] '
            endif
        endfor
        let s .= '%#TabLineFill#' " blank highlighting between the tabs and the righthand close 'X'
        let s .= '%T' " resets tab page number?
        let s .= '%=' " seperate left-aligned from right-aligned
        let s .= '%#TabLine#' " set highlight for the 'X' below
        let s .= '%999XX' " places an 'X' at the far-right
        return s
    endfunction
    set tabline=%!MyTabLine()
    map <leader>1 1gt
    map <leader>2 2gt
    map <leader>3 3gt
    map <leader>4 4gt
    map <leader>5 5gt
    map <leader>6 6gt
    map <leader>7 7gt
    map <leader>8 8gt
    map <leader>9 9gt
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File type detection
if has("autocmd")
    au BufRead,BufNewFile .followup,.article,.letter,/tmp/pico*,nn.*,snd.*,/tmp/mutt* :set ft=mail 
    "au FileType python     setlocal omnifunc=pythoncomplete#Complete
    au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    au FileType html       setlocal omnifunc=htmlcomplete#CompleteTags
    au FileType css        setlocal omnifunc=csscomplete#CompleteCSS
    au FileType xml        setlocal omnifunc=xmlcomplete#CompleteTags
    au FileType c          setlocal omnifunc=ccomplete#Complete
    au FileType go         setlocal nolist tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
    au FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    au FileType xhtml,html,htmldjango,mxml,xml,java setlocal tabstop=2 shiftwidth=2 expandtab
    au FileType sh setlocal tabstop=2 shiftwidth=2 expandtab list
    au FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab list
    au FileType javascript,css,actionscript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
    au Filetype html,xml,xsl source ~/.vim/scripts/closetag.vim
    au BufRead,BufNewFile *.tac set filetype=python
    au BufRead,BufNewFile *.pig set filetype=pig
    au BufRead,BufNewFile *.jinja set filetype=jinja
    au BufRead,BufNewFile *.md,*.mkd set filetype=mkd
    au BufRead *.md,*.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
    au BufReadCmd   *.egg		call zip#Browse(expand("<amatch>"))
endif
