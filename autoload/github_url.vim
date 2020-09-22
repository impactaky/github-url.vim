function! s:gen_url()
    let file_dir = expand('%:h')
    let cands = systemlist('git -C '.file_dir.' for-each-ref --points-at=HEAD --format="%(refname)"')
    let remote = ''
    for cand in cands
        let matcher = matchlist(cand, 'refs/remotes/\(.\{-}\)/.\+')
        if !empty(matcher)
            if matcher[1] == 'origin' || remote == ''
                let remote = matcher[1]
            endif
        endif
    endfor

    if remote != ''
        let tmp = systemlist('git -C '.file_dir.' config --get remote.'.remote.'.url')
        if !v:shell_error
            let url = tmp[0]
            let matcher = matchlist(url, 'git@\(.\+\):\(.\+\).git')
            if !empty(matcher)
                let url = 'https://'.matcher[1].'/'.matcher[2]
            endif
        endif
    endif
    if !exists('url')
        echomsg 'HEAD has no remote'
        return -1
    endif

    let hash = systemlist('git -C '.file_dir.' rev-parse HEAD')[0]
    let dir = substitute(system('git -C '.file_dir.' rev-parse --show-prefix'), '\n', '', 'g')
    return url.'/tree/'.hash.'/'.dir.expand('%:t')
endfunction

function! s:yank(text)
    let s:github_url_scratch = bufnr("github_url_work", 1)
    call setbufvar(s:github_url_scratch, "&buftype", "nofile")
    let curbuf = bufnr("")
    silent! execute s:github_url_scratch . "buffer"
    let failed = setline(line('$'), a:text)
    execute("silent normal V:call OscYank()\<CR>")
    silent! execute curbuf . "buffer"
endfunction

function! github_url#file()
    let url = s:gen_url()
    if url == -1
        return url
    endif
    echo url
    call s:yank(url)
endfunction

function! github_url#line() range
    let url = s:gen_url()
    if url == -1
        return url
    endif
    let url = printf("%s#L%d-L%d", url, a:firstline, a:lastline)
    echo url
    call s:yank(url)
endfunction

