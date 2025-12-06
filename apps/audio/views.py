"""
# apps/audio/views.py
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import AudioUploadSerializer
from .inference import analyze_audio
from apps.notifications.models import Notification
from django.core.files.storage import default_storage

class AudioUploadView(APIView):
    def post(self, request):
        serializer = AudioUploadSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        f = serializer.validated_data["file"]
        path = default_storage.save(f"uploads/audio/{f.name}", f)
        fullpath = default_storage.path(path) if hasattr(default_storage, "path") else path
        result = analyze_audio(fullpath)
        # create notification example
        Notification.objects.create(
            title="Audio analysé",
            message=f"Fichier {f.name} analysé. score={result['deepfake_score']}"
        )
        return Response(result, status=status.HTTP_200_OK)
"""
# apps/audio/views.py (complément)
import os
import tempfile
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from .serializers import AudioUploadSerializer
from .inference import analyze_audio


class AudioUploadView(APIView):

    def post(self, request, *args, **kwargs):
        serializer = AudioUploadSerializer(data=request.data)

        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        audio_file = serializer.validated_data["audio"]

        # save tmp file
        with tempfile.NamedTemporaryFile(delete=False, suffix=os.path.splitext(audio_file.name)[1]) as tmp:
            for chunk in audio_file.chunks():
                tmp.write(chunk)
            tmp_path = tmp.name

        try:
            result = analyze_audio(tmp_path)
        except Exception as e:
            return Response({"error": str(e)}, status=500)
        finally:
            if os.path.exists(tmp_path):
                os.remove(tmp_path)

        return Response(result, status=200)
