" This needs to be the first line.
set nocompatible

" Vundle config
" ----------------------------------------------------------------------
" Disclaimer: This list is bloated and perhaps unjustifiable. The end
" goal is to document the purpose and key commands of the plugins I
" decide to keep.

filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Browse file tree
" Ctrl+N bound below to open nerdtree on current file.
Plugin 'scrooloose/nerdtree'

" Commenting
Plugin 'tpope/vim-commentary'

" Syntax checking
Plugin 'scrooloose/syntastic'

" Status bar plugin.
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" sidebar with class/function names
" :TagbarOpen or :TagbarToggle to view tags
" These tags are independent of ctags.
Plugin 'majutsushi/tagbar'

" Snippets manager
Plugin 'SirVer/ultisnips'
" Snippets list
Plugin 'honza/vim-snippets'

" Terminal integration
Plugin 'wincent/terminus'

" Monochrome colorscheme
Plugin 'fxn/vim-monochrome'

" Surround plugin
Plugin 'tpope/vim-surround'

" ALL THE THEMES. Remove this after finding a good theme?
" Plugin 'flazz/vim-colorschemes'

" Golang support
" https://github.com/fatih/vim-go-tutorial
" TODO: Make a 'local plugins' file and move this plugin there.
Plugin 'fatih/vim-go'

" Hard time plugin, temporary.
Plugin 'takac/vim-hardtime'

" Show delta of file with base version.
Plugin 'mhinz/vim-signify'

" Auto-save buffers.
" Toggle by :AutoSaveToggle
Plugin 'vim-scripts/vim-auto-save'

" org-mode
Plugin 'jceb/vim-orgmode'
" Deps
Plugin 'tpope/vim-speeddating'

" Plugins for markdown editing.

" Vim pencil plugin, utility functions for text editing.
" :Pencil to initialize
"   :PencilSoft for soft line wrap mode
"   :PencilHard for hard line break mode
Plugin 'reedes/vim-pencil'

" Pencil color theme
" Plugin 'reedes/vim-colors-pencil'

" Markdown support
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'

" Lightweight auto-correct
Plugin 'reedes/vim-litecorrect'

" Distraction free writing
Plugin 'junegunn/goyo.vim'

" Spacemacs keybindings for vim
Plugin 'meitham/vim-spacemacs'

Plugin 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required

" Plugin config
" ----------------------------------------------------------------------

set rtp+=~/.fzf


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

" airline config:
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_section_y = ''
let g:airline_theme='minimalist'
" hardtime config:
let g:hardtime_default_on = 0
let g:hardtime_showmsg = 1
let g:hardtime_ignore_buffer_patterns = [ "NERD.*" ]
let g:hardtime_ignore_quickfix = 1
let g:hardtime_allow_different_key = 1
let g:hardtime_maxcount = 2

" signify config:
let g:signify_vcs_list = [ 'git', 'perforce', 'svn' ]
let g:signify_skip_filename_pattern = ['\.pipertmp.*']

" text file editing:
augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
augroup END

augroup litecorrect
  autocmd!
  autocmd FileType markdown,mkd call litecorrect#init()
augroup END

" auto-save config
let g:auto_save = 0
let g:auto_save_in_insert_mode = 0


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

" Set leaders (space to mimic spacemacs).
let mapleader=" "
let maplocalleader=","

" Set terminal window title based on vim buffer.
autocmd BufEnter * let &titlestring = ' VIM : ' . expand("%:t")
set title

" Set *.md as markdown filetype.
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" Always delete trailing whitespace on file save.
autocmd BufWritePre * %s/\s\+$//e

filetype plugin indent on
syntax on
set t_Co=256
set ruler
set autoindent
set incsearch                       " Enable incremental highlighing of search.
set relativenumber                  " Show relative number of other lines.
set number                          " Show number of the current line.
set hlsearch                        " Highlight search results (Use * for hl of current word).
set laststatus=2                    " Always show bottom status bar.
set showcmd                         " Show command as it is being typed.
set colorcolumn=80,100              " Set rulers at column 80 and 100.
set nofoldenable                    " Folds begone.
" Set indent.
set tabstop=2                       " Width of \t
set shiftwidth=2                    " Indents width
set softtabstop=2                   " Number of columns per TAB
set expandtab                       " Expand to spaces.

" gvim options
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar
set gfn=Input\ 12

" Custom commands

" Command for git grep
" - fzf#vim#grep(command, with_column, [options], [fullscreen])
command! -bang -nargs=* GG
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0, <bang>0)

" Use fzf where-ever possible.
autocmd VimEnter * map <leader>ff :Files<ENTER>
autocmd VimEnter * map <leader>bb :Buffers<ENTER>
autocmd VimEnter * map <leader>Ts :Colors<ENTER>

" Read from local config if it exists.
try
  source ~/.vimrc.local
catch
  " Ignore.
endtry

" Some other good ones: candycode, torte, slate, primary
" let g:monochrome_italic_comments = 1
" colorscheme monochrome
colorscheme default

" Override the theme's color for column rulers to a more sane value.
" highlight color for rulers.
highlight ColorColumn ctermbg=Black guibg=#4c4c4c
