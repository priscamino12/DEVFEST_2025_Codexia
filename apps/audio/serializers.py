# apps/audio/serializers.py
from rest_framework import serializers
from .models import AudioScan

class AudioScanSerializer(serializers.ModelSerializer):
    """
    Utilisé pour renvoyer les données au client (JSON) après analyse.
    """
    class Meta:
        model = AudioScan
        fields = [
            'id', 
            'file', 
            'original_filename', 
            'is_deepfake', 
            'confidence_score', 
            'transcription', 
            'duration_seconds', 
            'uploaded_at'
        ]
        # On définit explicitement tout en lecture seule pour protéger l'intégrité des résultats
        read_only_fields = [
            'id', 
            'file', 
            'original_filename', 
            'is_deepfake', 
            'confidence_score', 
            'transcription', 
            'duration_seconds', 
            'uploaded_at'
        ]

class AudioUploadSerializer(serializers.Serializer):
    """
    Utilisé uniquement pour valider le fichier entrant (Input).
    """
    # Le nom 'file' correspond à la clé dans le curl (-F "file=@...")
    file = serializers.FileField()

    def validate_file(self, value):
        """Vérifie l'extension et la taille du fichier"""
        allowed_extensions = ["wav", "mp3", "flac", "ogg", "m4a"]
        
        # 1. Vérification extension
        try:
            # On prend le dernier élément après le point
            ext = value.name.split(".")[-1].lower()
        except IndexError:
            raise serializers.ValidationError("Le fichier n'a pas d'extension.")

        if ext not in allowed_extensions:
            raise serializers.ValidationError(f"Format '{ext}' non supporté. Formats acceptés: {', '.join(allowed_extensions)}")

        # 2. Vérification taille (Max 10MB)
        limit_mb = 10
        if value.size > limit_mb * 1024 * 1024:
            raise serializers.ValidationError(f"Fichier trop volumineux. Max {limit_mb}MB.")

        return value
