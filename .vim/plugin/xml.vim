""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" www.vim.org/scripts/script.php?script_id=301
" $ADDED/xml.vim
" www.vim.org/scripts/script.php?script_id=39
" copied macros/matchit.vim to plugin/
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" XML
let g:xml_syntax_folding = 1
let $ADDED = '~/.vim/added/'
map <Leader>x
  \:set filetype=xml<CR>
  \:source $VIMRUNTIME/syntax/xml.vim<CR>
  \:set foldmethod=syntax<CR>
  \:source $VIMRUNTIME/syntax/syntax.vim<CR>
  \:source $ADDED/xml.vim<CR>
  \:set shiftwidth=2<CR>
  \:echo "XML mode is on"<CR>
" nmap <Leader>i :%!xsltproc /home/dan/.vim/added/indent.xsl -<CR>
nmap <Leader>i :%!xmllint --format -<CR>
