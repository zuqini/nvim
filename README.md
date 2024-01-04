# nvim
My custom NeoVim configuration and plugins. I recommend complementing this with [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

## Set-up Instructions
- Install [VimPlug](https://github.com/junegunn/vim-plug) and run `:PlugInstall`
- (terminal) Setup [Italics](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/) in your terminal
## Special Plugins Notes
### [Fzf.vim](https://github.com/junegunn/fzf.vim) Dependencies
- [fzf][https://github.com/junegunn/fzf] 0.23.0 or above
- For syntax-highlighted preview, install [bat](https://github.com/sharkdp/bat)
- If [delta](https://github.com/dandavison/delta) is available, `GF?`,
  `Commits` and `BCommits` will use it to format `git diff` output.
- `Ag` requires [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher)
- `Rg` requires[ ripgrep (rg)](https://github.com/BurntSushi/ripgrep)
- `Tags` and `Helptags` require Perl
### [coc.nvim](https://github.com/neoclide/coc.nvim)
#### Useful debugging commands
```
:CocList extensions " Show currently active extensions
:CocCommand workspace.showOutput " Show CocExtension/LSP logs
:CocList outline " Search workspace symbols.
```
#### Unity on Unix
- Add the following override to your .zshrc ([source](https://www.reddit.com/r/vim/comments/i4tuay/anyone_has_managed_to_get_c_and_unity_completion/g0m7wlh/?utm_source=reddit&utm_medium=web2x&context=3)):
```export FrameworkPathOverride=~/.config/coc/extensions/coc-omnisharp-data/server/omnisharp```
