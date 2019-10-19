@echo off

echo This scripts installs SCHOKEMACS using CHOCOLATEY.
echo Note: SCHOKEMACS uses WEMACS variables.
echo Version: 2019-10-19 
echo.

set CHOCO_BIN_PATH=C:\ProgramData\chocolatey\bin 
set ANACONDA_PATH=C:\tools\Anaconda3;C:\tools\Anaconda3\Scripts
set ASPELL_PATH=aspell\bin
set CYGWIN_PATH=C:\tools\cygwin
set CYGWIN_BIN_PATH=C:\tools\cygwin\bin
set GHOSTSCRIPT_PATH=C:\Program Files\gs\gs9.50\bin
set GIT_PATH=C:\Program Files\Git\bin
set GRAPHVIZ_PATH=C:\Program Files ^(x86^)\Graphviz2.38\bin
set GNUPG_PATH=C:\Program Files ^(x86^)\Gpg4win\..\GnuPG\bin
set GNUPLOT_PATH=C:\Program Files\gnuplot\bin
set IMAGEMAGICK_PATH=C:\Program Files\ImageMagick-7.0.8-Q16
set LANGUAGETOOL_PATH=C:\ProgramData\chocolatey\lib\languagetool\tools\LanguageTool-4.3
set OPENJDK_PATH=C:\Program Files\OpenJDK\jdk-11\bin
set R_PATH=C:\Program Files\R\R-3.4.2\bin
set STRAWBERRY_PATH=C:\Strawberry\perl\bin

rem The following binaries are available in CHOCO_BIN_PATH
set PANDOC_PATH= &rem C:\Program Files\Pandoc
set PLANTUML_PATH= &rem C:\ProgramData\chocolatey\lib\plantuml\tools
set PUTTY_PATH= &rem C:\Program Files\PuTTY
set SQLITE_PATH=
set SUMATRA_PATH= &rem C:\Program Files\SumatraPDF

call :set-wemacs-variables

set /P c="Install software with CHOCOLATEY (requires administrator rights) [y/n]? "
if /i "%c%"=="y" (call :install-software)
if /i "%c%"=="n" (echo Software install cancled.)
echo.

call :check-wemacs_path

call :setup-cygwin

call :setup-python

echo.
pause
exit

rem =============================================================

:install-software
echo Installing software ...
echo.

choco install^
 ag^
 anaconda3^
 Emacs^
 cygwin^
 Ghostscript^
 git.install^
 graphviz^
 gpg4win^
 gnuplot^
 imagemagick.app^
 languagetool^
 Lein^
 openjdk^
 OpenSSL.Light^
 pandoc --ia=ALLUSERS=1^
 plantuml^
 r.project^
 ripgrep^
 sqlite^
 sumatrapdf.install^
 strawberryperl^
 wget
echo.
exit /b

rem =============================================================

:set-wemacs-variables
rem Use the path of the batch script: 
set WEMACS_HOME=%~dp0
echo WEMACS_HOME:
echo %WEMACS_HOME%
echo. 
rem Construct WEMACS_PATH with CYGWIN_BIN_PATH being the last one:
set WEMACS_PATH=^
%ANACONDA_PATH%;^
%WEMACS_HOME%%ASPELL_PATH%;^
%GHOSTSCRIPT_PATH%;^
%GIT_PATH%;^
%GRAPHVIZ_PATH%;^
%GNUPLOT_PATH%;^
%GNUPG_PATH%;^
%IMAGEMAGICK_PATH%;^
%OPENJDK_PATH%;^
%PANDOC_PATH%;^
%PLANTUML_PATH%;^
%PUTTY_PATH%;^
%R_PATH%;^
%STRAWBERRY_PATH%;^
%SUMATRA_PATH%;^
%CHOCO_BIN_PATH%;^
%CYGWIN_BIN_PATH%

echo WEMACS_PATH:
echo %WEMACS_PATH%
echo.
rem Finally store variable permanently:
setx WEMACS_HOME %WEMACS_HOME%
setx WEMACS_PATH "%WEMACS_PATH%"
setx WEMACS_LANGUAGETOOL_PATH %LANGUAGETOOL_PATH%
setx MAGICK_CODER_MODULE_PATH "%IMAGEMAGICK_PATH%\modules\coders"
echo.
rem Don't forget to set the HOME variable:
if not exist "%HOME%" (
call :set-home-variable
)
echo.
exit /b

rem =============================================================

:setup-cygwin
if not exist "%CYGWIN_PATH%" (
echo %CYGWIN_PATH% not found!
) else (
echo Installing further packages in Cygwin ...
%CYGWIN_PATH%\cygwinsetup.exe -q --packages=aspell,aspell-de,aspell-en,aspell-fr
)
echo.
exit /b

rem =============================================================

:setup-python
echo Installing python packages required by elpy ...
where pip >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo pip not found.
		echo.
    exit /b
)
rem NOTE: pip requires SSL, therefore OpenSSL is installed with choco.
rem Elpy's recommendation
pip install jedi flake8 importmagic autopep8
rem Zamansky's recommendation
pip install pylint virtualenv epc
echo.
exit /b

rem =============================================================

:set-home-variable
set /P c="Set HOME variable (%HOMEDRIVE%%HOMEPATH%) [y/n]? "
if /i "%c%"=="y" (setx HOME %HOMEDRIVE%%HOMEPATH%)
if /i "%c%"=="n" (echo Warning: Schokemacs assumes the existence of a HOME variable!)
exit /b

rem =============================================================

:check-wemacs_path
echo Checking WEMACS_PATH ...
for %%A in ("%WEMACS_PATH:;=";"%") do (
if exist "%%A" (echo Found %%A
) else (echo Missing %%A
)
)
echo.
exit /b
