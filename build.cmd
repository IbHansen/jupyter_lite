@echo off
REM Build the JupyterLite site from content\ (and any wheels in pypi\) into dist\
setlocal
REM refresh content\ from the master notebooks (C:\deploy\publish\publish.yml); warnings don't stop the build
if exist "C:\deploy\publish\publish.bat" call "C:\deploy\publish\publish.bat" --path "%~dp0content"
call "%USERPROFILE%\miniforge3\Scripts\activate.bat" jlite
if errorlevel 1 exit /b 1
cd /d "%~dp0"
REM content\ copies are read-only (publish.yml); the build copies that flag into dist\,
REM and then can't replace a changed notebook there. Clear it before building.
if exist dist attrib -R "dist\*" /S /D >nul
jupyter lite build
if errorlevel 1 exit /b 1
REM front page opens pakstart.ipynb in the Notebook interface instead of JupyterLab
copy /y overrides\index.html dist\index.html >nul
endlocal
