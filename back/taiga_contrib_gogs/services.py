# Copyright (C) 2014-2016 Andrey Antukh <niwi@niwi.nz>
# Copyright (C) 2014-2016 Jesús Espino <jespinog@gmail.com>
# Copyright (C) 2014-2016 David Barragán <bameda@dbarragan.com>
# Copyright (C) 2014-2016 Alejandro Alonso <alejandro.alonso@kaleidos.net>
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import uuid

from django.core.urlresolvers import reverse

from taiga.users.models import User
from taiga.base.utils.urls import get_absolute_url


# Set this in settings.PROJECT_MODULES_CONFIGURATORS["gogs"]
def get_or_generate_config(project):
    config = project.modules_config.config
    if config and "gogs" in config:
        g_config = project.modules_config.config["gogs"]
    else:
        g_config = {"secret": uuid.uuid4().hex}

    url = reverse("gogs-hook-list")
    url = get_absolute_url(url)
    url = "%s?project=%s" % (url, project.id)
    g_config["webhooks_url"] = url
    return g_config
