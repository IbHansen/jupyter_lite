@echo off
REM Serve the built site on http://127.0.0.1:8000/ with pythons http.server.
REM Unlike "jupyter lite serve" it redirects /tree to /tree/, so File > Open works,
REM the same way as on GitHub Pages. Give a port as the first argument if 8000 is taken.
REM Generated - master: C:\deploy\sitecontrol\lite\shared\serve_dist.cmd
setlocal
call "%USERPROFILE%\miniforge3\Scripts\activate.bat" jlite
if errorlevel 1 exit /b 1
cd /d "%~dp0"
set PORT=%1
if "%PORT%"=="" set PORT=8000
REM the front page: overrides\index.html of the site, else JupyterLab
start "" "http://127.0.0.1:%PORT%/"
python serve_dist.py %PORT%
endlocal
