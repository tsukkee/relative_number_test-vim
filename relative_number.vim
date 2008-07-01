" include guard
if exists('loaded_mark_vim')
    finish
endif
let loaded_mark_vim = 1

" options
if !exists('g:relative_range')
    let g:relative_range = 20
endif

" generate sign id
let s:base_number = 500
function! s:id(num)
    return s:base_number + a:num + 1
endfunction

" generate sign line
function! s:line(num)
    return a:num - g:relative_range + line('.')
endfunction

" generate sign text
function! s:number(num)
    let temp = a:num - g:relative_range
    return (temp > 0) ? temp : - temp
endfunction

" add signs
function! s:AddMarks()
    for num in range(0, g:relative_range * 2)
        exe "sign place " . s:id(num) . " line=" . s:line(num) . " name=" . s:prefix . num . " buffer=" . winbufnr(0)
    endfor
    exe "sign place " . s:base_number . " line=1 name=" . s:prefix . "00 buffer=" . winbufnr(0)
endfunction

" remove signs
function! s:RemoveMarks()
    for num in range(0, g:relative_range * 2)
        exe "sign unplace " . s:id(num)
    endfor
endfunction

" auto add relative number
let s:last_line = 1
let s:enabled = 1
function! s:AutoAddRemove()
    if s:last_line != line('.') && s:enabled
        let lazy = &lazyredraw
        let &lazyredraw = 1
        call s:RemoveMarks()
        call s:AddMarks()

        if !lazy
            let &lazyredraw = 0
        endif
    endif

    let s:last_line = line('.')
endfun

" initialize
let s:prefix = "RelativeNumber_"
let s:marks = []
for num in range(0, g:relative_range * 2)
    call add(s:marks, s:prefix . num)
    exe "sign define " . s:prefix . num . " text=" . s:number(num)
endfor
exe "sign define " . s:prefix . "00 text=00"

" define commands
command! RelativeNumberEnable  let s:enabled = 1
command! RelativeNumberDisable let s:enabled = 0

" for debug
" command! RelativeNumberAuto   call s:AutoAddRemove()


" define autocmd
autocmd CursorMoved,CursorMovedI * call s:AutoAddRemove()
