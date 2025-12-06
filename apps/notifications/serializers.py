# apps/notifications/serializers.py
from rest_framework import serializers
from .models import Notification

class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        # Tous les champs du modèle exposés par l’API
        fields = "__all__"
        # created_at ne doit pas être modifiable par l’API
        read_only_fields = ("created_at",)
