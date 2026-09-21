"""Install ModelFlow into this browser session (JupyterLite / Pyodide).

Needed in every notebook, and again after every reload. First cell of a notebook, which
does nothing outside the browser, so the same notebook also runs in ordinary Jupyter:

    import sys
    if sys.platform == 'emscripten':  # only in the browser (JupyterLite); see mfsetup.py
        %run mfsetup.py
        await install_modelflow()                  # or: install_modelflow('statsmodels', 'lmfit')

``%run`` is used rather than ``import`` because the notebook folder is not on the
kernel's import path.
"""
import sys
import types

# Packages ModelFlow imports. numba, cvxopt and dash are not available in the browser;
# ModelFlow runs without them.
PACKAGES = ['numpy', 'pandas', 'scipy', 'matplotlib', 'sympy', 'networkx', 'tqdm',
            'seaborn', 'openpyxl', 'jinja2', 'ipywidgets', 'ipydatagrid']


def _nojit(*args, **kwargs):
    """Stand-in for numba.jit/njit: returns the function uncompiled."""
    if len(args) == 1 and callable(args[0]) and not kwargs:
        return args[0]
    return lambda f: f


async def install_modelflow(*extra):
    """Install ModelFlow and the packages it needs; ``extra`` are more packages to install."""
    if sys.platform != 'emscripten':
        return  # ordinary Python: ModelFlow is installed the normal way
    import piplite

    await piplite.install(PACKAGES + list(extra))
    # ModelFlow itself, without its desktop-only dependencies
    await piplite.install('modelflowib', deps=False)

    # numba does not exist in the browser. ModelFlow 2.78's generated solver code imports it
    # even when nothing is compiled, so give it a stand-in that leaves functions uncompiled.
    sys.modules.setdefault('numba', types.SimpleNamespace(jit=_nojit, njit=_nojit))

    # the browser has no threads: stop tqdm from trying to start its monitor thread
    import tqdm
    tqdm.tqdm.monitor_interval = 0
