# apps/notifications/models.py
from django.db import models

class Notification(models.Model):
    # Titre court de la notification (ex: "Audio analysé")
    title = models.CharField(max_length=200)
    # Message détaillé (ex: "Fichier X analysé. score=0.5")
    message = models.TextField()
    # Date/heure de création (automatique)
    created_at = models.DateTimeField(auto_now_add=True)
    # Indique si la notification a été lue
    read = models.BooleanField(default=False)

    class Meta:
        # Ordre par défaut si aucune ordering n'est donnée dans la vue
        ordering = ["-created_at"]
        # Nom lisible au pluriel/singulier
        verbose_name = "Notification"
        verbose_name_plural = "Notifications"

    def __str__(self):
        # Représentation lisible dans l'admin et les logs
        return f"{self.title} - {self.created_at.isoformat()}"
