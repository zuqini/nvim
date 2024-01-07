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

<details>
<summary>nvim as an external editor in Godot</summary>

## From [godot.nvim](https://github.com/Lommix/godot.nvim?tab=readme-ov-file#how-to-use-nvim-as-external-editor)

its pretty simple with nvim remote

create a bash script, make it executeable. add the following context:
```
#!/bin/bash
[ -n "$1" ] && file=$1
nvim --server ~/.cache/nvim/godot.pipe --remote-send ':e '$file'<CR>'
```

Now start nvim in your project folder and listen to the pipe file:
```
nvim --listen ~/.cache/nvim/godot.pipe .
```
Since you probably dont want to type out that huge path, each time you want to start nvim, make it another bashscript and add it to your globals.
On my systems its simple named "gvim".

Add external config to your editor settings with the path to the first script:
![Screenshot from 2022-10-14 13-17-14](https://user-images.githubusercontent.com/84206502/195834456-41d65a9e-172b-4a45-a352-f976e2a19be8.png)

Done! if you click on the script icon in godot, nvim will open the file. Have fun!

## From [vim-godot](https://github.com/habamax/vim-godot?tab=readme-ov-file#setup-vim-as-an-external-editor-for-godot)

Navigate to the root of your godot project (where the project.godot is residing) and start a new Neovim like this:

```
nvim --listen ./godothost
```

(on Windows you might have to specify a IP:port combination instead, like "127.0.0.1:9696")

Open menu `Editor/Editor Settings/` then navigate to `General/External/`:

* Tick `Use external editor`
* Add `nvim` to `Exec Path`
* Add `--server ./godothost --remote-send "<C-\><C-N>:n {file}<CR>{line}G{col}|"` to `Exec Flags`

now when you click on a script in godot it will open it in a new buffer in Neovim.
</details>
