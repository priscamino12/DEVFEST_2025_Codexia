# # apps/audio/apps.py
from django.apps import AppConfig

class AudioConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "apps.audio" # Assure-toi que le dossier s'appelle bien 'apps' et contient 'audio'
    verbose_name = "Audio Analysis"
