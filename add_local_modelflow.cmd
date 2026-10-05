@echo off
REM ---------------------------------------------------------------
REM  Optional: put a wheel of your LOCAL modelflow source into pypi\.
REM  The site then installs that instead of modelflowib from PyPI.
REM  Rebuild afterwards (build.cmd). To go back to PyPI: delete pypi\*.whl AND the
REM  whole dist\ folder, then build.cmd - the build never removes the old wheel or
REM  its index entry in dist\jupyter-lite.json, so the site would keep using it.
REM
REM  Usage:  add_local_modelflow.cmd [path-to-modelflow-source]
REM          default: C:\modelflow2\modelflow (whatever branch is checked out)
REM ---------------------------------------------------------------
setlocal
set "SRC=%~1"
if "%SRC%"=="" set "SRC=C:\modelflow2\modelflow"
call "%USERPROFILE%\miniforge3\Scripts\activate.bat" jlite
if errorlevel 1 exit /b 1
cd /d "%~dp0"
if not exist pypi mkdir pypi
del /q pypi\modelflowib-*.whl 2>nul
python -m pip wheel --no-deps --wheel-dir pypi "%SRC%"
if errorlevel 1 exit /b 1
dir /b pypi\*.whl
echo.
echo Now run build.cmd
endlocal
