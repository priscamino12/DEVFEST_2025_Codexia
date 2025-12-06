# from .base import *

# DEBUG = True

# codexia_backend/settings/dev.py
from .base import *

# En dev on permet d'activer DEBUG via l'env (.env)
DEBUG = os.getenv("DEBUG", "True").lower() in ("1", "true", "yes")

# Autoriser les hosts de dev
ALLOWED_HOSTS = os.getenv("DJANGO_ALLOWED_HOSTS", "127.0.0.1,localhost").split(",")
