@echo off
REM ---------------------------------------------------------------
REM  One-time setup: conda env 'jlite' with the JupyterLite build tools
REM  (requirements.txt). Uses Miniforge in %USERPROFILE%\miniforge3.
REM ---------------------------------------------------------------
setlocal
set "PREFIX=%USERPROFILE%\miniforge3"
if not exist "%PREFIX%\Scripts\activate.bat" (
    echo ERROR: Miniforge not found at %PREFIX%
    exit /b 1
)
call "%PREFIX%\Scripts\activate.bat" "%PREFIX%"

call conda create -y -n jlite -c conda-forge python=3.12 pip
if errorlevel 1 exit /b 1
call conda activate jlite
python -m pip install -r "%~dp0requirements.txt"
if errorlevel 1 exit /b 1

echo.
echo Env 'jlite' ready. Next: build.cmd, then serve.cmd
endlocal
