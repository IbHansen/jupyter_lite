"""Install ModelFlow into this browser session (JupyterLite / Pyodide).

Needed in every notebook, and again after every reload. First cell of a notebook, which
does nothing outside the browser, so the same notebook also runs in ordinary Jupyter:

    import sys
    if sys.platform == 'emscripten':  # only in the browser (JupyterLite); see mfsetup.py
        %run mfsetup.py
        await install_modelflow()                  # or: install_modelflow('some_package')

``%run`` is used rather than ``import`` because the notebook folder is not on the
kernel's import path.

From modelflowib 2.81 the wheel itself knows which of its dependencies a browser can
have: the desktop-only ones (numba, cvxopt, dash, the jupyter metapackage, ...) are
marked ``sys_platform != 'emscripten'`` in its pyproject, so micropip leaves them out.
Nothing has to be listed here, and ModelFlow needs no patching afterwards.
"""
import sys


async def install_modelflow(*extra):
    """Install ModelFlow and its dependencies; ``extra`` are more packages to install."""
    if sys.platform != 'emscripten':
        return  # ordinary Python: ModelFlow is installed the normal way
    import piplite

    await piplite.install(['modelflowib', *extra])
