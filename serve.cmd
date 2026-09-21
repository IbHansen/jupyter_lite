@echo off
REM Serve the built site on http://127.0.0.1:8000/ (Ctrl+C to stop).
REM jupyter lite serve sets the right file types for .wasm/.mjs, which plain
REM "python -m http.server" on Windows may not.
setlocal
call "%USERPROFILE%\miniforge3\Scripts\activate.bat" jlite
if errorlevel 1 exit /b 1
cd /d "%~dp0"
start "" "http://127.0.0.1:8000/notebooks/index.html?path=start.ipynb"
jupyter lite serve --port 8000
endlocal
