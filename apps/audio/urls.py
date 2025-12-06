"""
# apps/audio/urls.py
from django.urls import path
from .views import AudioUploadView

urlpatterns = [
    path("upload/", AudioUploadView.as_view(), name="audio-upload"),
]

# Run
python manage.py migrate
python manage.py runserver 127.0.0.1:8300

# Tests
curl -X POST "http://127.0.0.1:8300/api/audio/" \
  -F "file=@/chemin/vers/audio.wav"

curl -X POST "http://127.0.0.1:8300/api/audio/upload/" \
  -F "file=@/chemin/vers/audio.wav"

curl -X POST "http://127.0.0.1:8300/api/audio/text/" \
  -H "Content-Type: application/json" \
  -d '{"text":"Bonjour, ceci est un test."}'

"""

# apps/audio/urls.py
from django.urls import path
from .views import AudioAnalysisView

urlpatterns = [
    path("api/audio/", AudioAnalysisView.as_view(), name="audio-upload"),
]

