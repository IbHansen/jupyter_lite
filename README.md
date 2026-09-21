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
| `requirements.txt` | build tools and widget front-ends (not installed in the browser) |
| `jupyter_lite_config.json` | build settings: `content` → `dist` |
| `jupyter-lite.json` | settings of the running site |
| `overrides/index.html` | front page: opens `start.ipynb` in the Notebook interface (copied over `dist/index.html` after the build) |
| `pypi/` | optional local wheels, offered to `%pip install` before PyPI |
| `.github/workflows/deploy.yml` | GitHub Actions: build and publish on GitHub Pages |

## ModelFlow in the browser

Each notebook first installs ModelFlow into the browser session:

```python
%pip install -q numpy pandas scipy matplotlib sympy networkx tqdm seaborn openpyxl ipywidgets ipydatagrid
%pip install -q --no-deps modelflowib
```

`--no-deps` skips ModelFlow's desktop-only dependencies. Not available in the browser:

- **numba**: models run without JIT compilation (slower for big models).
- **cvxopt**: the optimisation functions in the model language.
- **Graphviz** (`dot`): `.draw()` and other graph drawings.
- **Dash**: the `.dash()` dashboard needs a web server.
- **URLs** in `model.modelload(...)`: put the `.pcim` file in `content/` and load it by name.

## Publishing on GitHub

1. Create a repository from this folder (GitHub Desktop: *Add local repository* →
   *create a repository* → *Publish*).
2. On github.com: **Settings → Pages → Build and deployment → Source: GitHub Actions**.
3. Every push to `main` rebuilds the site. It appears at
   `https://<user>.github.io/<repo>/` and opens `start.ipynb` in the Notebook
   interface. The file list is at `…/tree/`, JupyterLab at `…/lab/`.
