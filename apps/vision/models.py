from django.db import models

class VisionScan(models.Model):
    # L'image sera stockée dans /media/images/
    image = models.ImageField(upload_to='images/')
    
    # Métadonnées
    uploaded_at = models.DateTimeField(auto_now_add=True)
    
    # Résultats de l'analyse (remplis après l'upload)
    is_deepfake = models.BooleanField(null=True, blank=True)
    confidence_score = models.FloatField(null=True, blank=True) # Score entre 0.0 et 1.0
    processing_time = models.FloatField(null=True, blank=True)

    class Meta:
        db_table = 'vision_scans'
        ordering = ['-uploaded_at']

    def __str__(self):
        return f"Scan {self.id} - {self.uploaded_at}"
