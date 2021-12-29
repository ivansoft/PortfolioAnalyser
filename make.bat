@ECHO OFF

pushd %~dp0

if "%~1" == "" goto empty

python -V >NUL 2>NUL
if errorlevel 9009 (
	echo.
	echo.The 'python' command was not found.
	echo.
	echo.If you don't have Python installed, grab it from
	echo.https://www.python.org/downloads/
	exit /b /1
)

pip -V >NUL 2>NUL
if errorlevel 9009 (
	echo.
	echo.The 'pip' command was not found.
	echo.
	echo.If your Python environment does not have pip installed, there are 2
	echo.mechanisms to install pip supported directly by pip’s maintainers:
	echo.* ensurepip ^(https://docs.python.org/3/library/ensurepip.html^)
	echo.* get-pip.py ^(https://bootstrap.pypa.io/get-pip.py^)
	exit /b /1
)

python -c "import os; print(os.environ['VIRTUAL_ENV'])" >NUL 2>NUL
if errorlevel 1 (
	echo.
	echo.Python is running outside virtual environment.
	echo.
	echo.Use venv to isolate libraries and scripts from those installed in other
	echo.environments and ^(by default^) from a "system" Python environment.
	echo.
	echo.For more information please visit:
	echo.https://docs.python.org/3/library/venv.html
	exit /b /1
)

CALL :COMMAND_%~1
if errorlevel 1 goto :unknown
exit /b

:COMMAND_install
	pip install -U pip setuptools
	pip install -Ur requirements-dev.txt
	goto :end
:COMMAND_version
	python -V
	pip -V
	echo.VIRTUAL_ENV: %VIRTUAL_ENV%
	goto :end
:COMMAND_clean
	pip list --exclude pip --exclude setuptools --format freeze > __temp.txt
	type __temp.txt
	pip uninstall -yr __temp.txt
	del /f /q __temp.txt
	goto :end

:unknown
echo.make: *** No rule to make target '%~1'.  Stop.
goto :help

:empty
echo.make: *** No targets specified.  Stop.
goto :help

:help
echo.Available commands:
echo. install - install all requirements
echo. version - Python / pip version numbers

:end
popd
