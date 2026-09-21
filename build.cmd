@echo off
REM Build the JupyterLite site from content\ (and any wheels in pypi\) into dist\
setlocal
call "%USERPROFILE%\miniforge3\Scripts\activate.bat" jlite
if errorlevel 1 exit /b 1
cd /d "%~dp0"
jupyter lite build
if errorlevel 1 exit /b 1
REM front page opens start.ipynb in the Notebook interface instead of JupyterLab
copy /y overrides\index.html dist\index.html >nul
endlocal
