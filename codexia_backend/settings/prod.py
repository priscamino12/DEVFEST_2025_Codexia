# from .base import *

# DEBUG = False
# ALLOWED_HOSTS = ["your-domain.com", "34.xxx.xxx.xxx"]

# codexia_backend/settings/prod.py
from .base import *

# En production on force False (sécurité)
DEBUG = False

# Remplace par ton domaine / IP prod
ALLOWED_HOSTS = os.getenv("DJANGO_ALLOWED_HOSTS", "your-domain.com").split(",")
