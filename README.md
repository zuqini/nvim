# nvim

## Install
MacOS / Linux

```
brew install neovim    # or some other package manager
git clone https://github.com/zuqini/nvim.git ~/.config/nvim
nvim
```
Windows

```
choco install neovim    # or some other package manager
git clone https://github.com/zuqini/nvim.git ~/AppData/Local/nvim
nvim
```

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
<summary>Unity LSP</summary>

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
