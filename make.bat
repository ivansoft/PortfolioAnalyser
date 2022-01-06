@ECHO OFF

pushd %~dp0

setlocal EnableDelayedExpansion

:: Define LF to contain a linefeed character
set ^"LF=^

^" The above empty line is critical. DO NOT REMOVE

:: help -help --help /help ? /?
for /f %%A in ("help!LF!-help!LF!--help!LF!/help!LF!?!LF!/?") do (
  if /i "%~1" equ "%%A" goto :help
)
if not "%~1"=="" set "PATH=%~1;%PATH%"

if not defined MSYS_HOME set MSYS_HOME=c:\msys64
set "MSYS_USR_BIN=%MSYS_HOME%\usr\bin"
set "PATH=%MSYS_USR_BIN%;%PATH%"

CALL :check_make
if errorlevel 1 goto :end

make.exe %*

goto :end

:help
echo Usage: make [msys_home_folder]
echo msys_home_folder - Path to your ^<msys2^> installation folder.
echo                    This path will be added to PATH environment variable.

:end
endlocal
popd
exit /b

:check_make
>NUL where make
if errorlevel 1 (
	echo.
	echo 'make.exe' is not recognized as an internal or external command,
	echo operable program or batch file.
	echo Please set up MSYS_HOME environment variable to your MSYS home folder
	echo or pass path via command line parameter - see `make help'.
	echo https://www.msys2.org/#installation
	exit /b /1
)
