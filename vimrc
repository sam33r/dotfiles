" This needs to be the first line.
set nocompatible

" Vundle config
" ----------------------------------------------------------------------

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Google color scheme
Plugin 'google/vim-colorscheme-primary'

" Browse file tree
Plugin 'scrooloose/nerdtree'

" Commenting
Plugin 'scrooloose/nerdcommenter'

" Syntax checking
Plugin 'scrooloose/syntastic'

" Status bar plugin.
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" sidebar with class/function names
Plugin 'majutsushi/tagbar'

" Snippets manager
Plugin 'SirVer/ultisnips'
" Snippets list
Plugin 'honza/vim-snippets'

" Surround plugin
Plugin 'tpope/vim-surround'

" ALL THE THEMES. Remove this after finding a good theme?
Plugin 'flazz/vim-colorschemes'

" Golang support
" https://github.com/fatih/vim-go-tutorial
Plugin 'fatih/vim-go'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Plugin config
" ----------------------------------------------------------------------

" syntastic config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {'mode': 'passive'}

" nerdtree config:
map <C-n> :NERDTreeFind<cr>
let NERDTreeQuitOnOpen=1

" Tagbar config:
nmap <F8> :TagbarToggle<CR>

" ultisnips config:
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" airline config
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
" the separator used on the left side
let g:airline_left_sep=''
" " the separator used on the right side 
let g:airline_right_sep=''
let g:airline_theme='bubblegum'


filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" VIM Config
" -------------------------------------------------------------------------

" Set terminal window title based on vim buffer.
autocmd BufEnter * let &titlestring = ' VIM : ' . expand("%:t")
set title

filetype plugin indent on
syntax on
set t_Co=256
set ruler
set autoindent
set relativenumber                  " Show relative number of other lines.
set number                          " Show number of the current line.
set hlsearch                        " Highlight search results (Use * for hl of current word).
set laststatus=2                    " Always show bottom status bar.
" Set indent.
set tabstop=2                       " Width of \t
set shiftwidth=2                    " Indents width
set softtabstop=2                   " Number of columns per TAB
set expandtab                       " Expand to spaces.
" set colorcolumn=80,100              " Highlight 80th and 100th column.
" hi ColorColumn ctermbg=darkgrey

" Read from local config if it exists.
try
  source ~/.vimrc.local
catch
  " Ignore.
endtry

" Some other good ones: torte, slate, primary
colorscheme candycode
