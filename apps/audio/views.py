# apps/audio/views.py
import hashlib
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from django.conf import settings

# On importe les modèles et LES DEUX serializers
from .models import AudioScan
from .serializers import AudioScanSerializer, AudioUploadSerializer
from .inference import analyze_audio

class AudioAnalysisView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def calculate_file_hash(self, file_obj):
        """Calcule le SHA256 du fichier pour identification unique"""
        sha256 = hashlib.sha256()
        for chunk in file_obj.chunks():
            sha256.update(chunk)
        return sha256.hexdigest()

    def post(self, request, *args, **kwargs):
        # 1. VALIDATION via le Serializer (Plus propre et sécurisé)
        upload_serializer = AudioUploadSerializer(data=request.data)
        
        if not upload_serializer.is_valid():
            return Response(upload_serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        # On récupère le fichier validé proprement
        uploaded_file = upload_serializer.validated_data['file']
        
        # 2. Calcul du Hash (Signature unique du contenu)
        file_hash = self.calculate_file_hash(uploaded_file)

        # 3. VÉRIFICATION DOUBLON (Cache)
        # Si le fichier exact existe déjà, on renvoie le résultat stocké sans relancer l'IA
        existing_scan = AudioScan.objects.filter(file_hash=file_hash).first()
        if existing_scan:
            serializer = AudioScanSerializer(existing_scan)
            return Response({
                "status": "cached", # Indique que c'est un résultat récupéré
                "data": serializer.data
            }, status=status.HTTP_200_OK)

        # 4. Si nouveau contenu : Création de l'objet (mais pas encore l'IA)
        # Note : Si le nom existe mais le hash est différent, Django renomme le fichier auto.
        scan = AudioScan(
            file=uploaded_file,
            file_hash=file_hash,
            original_filename=uploaded_file.name,
            file_size=uploaded_file.size
        )
        scan.save() # Sauvegarde physique dans media/audios/

        # 5. Lancement de l'IA
        try:
            # On passe le chemin absolu du fichier enregistré
            file_path = scan.file.path
            
            # Appel à ton inference.py
            analysis_result = analyze_audio(file_path)

            # Mise à jour des résultats
            scan.transcription = analysis_result.get("transcription", "")
            scan.confidence_score = analysis_result.get("confidence_score", 0.0)
            scan.duration_seconds = analysis_result.get("duration_seconds", 0.0)
            
            # Logique métier Deepfake (Placeholder à adapter)
            scan.is_deepfake = False 
            
            scan.save()

            return Response({
                "status": "processed",
                "data": AudioScanSerializer(scan).data
            }, status=status.HTTP_201_CREATED)

        except Exception as e:
            # En cas d'erreur IA, on supprime l'entrée DB pour éviter les données corrompues
            scan.delete()
            return Response(
                {"error": "Erreur analyse IA", "details": str(e)}, 
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
