# from django.shortcuts import render

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from django.conf import settings
import os

from .serializers import VisionScanSerializer
from .inference import analyze_image

class VisionAnalysisView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        # 1. Validation et Sauvegarde de l'image (Upload)
        serializer = VisionScanSerializer(data=request.data)
        
        if serializer.is_valid():
            # save() écrit l'image sur le disque et crée la ligne en BDD
            scan_instance = serializer.save() 
            
            # 2. Récupération du chemin absolu du fichier
            # scan_instance.image.path donne le chemin complet sur le disque
            file_path = scan_instance.image.path
            
            try:
                # 3. Appel au moteur IA
                result = analyze_image(file_path)
                
                # 4. Mise à jour des résultats en base
                scan_instance.is_deepfake = result['is_deepfake']
                scan_instance.confidence_score = result['confidence_score']
                scan_instance.processing_time = result['processing_time']
                scan_instance.save()
                
                # 5. Retourne l'objet mis à jour (avec le score)
                return Response(VisionScanSerializer(scan_instance).data, status=status.HTTP_201_CREATED)

            except Exception as e:
                return Response(
                    {"error": "Erreur durant l'analyse IA", "details": str(e)}, 
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR
                )
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
