if exists('g:loaded_github_url')
    finish
endif
let g:loaded_github_url = 1

if !exists('g:github_url#yank_command')
    let g:github_url#yank_command = 'normal yy'
endif

nnoremap <silent><Plug>(github_url-file) :call github_url#file()<CR>
vnoremap <silent><Plug>(github_url-line) :call github_url#line()<CR>
