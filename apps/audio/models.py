# apps/audio/models.py
from django.db import models
import os

class AudioScan(models.Model):
    # Stockage physique dans /media/audios/
    # Django renomme automatiquement si le fichier existe déjà (ex: son.wav -> son_xYz.wav)
    file = models.FileField(upload_to='audios/')
    
    # Empreinte unique du fichier (pour détecter les doublons exacts)
    file_hash = models.CharField(max_length=64, unique=True, db_index=True)
    
    # Métadonnées
    original_filename = models.CharField(max_length=255)
    file_size = models.IntegerField(help_text="Taille en octets")
    uploaded_at = models.DateTimeField(auto_now_add=True)

    # Résultats IA
    is_deepfake = models.BooleanField(default=False)
    confidence_score = models.FloatField(null=True, blank=True)
    transcription = models.TextField(null=True, blank=True)
    duration_seconds = models.FloatField(null=True, blank=True)

    class Meta:
        db_table = 'audio_scans'
        ordering = ['-uploaded_at']

    def __str__(self):
        return f"{self.original_filename} ({self.confidence_score})"
