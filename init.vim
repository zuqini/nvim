if argv(0) == "scratch"
    " use scratch playground settings for testing purposes
    source $HOME/.config/nvim/configs/playground.vim
    finish
endif

source $HOME/.config/nvim/configs/main.vim
source $HOME/.config/nvim/configs/coc.vim
source $HOME/.config/nvim/configs/fzf.vim
source $HOME/.config/nvim/configs/nerdtree.vim
source $HOME/.config/nvim/configs/easymotion.vim
source $HOME/.config/nvim/configs/hardmode.vim

" Disabled
" source $HOME/.config/nvim/configs/absrelnumtoggle.vim
