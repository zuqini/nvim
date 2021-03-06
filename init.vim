let theme = 'spaceduck'

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" BOOTSTRAP PLUG =============================================================
let is_windows = has("win64") || has("win32") || has("win16")

let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
let vim_plug_installed = !empty(glob(autoload_plug_path))
if !is_windows && !vim_plug_installed
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path
" END ========================================================================

call plug#begin(stdpath('data') . '/plugged')
  " Themes
  Plug 'ghifarit53/tokyonight-vim'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'cocopon/iceberg.vim'
  Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
  Plug 'embark-theme/vim', { 'as': 'embark' }

  Plug 'preservim/nerdtree'
  Plug 'PhilRunninger/nerdtree-visual-selection'

  Plug 'junegunn/vim-plug'
  Plug 'junegunn/vim-peekaboo'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  " note for fzf.vim: for special commands like :Ag and :Rg, need to install additional
  " dependencies. See: https://github.com/junegunn/fzf.vim

  " ds,cs,ts
  Plug 'tpope/vim-surround'
  " gc
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-endwise'

  Plug 'psliwka/vim-smoothie'
  Plug 'machakann/vim-highlightedyank'
  Plug 'jiangmiao/auto-pairs'
  Plug 'takac/vim-hardtime'
  Plug 'Yggdroot/indentLine'
  Plug 'easymotion/vim-easymotion'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'sheerun/vim-polyglot'
  Plug 'itchyny/lightline.vim'
  Plug 'preservim/nerdtree'
  Plug 'PhilRunninger/nerdtree-visual-selection'
  Plug 'Asheq/close-buffers.vim'
call plug#end()

let configs_path = stdpath('config') . '/configs'
if vim_plug_installed
  exec "source " . configs_path . "/themes/" . theme . ".vim"
  exec "source " . configs_path . "/main.vim"

  exec "source " . configs_path . "/goyolime.vim"
  exec "source " . configs_path . "/coc.vim"
  exec "source " . configs_path . "/fzf.vim"
  exec "source " . configs_path . "/nerdtree.vim"
  exec "source " . configs_path . "/easymotion.vim"
  exec "source " . configs_path . "/surround.vim"
  exec "source " . configs_path . "/nutoggle.vim"
  exec "source " . configs_path . "/smoothie.vim"

  " Disabled
  " exec "source " . stdpath('config') . "/configs/hardmode.vim"
endif
