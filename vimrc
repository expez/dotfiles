set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set backspace=2
set autoindent
set nobackup
set showmatch
set hidden
set showmode
set lazyredraw
set wildmenu
set wrapscan
set ch=2
set vb
set cpoptions=ces$
set stl=%f\ %m\ %r\ Line:\ %l/%L[%p%%]\ Col:\ %c\ Buf:\ #%n\ [%b][0x%B]
set laststatus=2
set mousehide
set history=100
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo
set scrolloff=8
set expandtab
set shiftwidth=2
set softtabstop=2
set virtualedit=all
if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;orange\x7"
  " use a red cursor otherwise
  " let &t_EI = "\<Esc>]12;red\x7"
  silent !echo -ne "\033]12;red\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal
endif
