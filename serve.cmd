@echo off
REM Serve the built site on http://127.0.0.1:8000/ (Ctrl+C to stop).
REM Runs serve_dist.cmd (python http.server, see serve_dist.py): it redirects /tree to
REM /tree/ like GitHub Pages, so File > Open works. "jupyter lite serve" answers 403 there.
REM A port can be given as the first argument.
call "%~dp0serve_dist.cmd" %*
