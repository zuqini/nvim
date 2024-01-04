# nvim
My Neovim setup
<img width="1792" alt="Screen Shot 2022-01-17 at 2 31 55 AM" src="https://user-images.githubusercontent.com/5790854/149753476-5594abd9-8185-4c7e-8a19-611bd1a71ccf.png">

## Install
<details>
<summary>MacOS / Linux</summary>
<br/>

```
brew install neovim    # or install neovim with something else
git clone https://github.com/zuqini/nvim.git ~/.config/nvim
nvim
```

`init.vim` will automatically install Vim-Plug and plugins
</details>

<details>
<summary>Windows (Powershell)</summary>
<br/>

```
choco install neovim    # or install neovim with something else
git clone https://github.com/zuqini/nvim.git ~/AppData/Local/nvim

# install vim-plug
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force

nvim
:PlugInstall
```

</details>

## Optional Setup
<details>
<summary>Icons</summary>
<br/>
  
- Install a [patched font](https://github.com/ryanoasis/nerd-fonts)
  ```
  brew tap homebrew/cask-fonts
  brew install --cask font-hack-nerd-font
  ```
- Configure the installed font in your terminal
  
  e.g. `Iterm2 > Preferences > Profiles > Text > Font > Hack Nerd Font Mono`
  
Alternatively if you don't want to setup icons, you can disable them at `lua/configs/lualine.lua` and `vim/configs/nvim-tree.vim`
 
</details>

<details>
<summary>Fzf.vim</summary>
<br/>
  
- [fzf](https://github.com/junegunn/fzf) 0.23.0 or above
- For syntax-highlighted preview, install [bat](https://github.com/sharkdp/bat)
- If [delta](https://github.com/dandavison/delta) is available, `GF?`,
  `Commits` and `BCommits` will use it to format `git diff` output.
- `Ag` requires [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher)
- `Rg` requires[ ripgrep (rg)](https://github.com/BurntSushi/ripgrep)
- `Tags` and `Helptags` require Perl
</details>

<details>
<summary>coc.nvim</summary>
<br/>
  
- Setup [Node.js](https://nodejs.dev/learn/how-to-install-nodejs)
- Omnisharp Language Server on Unix/Linux for Unity
  - Install [Mono](https://www.mono-project.com/download/stable/#download-mac)
  - In Unity, `Unity > Preferences > External Tools`, check off the options below and regenerate project files:
    - Embedded Packages
    - Registry Packages
    - Local Packages
  - You may need to add the following override to your `.zshrc`/`.bashrc` to point to the latest Mono version:
    ```
    export FrameworkPathOverride=/Library/Frameworks/Mono.framework/Versions/Current
    ```
</details>
