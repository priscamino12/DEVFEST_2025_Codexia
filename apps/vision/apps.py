from django.apps import AppConfig


class VisionConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    # IMPORTANT : Le chemin complet vers l'app
    name = "apps.vision" 
    verbose_name = "Vision & Deepfake Detection"
