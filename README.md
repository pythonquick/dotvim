# Installation:

1.   Clone this repo to a local directory. For example to clone to the `~/dotfiles/dotvim` directory under the home directory, run the following command: 

    mkdir -p ~/dotfiles
    git clone git://github.com/pythonquick/dotvim.git ~/dotfiles/dotvim

2.   Install font(s) from ~/.vim/fonts directory
3.   From .vim directory, run script to setup files:
3.1 On Windows:

     winsetup.bat

3.2 On *nix, in this repo's directory, run following command:
3.2.1 for neovim run: Say the repo was cloned into directory ~/dotfiles/dotvim, run the following commands:

    mkdir -p ~/.config/nvim
    ln -s ~/dotfiles/dotvim/vimrc ~/.config/nvim/init.vim

3.2.2 for vim run: Say the repo was cloned into directory ~/dotvim, run the following commands:

    ln -s ~/dotfiles/dotvim/vimrc ~/.vimrc

4.   Start VIM and run :PlugInstall to download and install plugins listed in vimrc file


# Optional ctags configuration

## Hooks to re-generate ctag tags:

See [Tim Pope's ctags blog post](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
about setting up a global git hook to generate the `tags` file using `ctags`
whenever merging, committing or checking out.

## Generate ctags for Ruby standard libraries:

See [Time Pope's ctags for rbenv](https://github.com/tpope/rbenv-ctags) plugin readme.


# Notes for auto-completion plugin on neovim

The neovim auto-completion plugin [Deoplete](https://github.com/shougo/deoplete.nvim)
requires neovim with python3 support. Follow the setup instructions on the 
[Deoplete](https://github.com/shougo/deoplete.nvim) page.

For Ruby autocompletion, setup the `solargraph` language server and plugin.
See [deoplete-solargraph](https://github.com/uplus/deoplete-solargraph)

# Notes for setup on Windows machines:

On Windows, set up context menu "Edit with Vim" by importing a .reg file with following content.
This assumes `gvim` is installed at `C:\Program Files\Vim\vim74\gvim.exe`. Adjust as necessary.

    Windows Registry Editor Version 5.00
    [HKEY_CLASSES_ROOT\*\shell\Edit with Vim]
    [HKEY_CLASSES_ROOT\*\shell\Edit with Vim\command] 
    @="C:\\Program Files\\Vim\\vim74\\gvim.exe \"%1\""
