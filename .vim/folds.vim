"------------------------------------------------------------
" Toggle fold state between closed and opened.
" If there is no fold at current line, just moves forward.
" If it is present, reverse it's state.
fun! ToggleFold()
    if foldlevel('.') == 0
        normal! l
    else
        if foldclosed('.') < 0
            . foldclose
        else
            . foldopen
        endif
    endif
    " Clear status line
    echo 
endfun
noremap <space> :call ToggleFold()<CR>
"Open fold
nnoremap + zo
"Close fold
nnoremap - zc
"Fold method: Indent
map <silent> ,fi :silent set foldmethod=indent<CR>zR
"Fold method: manual
map <silent> ,fm :silent set foldmethod=manual<CR>
"Colors
highlight Folded ctermfg=darkmagenta
