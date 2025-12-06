# codexia_backend/settings/__init__.py
"""
Sélectionne automatiquement les settings à charger.
Utilisation :
  - export DJANGO_ENV=dev   (ou mettre dans .env)
  - export DJANGO_ENV=prod
Si non défini, on charge 'dev' par défaut (pratique pour le dev local/hackathon).
"""

import os

env = os.getenv("DJANGO_ENV", "dev").lower()
if env == "prod":
    from .prod import *  # noqa: F401,F403
else:
    from .dev import *   # noqa: F401,F403
