@echo off
REM Serve the built site on http://127.0.0.1:8000/ with pythons http.server.
REM Unlike "jupyter lite serve" it redirects /tree to /tree/, so File > Open works,
REM the same way as on GitHub Pages. Give a port as the first argument if 8000 is taken.
setlocal
call "%USERPROFILE%\miniforge3\Scripts\activate.bat" jlite
if errorlevel 1 exit /b 1
cd /d "%~dp0"
set PORT=%1
if "%PORT%"=="" set PORT=8000
start "" "http://127.0.0.1:%PORT%/notebooks/index.html?path=start.ipynb"
python serve_dist.py %PORT%
endlocal
