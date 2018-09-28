set backupcopy=yes
set clipboard=unnamed

" Default indentation
set expandtab
"set tabstop=2
set shiftwidth=2

call plug#begin('~/.vim/plugged')
Plug 'junegunn/vim-plug'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'rhysd/vim-gfm-syntax'
Plug 'terryma/vim-multiple-cursors'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Chiel92/vim-autoformat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'leafgarland/typescript-vim'
Plug 'isRuslan/vim-es6'
call plug#end()

set termguicolors
colorscheme seoul256

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=239
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=237



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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on 
"    means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undodir=~/.vim_runtime/temp_dirs/undodir
    set undofile
catch
endtry
