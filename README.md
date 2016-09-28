> **NOTE:** This plugin is **DEPRECATED** since Taiga 3.0.0 (2016-10-02) because it was included in the core of Taiga.

Taiga contrib gogs
==================

![Kaleidos Project](http://kaleidos.net/static/img/badge.png "Kaleidos Project")
[![Managed with Taiga.io](https://taiga.io/media/support/attachments/article-22/banner-gh.png)](https://taiga.io "Managed with Taiga.io")

The Taiga plugin for gogs integration.

Installation
------------
### Production env

#### Taiga Back

In your Taiga back python virtualenv install the pip package `taiga-contrib-gogs` with:

```bash
  pip install taiga-contrib-gogs
```

Modify in `taiga-back` your `settings/local.py` and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_gogs"]
  PROJECT_MODULES_CONFIGURATORS["gogs"] = "taiga_contrib_gogs.services.get_or_generate_config"
```

The run the migrations to generate the new need table:

```bash
  python manage.py migrate taiga_contrib_gogs
```

#### Taiga Front

Download in your `dist/plugins/` directory of Taiga front the `taiga-contrib-gogs` compiled code (you need subversion in your system):

```bash
  cd dist/
  mkdir -p plugins
  cd plugins
  svn export "https://github.com/taigaio/taiga-contrib-gogs/tags/$(pip show taiga-contrib-gogs | awk '/^Version: /{print $2}')/front/dist" "gogs"
```

Include in 'dist/conf.json' in the 'contribPlugins' list the value `"/plugins/gogs/gogs.json"`:

```json
...
    "contribPlugins": [
        (...)
        "/plugins/gogs/gogs.json"
    ]
...
```

### Dev env

#### Taiga Back

Clone the repo and

```bash
  cd taiga-contrib-gogs/back
  workon taiga
  pip install -e .
```

Modify in `taiga-back` your `settings/local.py` and include the line:

```python
  INSTALLED_APPS += ["taiga_contrib_gogs"]
  PROJECT_MODULES_CONFIGURATORS["gogs"] = "taiga_contrib_gogs.services.get_or_generate_config"
```

The run the migrations to generate the new need table:

```bash
  python manage.py migrate taiga_contrib_gogs
```

#### Taiga Front

After clone the repo link `dist` in `taiga-front` plugins directory:

```bash
  cd taiga-front/dist
  mkdir -p plugins
  cd plugins
  ln -s ../../../taiga-contrib-gogs/dist gogs
```

Include in 'dist/conf.json' in the 'contribPlugins' list the value `"/plugins/gogs/gogs.json"`:

```json
...
    "contribPlugins": [
        (...)
        "/plugins/gogs/gogs.json"
    ]
...
```

In the plugin source dir `taiga-contrib-gogs/front` run

```bash
npm install
```
and use:

- `gulp` to regenerate the source and watch for changes.
- `gulp build` to only regenerate the source.

