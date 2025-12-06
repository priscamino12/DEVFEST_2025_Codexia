# apps/audio/urls.py
from django.urls import path
from .views import AudioAnalysisView

urlpatterns = [
    # Endpoint accessible via : POST /api/audio/
    path("", AudioAnalysisView.as_view(), name="audio-analysis"),
]
"""
curl -X POST \
  -F "file=@/home/mandresy/Téléchargements/file_example_WAV_1MG.wav" \
  http://127.0.0.1:8300/api/audio/
"""
