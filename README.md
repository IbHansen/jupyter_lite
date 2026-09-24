# ModelFlow Lite

ModelFlow in the browser with [JupyterLite](https://jupyterlite.readthedocs.io):
Python runs inside the browser (Pyodide, Python 3.14), so nothing has to be
installed. The folder is a ready GitHub repository: GitHub Actions builds the
site and publishes it on GitHub Pages.

## Local experiments (Windows, Miniforge)

| Step | Command | Does |
|---|---|---|
| once | `setup_env.cmd` | creates the conda env `jlite` with the build tools from `requirements.txt` |
| after every change | `build.cmd` | builds the site from `content\` into `dist\` |
| to try it | `serve.cmd` | serves `dist\` on <http://127.0.0.1:8000/> and opens `start.ipynb` |
| optional | `add_local_modelflow.cmd` | puts a wheel of your local modelflow source into `pypi\`, used instead of PyPI's |

`serve.cmd` opens the browser right away; if the page is not there yet, reload it
once the server is running.

## What is where

| Path | Purpose |
|---|---|
| `content/` | notebooks and data files that appear in the site |
| `content/start.ipynb` | installs ModelFlow in the browser and runs a tiny model |
| `content/mfsetup.py` | `install_modelflow()`: the install step every notebook starts with |
| `requirements.txt` | build tools and widget front-ends (not installed in the browser) |
| `jupyter_lite_config.json` | build settings: `content` → `dist` |
| `jupyter-lite.json` | settings of the running site |
| `overrides/index.html` | front page: opens `start.ipynb` in the Notebook interface (copied over `dist/index.html` after the build) |
| `pypi/` | optional local wheels, offered to `%pip install` before PyPI |
| `.github/workflows/deploy.yml` | GitHub Actions: build and publish on GitHub Pages |

## ModelFlow in the browser

Each notebook starts by installing ModelFlow into the browser session (again after
every reload), with the helper in `content/mfsetup.py`:

```python
import sys
if sys.platform == 'emscripten':  # only in the browser (JupyterLite): install ModelFlow, see mfsetup.py
    %run mfsetup.py
    await install_modelflow()     # extra packages as arguments, e.g. install_modelflow('shiny')
```

Outside the browser the cell does nothing, so the same notebooks also run in ordinary
Jupyter (desktop, Codespaces). The notebooks keep the standard `python3` kernel name;
`jupyter-lite.json` makes JupyterLite start its own Python kernel for them without asking.

`install_modelflow` installs `modelflowib` with its dependencies. From version 2.81 the
wheel knows which of them a browser can have — the desktop-only ones are marked
`sys_platform != 'emscripten'` in its pyproject — so the helper lists no packages of its
own and ModelFlow needs no patching afterwards. `%run` is used instead of `import`
because the notebook folder is not on the kernel's import path. Not available in the
browser:

- **numba**: models run without JIT compilation (slower for big models).
- **cvxopt**: the optimisation functions in the model language.
- **Graphviz** (`dot`): graphs are drawn with networkx and ModelFlow's own SVG engine
  instead, so `.draw()` and the other drawings work.
- **Dash**: the `.dash()` dashboard needs a web server.
- **URLs** in `model.modelload(...)`: put the `.pcim` file in `content/` and load it by name.

## Your edits and new versions

JupyterLite keeps a copy of every notebook you open (and save) in your browser,
and that copy hides the version on the site. The GitHub build therefore gives each
deployment its own browser storage: after a new deployment you see the new
notebooks, and edits made under the previous deployment are no longer shown.
Download notebooks you want to keep (**File → Download**).

Locally (`serve.cmd`) there is no such reset: use **Help → Clear Browser Data** in
JupyterLab (`…/lab/`), or a private browser window.

## Publishing on GitHub

1. Create a repository from this folder (GitHub Desktop: *Add local repository* →
   *create a repository* → *Publish*).
2. On github.com: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. Every push to `main` rebuilds the site. It appears at
   `https://<user>.github.io/<repo>/` and opens `start.ipynb` in the Notebook
   interface. The file list is at `…/tree/`, JupyterLab at `…/lab/`.
