" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

let data_dir = has('vim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'vim-airline/vim-airline'
Plug 'hashivim/vim-terraform'
Plug 'lervag/vimtex'

call plug#end()


set nu!
set mouse=a
set title
set cursorline
set encoding=utf-8
set autoindent expandtab tabstop=2 shiftwidth=2
filetype detect
set autoread

" Store backup, undo, and swap files in tmp directory
set directory=/tmp/
set backupdir=/tmp/
set undodir=/tmp/

vmap <C-c> :<Esc>`>a<CR><Esc>mx`<i<CR><Esc>my'xk$v'y!xclip -selection c<CR>u
map <Insert> :set paste<CR>i<CR><CR><Esc>k:.!xclip -o<CR>JxkJx:set nopaste<CR> 

" autocmd VimEnter * NERDTree

" No-Plugin Setup
set nocompatible

filetype plugin indent on
syntax enable

" Search down into subfolders
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Create the `tags` file (may need to install ctags first)
command! MakeTags !ctags -R .

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Read an empty HTML template and move cursor to title
nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a

" Open and read documents with zathura
	map <F5> 0yi"!zathura <C-R>"; disown<CR><CR>
" Spell-check set to F6:
        map <F6> :setlocal spell! spelllang=en_us<CR>
        map <F7> :set spelllang=pt<CR>
" Make presentation in sent:
        map <F8> :w!<CR>:!sent <c-r>%<CR><CR>

" Recompile suckless programs automatically
	autocmd BufWritePost config.h,config.def.h !su -c "make clean install"

" Format Go source code files automatically
autocmd BufWritePost *.go :w | !go fmt %

" Format Terraform files automatically
autocmd BufWritePost *.tf :w | !terraform fmt 

" VimTeX configuration

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
" let g:vimtex_view_general_viewer = 'okular'
" let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","

" Update binds when xbindkeysrc is updated.
	autocmd BufWritePost *xbindkeysrc !killall xbindkeys; xbindkeys --poll-rc
" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !killall sxhkd; setsid sxhkd &

" Set tabsize on all files automatically
autocmd FileType all setlocal tabstop=2
