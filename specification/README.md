This document can be compiled using

```
make html
```
or
```
make latex
```

The compilation requires [uv](https://docs.astral.sh/uv/) for managing Python
dependencies. Install `uv` following the instructions at
https://docs.astral.sh/uv/getting-started/installation/, then run `make html` or
`make latex`. Dependencies are resolved automatically and cached in `~/.cache/uv`
(or the directory specified by `UV_CACHE_DIR`); no virtual environment is created
in the project directory.

To install `uv` on Linux or macOS:

```
curl -LsSf https://astral.sh/uv/install.sh | sh
```

or via pip:

```
pip install uv
```
