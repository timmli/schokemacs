@echo off

if not exist .emacs.d git clone https://github.com/timmli/.emacs.d.git

set EMACS_USER_DIRECTORY=%WEMACS_HOME%\.emacs.d
emacs -q --load .emacs.d\init.el
