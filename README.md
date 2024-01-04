# nvim
My Neovim setup

![nvim](https://user-images.githubusercontent.com/5790854/153685073-25c68d35-9d88-4e78-a8ea-356c0807046e.gif)

## Install
<details>
<summary>MacOS / Linux</summary>

```
brew install neovim    # or some other installation method
git clone https://github.com/zuqini/nvim.git ~/.config/nvim
nvim
```

`init.vim` will automatically install Vim-Plug and plugins
</details>

<details>
<summary>Windows (Powershell)</summary>

```
choco install neovim    # or some other installation method
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
<summary>Icons/Italics/Ligatures</summary>

- Install a [patched font](https://github.com/ryanoasis/nerd-fonts)
  - Hack
    ```
    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
    ```
  - FiraCode
    - Download at https://www.nerdfonts.com/font-downloads
  
- Configure the installed font in your terminal
  
    - e.g. `Iterm2 > Preferences > Profiles > Text > Font > Hack Nerd Font Mono`
    - Enable ligatures
  
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
