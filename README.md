Taiga contrib gogs
==================

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

Download in your `dist/js/` directory of Taiga front the `taiga-contrib-gogs` compiled code:

```bash
  cd dist/js
  wget "https://raw.githubusercontent.com/taigaio/taiga-contrib-gogs/stable/front/dist/gogs.js"
```

Include the file in the `dist/index.html` file between the `libs.js` and `apps.js` with this line:

```html
  <script src="/js/gogs.js"></script>
```
