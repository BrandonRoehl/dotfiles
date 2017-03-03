" Doesn't need to be Vi compatible the improved part of Vim
set nocompatible
filetype plugin indent on

" Syntax coloring
syntax enable
" Faster redraw
set ttyfast
" Quick redraw
set lazyredraw
" Always show the statusline
set laststatus=2
" Show line numbers
set number
" Soft wrap
set wrap
" show position in the document reg statusline
set ruler
" Always report changed lines
set report=0
" Autocomplete comands menu
set wildmenu
" give support for 256bit coloring
set t_Co=256
set background=light

" Enable mouse suppourt
set mouse=a
" Mouse fix for tmux
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
endif
" Smooth scroll
nnoremap <ScrollWheelUp> <C-Y>
nnoremap <ScrollWheelDown> <C-E>
" Arrow don't skip lines
nnoremap <Up> gk
nnoremap <Down> gj

" Spacing
set backspace=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

" Use system clipboard
if !exists('$TMUX')
    set clipboard=unnamed "unnamedplus
endif

" Vim popup for omnicomplete
set omnifunc=syntaxcomplete#Complete
set completeopt=noinsert,menuone
let g:rubycomplete_buffer_loading=1
let g:rubycomplete_classes_in_global=1
let g:rubycomplete_rails=1
let g:loaded_sql_completion=0
let g:omni_sql_no_default_maps=1

" Keys that trigger completeopt
for key in split("a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z")
    execute "inoremap <silent><expr> " . key . " OpenAutocomp('" . key . "')"
endfor
func OpenAutocomp(key)
    return pumvisible() ? a:key : a:key . "\<c-x>\<c-o>"
endfunc
inoremap <silent><expr> . ".\<C-X>\<C-O>"
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-N>" : "\<Tab>"

set display+=lastline

autocmd BufWritePre * :%s/\s\+$//e

" Remove splash
" set shortmess=I

" highlighting
set cursorline
set scrolloff=2
set colorcolumn=81
set hlsearch
set incsearch
highlight CursorLine   cterm=bold ctermbg=235
highlight CursorLineNr cterm=bold ctermbg=235 ctermfg=226
highlight LineNr       cterm=none ctermbg=235 ctermfg=250
highlight SignColumn   cterm=none ctermbg=235
highlight MatchParen   cterm=bold ctermbg=094 ctermfg=220
highlight ModeMsg      cterm=bold ctermbg=220 ctermfg=235
highlight Pmenu        cterm=none ctermbg=240 ctermfg=254
highlight PmenuSel     cterm=none ctermbg=039 ctermfg=234
highlight PmenuSbar    ctermbg=245
highlight PmenuThumb   ctermbg=235
highlight ColorColumn  ctermbg=235
highlight EndOfBuffer  ctermfg=250
highlight Search cterm=underline ctermbg=NONE
let &fillchars=''
let &showbreak='↳ '

"------   Plugin Settings   ------"
" Enable pathogen
execute pathogen#infect()

" Maps nerd tree for easy access
inoremap <silent> <C-\> <C-o>:NERDTreeToggle<cr>
noremap <silent> <C-\> :NERDTreeToggle<cr>
let g:nerdtree_tabs_focus_on_files=1
let g:nerdtree_tabs_open_on_console_startup=1

noremap <silent> // :call NERDComment(0,"toggle")<cr>
let g:NERDSpaceDelims=1
let g:NERDCommentEmptyLines=1
let g:NERDTrimTrailingWhitespace=1

" Synastic java fix
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['java'] }
" Syntastic Basic setup removing the list
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_aggregate_errors=1
let g:syntastic_cpp_compiler='clang++'
let g:syntastic_cpp_compiler_options=' -std=c++11 -stdlib=libc++'

" AirLine configuration
set noshowmode
let g:airline_theme='dark'
" setup custom symbols
let g:airline_symbols={}
" compatible without powerline fonts
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_symbols.crypt='🔒'
let g:airline_symbols.linenr='␤' " Original symbol
"let g:airline_symbols.linenr='¶'
let g:airline_symbols.maxlinenr='☰'
let g:airline_symbols.branch='⎇'
"let g:airline_symbols.paste='ρ'
"let g:airline_symbols.paste='Þ'
let g:airline_symbols.paste='∥'
let g:airline_symbols.spell='Ꞩ'
let g:airline_symbols.notexists='∄'
let g:airline_symbols.whitespace='Ξ'

" Gitgutter coloring
highlight GitGutterAdd    cterm=none ctermbg=234 ctermfg=119
highlight GitGutterDelete cterm=none ctermbg=234 ctermfg=167
highlight GitGutterChange cterm=none ctermbg=234 ctermfg=220
highlight link GitGutterChangeDelete GitGutterChange
