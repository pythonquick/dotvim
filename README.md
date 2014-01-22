Installation:

1.   git clone git://github.com/pythonquick/dotvim.git ~/.vim
2.   Install font(s) from ~/.vim/fonts directory
3.   From .vim directory, run script to setup files:

     On Windows:
     > winsetup.bat
     
     On *nix:
     $ sh nixsetup.bat
     
4.   Start VIM and run :BundleInstall to tell Vundle to setup plugins



Miscellaneous notes:

On Windows, set up context menu "Edit with Vim" by importing a .reg file with following content:

        Windows Registry Editor Version 5.00
        [HKEY_CLASSES_ROOT\*\shell\Edit with Vim]
        [HKEY_CLASSES_ROOT\*\shell\Edit with Vim\command] 
        @="C:\\Program Files\\Vim\\vim74\\gvim.exe \"%1\""

