"""""""  Python

" Avoid removing indent of python comment lines by smartindent
inoremap # X#

syntax sync fromstart

" "
" Tips from http://blog.sontek.net/2008/05/11/python-with-a-modular-ide-vim/

" if has("python")
"     python << EOF
" import os, sys, vim
" for p in sys.path:
"     if os.path.isdir(p):
"         vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
" EOF
" endif

set tags+=$HOME/.vim/tags/python.ctags
map <silent><C-Left> <C-T>
map <silent><C-Right> <C-]>

" Ctrl-space displays menu
inoremap <Nul> <C-x><C-o>

