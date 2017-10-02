"���������ʸ��ñ�̰�ư
inoremap <silent> <C-s> <Left>
inoremap <silent> <C-d> <Right>

"ñ��ñ�̰�ư
inoremap <silent> <C-f> <C-r>=MyMoveWord_i('w')<CR>
inoremap <silent> <C-b> <C-r>=MyMoveWord_i('b')<CR>

"���䴰���Ϲ԰�ư��j,k��Ʊ��ư��ˤ����䴰��ϸ�������
"inoremap <silent> <expr> <C-p>  pumvisible() ? "\<C-p>" : "<C-r>=MyExecExCommand('normal k')<CR>"
"inoremap <silent> <expr> <C-n>  pumvisible() ? "\<C-n>" : "<C-r>=MyExecExCommand('normal j')<CR>"
"inoremap <silent> <expr> <Up>   pumvisible() ? "\<C-p>" : "<C-r>=MyExecExCommand('normal k')<CR>"
"inoremap <silent> <expr> <Down> pumvisible() ? "\<C-n>" : "<C-r>=MyExecExCommand('normal j')<CR>"

"��Ƭ��
inoremap <silent> <C-a> <C-r>=MyJumptoBol('�����������������֡�')<CR>
"������
inoremap <silent> <C-e> <C-r>=MyJumptoEol('�����������������֡�')<CR>

"������������ʸ�����
inoremap <silent> <BS>  <C-g>u<BS>
inoremap <silent> <C-h> <C-g>u<C-h>
"����������ʸ�����
inoremap <silent> <Del> <C-g>u<Del>
inoremap <silent> <C-g> <C-g>u<Del>

"����������֤�������ñ�����
inoremap <silent> <C-w> <C-g>u<C-r>=MyExecExCommand('normal! db')<CR>
"����������֤�����ñ�����
inoremap <silent> <C-t> <C-g>u<C-r>=MyDeleteWord()<CR>

"�Ǹ����������ʸ���������
inoremap <silent> <C-z> <C-g>u<C-a>

"���߹Ԥ򥤥�ǥ��
inoremap <silent> <Tab>   <C-g>u<C-t>
inoremap <silent> <S-Tab> <C-g>u<C-d>

"undo
inoremap <silent> <C-u> <C-g>u<C-r>=MyExecExCommand('u', 'onemore')<CR>

"�����ȥ�����������
if 1
  "��������ʹߺ��
  inoremap <silent> <C-k><C-k> <C-g>u<C-r>=MyExecExCommand('normal! D', 'onemore')<CR>
  "redo
  "FIXME:<C-r>(��ɥ�)�ϥ��ޥ�ɥ饤�󤫤�exec�Ǽ¹Ԥ���ȿ������ݤʤΤǲ�����
  nnoremap g\\z <C-r>
  inoremap <silent> <C-k><C-r> <C-r>=MyExecExCommand('normal g\\z', 'onemore')<CR>
  "��Ϣ��
  inoremap <silent> <C-k><C-j> <C-g>u<C-r>=MyExecExCommand('normal! J')<CR>
  "��������
  inoremap <silent> <C-k><C-n> <C-g>u<C-r>=MyExecExCommand("call cursor(line('.'), col('$'))")<CR><CR>
endif

"�᥿(alt)��������
if 0
  "��������ʹߺ��
  inoremap <silent> <C-k> <C-g>u<C-r>=MyExecExCommand('normal! D', 'onemore')<CR>
  "��ɥ�
  "FIXME:<C-r>(��ɥ�)�ϥ��ޥ�ɥ饤�󤫤�exec�Ǽ¹Ԥ���ȿ������ݤʤΤǲ�����
  nnoremap g\\z <C-r>
  inoremap <silent> <M-r> <C-r>=MyExecExCommand('normal g\\z', 'onemore')<CR>
  "��Ϣ��
  inoremap <silent> <M-j> <C-g>u<C-r>=MyExecExCommand('normal! J')<CR>
  "��������
  inoremap <silent> <M-n> <C-g>u<C-r>=MyExecExCommand("call cursor(line('.'), col('$'))")<CR><CR>
