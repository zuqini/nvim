# nvim
My custom NeoVim configuration and plugins.
![image](https://user-images.githubusercontent.com/5790854/103149736-22e72a80-4721-11eb-9519-019522241c2a.png)

## Set-up Instructions
- (macOS) Clone this into `~/.config/nvim`
- (terminal) Setup [Italics](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/) in your terminal
- (optional) See [Additional Plugins Notes](#Additional-Plugins-Notes) for additional plugin setup instructions
## Additional Plugins Notes
### [Fzf.vim](https://github.com/junegunn/fzf.vim) Dependencies
- [fzf](https://github.com/junegunn/fzf) 0.23.0 or above
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
#### Unity on Unix/Linux
- Add the following override to your `.zshrc`/`.bashrc` ([source](https://www.reddit.com/r/vim/comments/i4tuay/anyone_has_managed_to_get_c_and_unity_completion/g0m7wlh/?utm_source=reddit&utm_medium=web2x&context=3)):
```export FrameworkPathOverride=~/.config/coc/extensions/coc-omnisharp-data/server/omnisharp```

## Symlink NeoVim configs to Vim8 (Unix/Linux)

[Source](https://gist.github.com/laggardkernel/9013f948345212563ede9c9ee56c6b42)

We try to symlink `~/.config/nvim` to `~/.vim` and make the conf compatible with `vim`. Run the following commands into your shell.

```bash
# nvim conf dir: ~/.config/nvim
# vim conf dir: ~/.vim
# link the 1st as the 2nd with relative links

# Prepare a vimrc file in ~/.config/nvim folder
ln -sf ./init.vim ~/.config/nvim/vimrc

# Link the whole ~/.config/nvim folder as ~/.vim foler
ln -sf ./.config/nvim ~/.vim
```
