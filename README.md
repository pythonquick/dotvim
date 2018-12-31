# Installation:

1.   Clone this repo to a local directory. For example to clone to the `.vim` directory under the home directory, run the following command: 

    git clone git://github.com/pythonquick/dotvim.git ~/.vim

2.   Install font(s) from ~/.vim/fonts directory
3.   From .vim directory, run script to setup files:
3.1 On Windows:

     winsetup.bat

3.2 On *nix, in this repo's directory, run following command:
3.2.1 for neovim run:

    ln -s vimrc ~/.config/nvim/init.vim

3.2.2 for vim run:

    ln -s vimrc ~/.vimrc

4.   Start VIM and run :PlugInstall to download and install plugins listed in vimrc file


# Optional ctags configuration

## Hooks to re-generate ctag tags:

See [Tim Pope's ctags blog post](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
about setting up a global git hook to generate the `tags` file using `ctags`
whenever merging, committing or checking out.

## Generate ctags for Ruby standard libraries:

See [Time Pope's ctags for rbenv](https://github.com/tpope/rbenv-ctags) plugin readme.


# Notes for setup on Windows machines:

On Windows, set up context menu "Edit with Vim" by importing a .reg file with following content.
This assumes `gvim` is installed at `C:\Program Files\Vim\vim74\gvim.exe`. Adjust as necessary.

    Windows Registry Editor Version 5.00
    [HKEY_CLASSES_ROOT\*\shell\Edit with Vim]
    [HKEY_CLASSES_ROOT\*\shell\Edit with Vim\command] 
    @="C:\\Program Files\\Vim\\vim74\\gvim.exe \"%1\""
