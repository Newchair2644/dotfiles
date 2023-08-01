let s:matches=".fa-lg .fa-2x .fa-3x .fa-4x .fa-5x .fa-fw .fa-ul .fa-ul .fa-li .fa-li.fa-lg .fa-border .fa-pull-left .fa-pull-right .fa.fa-pull-left"

function! csscomplete#CompleteFA(findstart, base)
	if a:findstart
		" locate the start of the word
		let line = getline('.')
		let start = col('.') - 1
		while start > 0 && (line[start - 1] =~ '\a' || line[start - 1] =~ '.' || line[start - 1] =~ '-')
			let start -= 1
		endwhile
		return start
	else
		" find classes matching "a:base"
		let res = []
		for m in split(s:matches)
			if m =~ '^' . a:base
				call add(res, m)
			endif
		endfor
		return res
	endif
endfun
