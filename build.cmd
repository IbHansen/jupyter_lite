@echo off
REM Build the JupyterLite site from content\ (and any wheels in pypi\) into dist\
setlocal
call "%USERPROFILE%\miniforge3\Scripts\activate.bat" jlite
if errorlevel 1 exit /b 1
cd /d "%~dp0"
jupyter lite build
endlocal
