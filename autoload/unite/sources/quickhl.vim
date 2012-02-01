let s:source = {
      \ 'name': 'quickhl',
      \ 'action_table': {},
      \}

function! unite#sources#quickhl#define()
  return s:source
endfunction

function! s:source.gather_candidates(args, context)
  silent! redir => list
  silent! call quickhl#list()
  silent! redir END

  let res = []
  let keywords = filter(
        \ map(split(list, "\n"), 'matchstr(v:val, ''\s\d:\s\zs.*$'')'), '!empty(v:val)')

  for keyword in keywords
    call add(res, {
          \ 'word': keyword,
          \ 'kind': 'common',
          \ 'source': 'quickhl',
          \})
  endfor

  return res
endfunction

"action
let s:action_table = {}
let s:action_table.delete = {
      \ 'description': 'delete keyword of quickhl'
      \}

function! s:action_table.delete.func(candidate)

  silent! redir => error
  silent! call quickhl#del(a:candidate.word, 0)
  silent! redir END

  if error =~ 'quickhl:  pattern not found:'
    call quickhl#del(a:candidate.word, 1)
  endif

endfunction

let s:source.action_table.common = s:action_table

