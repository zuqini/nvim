source configs/vimcompativility.vim

if argv(0) == "scratch"
    " use scratch playground settings for testing purposes
    source configs/playground.vim
    finish
endif

source configs/main.vim
source configs/coc.vim
source configs/fzf.vim
source configs/nerdtree.vim
source configs/easymotion.vim
source configs/hardmode.vim

" Disabled
" source configs/absrelnumtoggle.vim
