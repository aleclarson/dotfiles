set backupcopy=yes
set clipboard=unnamed

" Allow mouse
set mouse=a

" https://vi.stackexchange.com/a/28721/9245
set re=2

" Default indentation
set expandtab
"set tabstop=2
set shiftwidth=2

call plug#begin('~/.vim/plugged')
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/vim-plug'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'rhysd/vim-gfm-syntax'
Plug 'terryma/vim-multiple-cursors'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Chiel92/vim-autoformat'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'leafgarland/typescript-vim'
Plug 'isRuslan/vim-es6'
Plug 'iloginow/vim-stylus'
Plug 'sainnhe/everforest'
call plug#end()

set termguicolors
silent! colorscheme everforest

let g:indent_guides_enable_on_vim_startup = 0

" CoC extensions
let g:coc_global_extensions = ['coc-tsserver']

" CoC confirm auto-completion
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" shift-up: new tab
nmap <S-t> :tabedit<Space>

" shift-down: close tab
nmap <S-w> :tabclose<CR>

" shift-left: previous tab
nmap <S-Left> :tabp<CR>

" shift-right: next tab
nmap <S-Right> :tabn<CR>

" tab: indent
nmap <Tab> >>

" shift-tab: dedent
nmap <S-Tab> <<

" shift-p: paste before cursor and move to first char of pasted string
nmap P Pg;

" ctrl-d: delete current word
nmap <C-d> daw
imap <C-d> <C-o>daw

" ctrl-a: move to first char on current line
nmap <C-a> 0
imap <C-a> <C-o>0

" ctrl-e: move to last char on current line
nmap <C-e> $
imap <C-e> <C-o>$

" Don't remember what these do
nmap <ESC>b B
nmap <ESC>f E
imap <ESC>b <C-o>B
imap <ESC>f <C-o>E

" m: search down
nmap m /<CR>
" n: search up
nmap n ?<CR>




" Set to auto read when a file is changed from the outside
set autoread

" Reload the buffer when Vim is focused or the buffer is switched
au FocusGained,BufEnter * :silent! !

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Make comma the <leader>
let mapleader=","

" Fast saving
nmap <leader>w :w!<cr>

" Fast quit
nmap <leader>q :q<cr>

" Always show the cursor position
set ruler

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Search as you type
set incsearch

" Enable regular expressions
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Fix backspace
set backspace=indent,eol,start

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on 
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry

if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;red\x7"
  silent !echo -ne "\033]12;red\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
endif
