# apps/audio/views.py (complément)
import os
import tempfile
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser

from .serializers import AudioUploadSerializer
from .inference import analyze_audio

class AudioAnalysisView(APIView):
    # Indispensable pour gérer l'upload de fichiers
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        serializer = AudioUploadSerializer(data=request.data)

        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        uploaded_file = serializer.validated_data["file"]

        # 1. Sauvegarde temporaire du fichier sur le disque
        # (Nécessaire car torchaudio lit depuis un chemin fichier, pas depuis la RAM directement)
        suffix = os.path.splitext(uploaded_file.name)[1]
        with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
            for chunk in uploaded_file.chunks():
                tmp.write(chunk)
            tmp_path = tmp.name

        try:
            # 2. Appel au moteur IA
            result = analyze_audio(tmp_path)
            
            # 3. Réponse succès
            return Response(result, status=status.HTTP_200_OK)

        except Exception as e:
            return Response(
                {"error": "Erreur lors de l'analyse audio", "details": str(e)}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
        finally:
            # 4. Nettoyage : On supprime toujours le fichier temporaire
            if os.path.exists(tmp_path):
                os.remove(tmp_path)
