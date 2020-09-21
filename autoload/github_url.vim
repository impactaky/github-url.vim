function! github_url#line()
    let branch = systemlist("git symbolic-ref --short HEAD")[0]
    let matcher = matchlist(branch, 'remotes/\(.\+\)/\(.\+\)')
    if !empty(matcher)
        let remote = matcher[1]
        let branch = matcher[2]
    else
        let remote = systemlist("git config --get branch.".branch.".remote")
        if v:shell_error
        else
            remote = remote[0]
        endif
    endif

    let url = systemlist("git config --get remote.".remote.".url")[0]
    let matcher = matchlist(url, 'git@\(.\+\):\(.\+\).git')
    if !empty(matcher)
        " L6-8
        let url = "https://".matcher[1]."/".matcher[2]
    endif

    echo url."/tree/".branch
endfunction
