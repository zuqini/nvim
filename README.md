# nvim
My custom NeoVim configuration and plugins.
![image](https://user-images.githubusercontent.com/5790854/103149736-22e72a80-4721-11eb-9519-019522241c2a.png)

## Installation
### Unix/Linux (terminal)
- Install Homebrew and run `$ brew install neovim`
- Set up terminal
  - Enable true color mode in terminal if needed
  - Setup [Italics](https://alexpearce.me/2014/05/italics-in-iterm2-vim-tmux/)
- Clone into `~/.config/nvim`
- Run `$ nvim`

\*`init.vim` will automatically install Vim-Plug and plugins.

### Windows (nvim-qt)
\*Windows requires manual Vim-Plug and plugins installation.
- Follow the [Windows installation instructions](https://github.com/neovim/neovim/releases/)
- Add path to `nvim-qt.exe` to environment variables
- Install [Vim-Plug](https://github.com/junegunn/vim-plug)
- Clone into `~/AppData/Local/nvim`
- Open powershell and run `> nvim-qt`
- Run `:PlugInstall`

See `ginit.vim` for nvim-qt specific configs.

## Optional Plugins Setup
### [Fzf.vim](https://github.com/junegunn/fzf.vim) Dependencies
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

\*Useful debugging commands
```
:CocList extensions " Show currently active extensions
:CocCommand workspace.showOutput " Show CocExtension/LSP logs
:CocList outline " Search workspace symbols.
```

## Symlink NeoVim configs to Vim8 (Unix/Linux)

Run the following commands into your shell. ([Source](https://gist.github.com/laggardkernel/9013f948345212563ede9c9ee56c6b42))

```bash
# nvim conf dir: ~/.config/nvim
# vim conf dir: ~/.vim
# link the 1st as the 2nd with relative links

# Prepare a vimrc file in ~/.config/nvim folder
ln -sf ./init.vim ~/.config/nvim/vimrc

# Link the whole ~/.config/nvim folder as ~/.vim foler
ln -sf ./.config/nvim ~/.vim
```
