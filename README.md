# nvim
My custom NeoVim configuration and plugins.
![image](https://user-images.githubusercontent.com/5790854/103149736-22e72a80-4721-11eb-9519-019522241c2a.png)

## Installation
- Install [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- Clone into `~/.config/nvim` (Unix/Linux) or `~/AppData/Local/nvim` (Windows)
- (Optional) Set up terminal
  - Enable true color mode if needed
  - Setup [Italics](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/)
- (Windows) Install [Vim-Plug](https://github.com/junegunn/vim-plug) and `:PlugInstall`

\*`init.vim` will automatically install Vim-Plug and plugins for Unix/Linux.

## Additional Setup
### [Fzf.vim](https://github.com/junegunn/fzf.vim)
- [fzf](https://github.com/junegunn/fzf) 0.23.0 or above
- For syntax-highlighted preview, install [bat](https://github.com/sharkdp/bat)
- If [delta](https://github.com/dandavison/delta) is available, `GF?`,
  `Commits` and `BCommits` will use it to format `git diff` output.
- `Ag` requires [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher)
- `Rg` requires[ ripgrep (rg)](https://github.com/BurntSushi/ripgrep)
- `Tags` and `Helptags` require Perl
### [coc.nvim](https://github.com/neoclide/coc.nvim)
#### Setup Unity Language Server on Unix/Linux
- Add the following override to your `.zshrc`/`.bashrc` ([source](https://www.reddit.com/r/vim/comments/i4tuay/anyone_has_managed_to_get_c_and_unity_completion/g0m7wlh/?utm_source=reddit&utm_medium=web2x&context=3)):
```
export FrameworkPathOverride=~/.config/coc/extensions/coc-omnisharp-data/server/omnisharp
```
