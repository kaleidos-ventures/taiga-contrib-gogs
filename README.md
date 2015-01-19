Taiga contrib gogs
==================

**WARNING:** Not usable yet, currently in development.

The Taiga plugin for gogs integration.

Installation
------------

### Taiga Back

In your Taiga back python virtualenv install the pip package `taiga-contrib-gogs` with:

```bash
  pip install taiga-contrib-gogs
```

Modify your settings/local.py and include the line:

```python
  INSTALLED_APPS += "taiga_contrib_gogs"
```

The run the migrations to generate the new need table:

```bash
  python manage.py migrate taiga_contrib_gogs
```

### Taiga Front

In your Taiga front directory install the bower package `taiga-contrib-gogs` with:

```bash
  bower install taiga-contrib-gogs
```

Configure your contrib packages in `????-ToDo-????`.

Recompile the taiga-front contrib code with:

```bash
  gulp contrib
```
