# nvim
My Neovim setup
<img width="1792" alt="Screen Shot 2022-01-17 at 2 31 55 AM" src="https://user-images.githubusercontent.com/5790854/149753476-5594abd9-8185-4c7e-8a19-611bd1a71ccf.png">

## Install
<details>
<summary>MacOS / Linux</summary>

```
brew install neovim    # or install neovim with something else
git clone https://github.com/zuqini/nvim.git ~/.config/nvim
nvim
```

`init.vim` will automatically install Vim-Plug and plugins
</details>

<details>
<summary>Windows (Powershell)</summary>

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
<summary>Fzf</summary>

- fd - better find utility
- rg - better grep utility
- bat - syntax highlighted previews when using fzf's native previewer
- delta - syntax highlighted git pager for git status previews
</details>

<details>
<summary>LSP</summary>

- `:LspInstall {server}`
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

<details>
<summary>Treesitter</summary>
    
- `:TSInstall {language}`
</details>
