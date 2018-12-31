# Installation:

1.   git clone git://github.com/pythonquick/dotvim.git ~/.vim
2.   Install font(s) from ~/.vim/fonts directory
3.   From .vim directory, run script to setup files:

     On Windows:
     > winsetup.bat
     
     On *nix:
     $ sh nixsetup.bat
     
4.   Start VIM and run :BundleInstall to tell Vundle to setup plugins


# ctags

## Hooks to re-generate ctag tags:

See [Tim Pope's ctags blog post](https://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
about setting up a global git hook to generate the `tags` file using `ctags`
whenever merging, committing or checking out.

## Generate ctags for Ruby standard libraries:

See [Time Pope's ctags for rbenv](https://github.com/tpope/rbenv-ctags) plugin readme.


# Notes for setup on Windows machines:

On Windows, set up context menu "Edit with Vim" by importing a .reg file with following content:

        Windows Registry Editor Version 5.00
        [HKEY_CLASSES_ROOT\*\shell\Edit with Vim]
        [HKEY_CLASSES_ROOT\*\shell\Edit with Vim\command] 
        @="C:\\Program Files\\Vim\\vim74\\gvim.exe \"%1\""
