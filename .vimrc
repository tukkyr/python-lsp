set nocompatible
filetype off

call plug#begin('~/.vim/plugged')

Plug 'VundleVim/Vundle.vim'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'easymotion/vim-easymotion'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'jacoborus/tender.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'enricobacis/vim-airline-clock'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nvie/vim-flake8'
Plug 'janko/vim-test'
Plug 'tpope/vim-dispatch'

call plug#end()
filetype plugin indent on
syntax enable

set nrformats=
set encoding=utf-8
set nowrap

if (has("termguicolors"))
  set termguicolors
  silent! colorscheme tender
  let g:airline_theme='tenderplus'
endif

if &term == "screen"
  set t_Co=256
  if (has("termguicolors"))
    set notermguicolors
  endif
endif

" let g:airline_powerline_fonts = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#clock#auto = 1

hi! Normal ctermbg=NONE guibg=NONE
hi! NonText ctermbg=NONE guibg=NONE
hi! LineNr ctermbg=NONE guibg=NONE

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

let g:go_fmt_command = "goimports"

let g:go_def_mapping_enabled = 0
let g:go_def_keywordprg_enable = 0
let g:go_template_autocreate = 0
let g:go_auto_sameids = 1

" set hls
set number
set spelllang+=cjk
set spell

set ts=4 sw=4 noet
" set ts=2 sw=2 et

set backspace=indent,eol,start

let g:EasyMotion_do_mapping = 0

nmap s <Plug>(easymotion-overwin-f2)

if executable('pyls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': { server_info -> ['pyls'] },
    \ 'whitelist': ['python'],
    \ 'workspace_config': {'pyls': {'plugins': {
    \   'jedi_definition': {'follow_imports': v:true, 'follow_builtin_imports': v:true},}}}
    \})
  autocmd FileType python call s:configure_lsp()
endif

if executable('gopls')
  autocmd User lsp_setup call lsp#register_server({
    \ 'name': 'gopls',
    \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
    \ 'whitelist': ['go'],
    \ })
  autocmd FileType go call s:configure_lsp()
endif

function! s:configure_lsp() abort
  setlocal omnifunc=lsp#complete
  nnoremap <buffer> <C-]> :<C-u>LspDefinition<CR>
  nnoremap <buffer> gd :<C-u>LspDefinition<CR>
  nnoremap <buffer> K :<C-u>LspHover<CR>
endfunction

autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')

autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
autocmd BufNewFile,BufRead *.md setlocal expandtab tabstop=2 shiftwidth=2

let g:lsp_diagnostics_enabled = 0

let g:test#python#runner = 'pytest'
" let g:test#strategy = 'dispatch'

autocmd BufWritePost *.py call flake8#Flake8()