endif

""""""""""""""""""""""""""""""
"sep�����Ǥʤ���С�sep�򥻥ѥ졼���Ȥ��ƥ����ס�
"���Ĥ���ʤ���и������ι�Ƭ�ء�
"����������֤��������ι�Ƭ�ξ��Ͽ��ι�Ƭ�ء�
""""""""""""""""""""""""""""""
function! MyJumptoBol(sep)
  if col('.') == 1
    call cursor(line('.')-1, col('$'))
    call cursor(line('.'), col('$'))
    return ''
  endif
  if matchend(strpart(getline('.'), 0, col('.')), '[[:blank:]]\+') >= col('.')-1
    silent exec 'normal! 0'
    return ''
  endif
  if a:sep != ''
    call search('[^'.a:sep.']\+', 'bW', line("."))
    if col('.') == 1
      silent exec 'normal! ^'
    endif
    return ''
  endif
  exec 'normal! ^'
  return ''
endfunction

""""""""""""""""""""""""""""""
"sep�����Ǥʤ���С�sep�򥻥ѥ졼���Ȥ��ƥ����ס�
"���Ĥ���ʤ���й����ء�
""""""""""""""""""""""""""""""
function! MyJumptoEol(sep)
  if col('.') == col('$')
    silent exec 'normal! w'
    return ''
  endif

  if a:sep != ''
    let prevcol = col('.')
    call search('['.a:sep.']\+[^'.a:sep.']', 'eW', line("."))
    if col('.') != prevcol
      return ''
    endif
  endif
  call cursor(line('.'), col('$'))
  return ''
endfunction

""""""""""""""""""""""""""""""
"�����Ǥ���ߤ���ñ��ñ�̰�ư���ޥ��
""""""""""""""""""""""""""""""
function! MyMoveWord_i(cmd)
  let isEol = 0
  if col('$') == col('.')
    let isEol = 1
  endif
  let prevline = line('.')
  silent exec 'normal! '.a:cmd
  if line('.') == prevline
    return ''
  endif
  if a:cmd == 'w'
    if isEol == 0
      call cursor(prevline, 0)
      call cursor(line('.'), col('$'))
    endif
    if line('.') - prevline > 1
      call cursor(prevline+1, 0)
      call cursor(line('.'), col('$'))
    endif
  elseif a:cmd == 'b'
    call cursor(line('.'), col('$'))
    if prevline - line('.') > 1
      call cursor(prevline-1, 0)
      call cursor(line('.'), col('$'))
    endif
  endif
  return ''
endfunction

""""""""""""""""""""""""""""""
"��������ʹߤ�ñ����
""""""""""""""""""""""""""""""
function! MyDeleteWord()
  if col('.') == col('$')
    return ''
  endif
  let save_cursor = getpos('.')
  silent exec 'normal! wge'
  if save_cursor[1] != line('.') || (save_cursor[2] > col('.'))
    call setpos('.', save_cursor)
    return MyExecExCommand('normal! dw', 'onemore')
  endif
  silent exec 'normal! v'
  call setpos('.', save_cursor)
  return MyExecExCommand('normal! d')
endfunction

""""""""""""""""""""""""""""""
"IME�ξ��֤ȥ������������¸�Τ���<C-r>����Ѥ��ƥ��ޥ�ɤ�¹ԡ�
""""""""""""""""""""""""""""""
function! MyExecExCommand(cmd, ...)
  let saved_ve = &virtualedit
  let index = 1
  while index <= a:0
    if a:{index} == 'onemore'
      silent setlocal virtualedit+=onemore
    endif
    let index = index + 1
  endwhile

  silent exec a:cmd
  if a:0 > 0
    silent exec 'setlocal virtualedit='.saved_ve
  endif
  return ''
endfunction
"FIXME:<C-r>(��ɥ�)�ϥ��ޥ�ɥ饤�󤫤�exec�Ǽ¹Ԥ���ȿ������ݤʤΤǲ�����
nnoremap g\\z <C-r>

