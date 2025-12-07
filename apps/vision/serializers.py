from rest_framework import serializers
from .models import VisionScan

class VisionScanSerializer(serializers.ModelSerializer):
    class Meta:
        model = VisionScan
        fields = ['id', 'image', 'uploaded_at', 'is_deepfake', 'confidence_score', 'processing_time']
        read_only_fields = ['id', 'uploaded_at', 'is_deepfake', 'confidence_score', 'processing_time']
