# apps/audio/serializers.py
from rest_framework import serializers

class AudioUploadSerializer(serializers.Serializer):
    # Le nom 'file' ici correspondra à la clé dans le curl (-F "file=@...")
    file = serializers.FileField()

    def validate_file(self, value):
        """Vérifie l'extension et la taille du fichier"""
        allowed_extensions = ["wav", "mp3", "flac", "ogg", "m4a"]
        
        # Vérification extension
        ext = value.name.split(".")[-1].lower()
        if ext not in allowed_extensions:
            raise serializers.ValidationError(f"Format '{ext}' non supporté. Formats acceptés: {allowed_extensions}")

        # Vérification taille (Optionnel, ex: max 10MB)
        if value.size > 10 * 1024 * 1024:
            raise serializers.ValidationError("Fichier trop volumineux (Max 10MB).")

        return value
