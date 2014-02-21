import os
import sys
import site

parent = os.path.dirname
site_dir = parent(os.path.abspath(__file__))
project_dir = parent(parent(os.path.abspath(__file__)))

sys.path.insert(0, project_dir)
sys.path.insert(0, site_dir)

site.addsitedir('VIRTUALENV_SITE_PACKAGES')

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler()

from werkzeug.debug import DebuggedApplication
application = DebuggedApplication(application, evalex=True)

def null_technical_500_response(request, exc_type, exc_value, tb):
    raise exc_type, exc_value, tb
from django.views import debug
debug.technical_500_response = null_technical_500_response
