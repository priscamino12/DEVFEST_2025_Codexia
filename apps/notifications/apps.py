# apps/notifications/apps.py
from django.apps import AppConfig

class NotificationsConfig(AppConfig):
    # Champ auto par défaut pour les IDs (évite les warnings sur Django 3.2+)
    default_auto_field = "django.db.models.BigAutoField"

    # Chemin de l'app (doit correspondre à la structure de ton projet)
    name = "apps.notifications"

    # Nom lisible dans l'admin
    verbose_name = "Notifications"
