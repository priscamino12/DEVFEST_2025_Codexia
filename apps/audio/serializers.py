# apps/audio/serializers.py
from rest_framework import serializers


class AudioUploadSerializer(serializers.Serializer):
    audio = serializers.FileField()

    def validate_audio(self, value):

        allowed = ["wav", "mp3", "flac", "ogg", "m4a"]
        ext = value.name.split(".")[-1].lower()

        if ext not in allowed:
            raise serializers.ValidationError("Format audio non supporté.")

        return value


"""
from rest_framework import serializers

class AudioUploadSerializer(serializers.Serializer):
    # Champ pour uploader un fichier audio
    file = serializers.FileField()
"""
