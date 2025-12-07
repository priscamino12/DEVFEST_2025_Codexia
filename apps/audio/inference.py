# apps/audio/inference.py
import os
import requests
import json
from django.conf import settings

# --- CONFIGURATION ---
# On récupère l'URL de l'API ML (Google Cloud) depuis le .env ou on met celle par défaut
ML_API_URL = os.getenv("AUDIO_ML_API_URL", "http://34.63.213.198:8080/predict")

def analyze_audio(file_path: str) -> dict:
    """
    Envoie le fichier audio au serveur ML externe pour analyse.
    
    Cette fonction remplace l'ancien moteur PyTorch local.
    Elle conserve la même signature (input/output) pour ne pas casser views.py.
    """
    print(f"📡 [Inference] Envoi du fichier {os.path.basename(file_path)} vers {ML_API_URL}...")
    
    try:
        # 1. Préparation de la requête
        # On ouvre le fichier en mode binaire ('rb')
        with open(file_path, 'rb') as f:
            # La clé 'audio' est celle attendue par ton API Flask/FastAPI sur GCP
            files = {'audio': f} 
            
            # 2. Envoi (POST) avec un timeout de 30 secondes
            response = requests.post(ML_API_URL, files=files, timeout=30)

        # 3. Vérification des erreurs HTTP (404, 500, etc.)
        response.raise_for_status()

        # 4. Lecture de la réponse JSON
        data = response.json()
        print(f"✅ [Inference] Réponse reçue : {data}")

        # --- MAPPING (Fusion des logiques) ---
        # On doit transformer la réponse de l'API externe pour qu'elle corresponde
        # à ce que ton backend Django attend (comme l'ancien code PyTorch).
        
        # A. Score de confiance
        # L'API peut renvoyer 'probability', 'score' ou 'confidence'
        raw_score = data.get('probability', data.get('score', data.get('confidence', 0.0)))
        confidence = float(raw_score)

        # B. Décision Deepfake
        # Logique hybride : Si l'API le dit explicitement OU si le score est très élevé
        is_deepfake = False
        if 'class' in data:
            label = str(data['class']).lower()
            if label in ['fake', 'spoof', 'deepfake']:
                is_deepfake = True
        
        # Si pas de classe, on se base sur le seuil (ex: > 0.5 = Fake)
        if confidence > 0.5:
            is_deepfake = True

        # C. Durée et Transcription
        # L'API externe ne renvoie peut-être pas la transcription ou la durée.
        # On utilise .get() avec une valeur par défaut pour ne pas planter.
        transcription = data.get("transcription", "Transcription non disponible via API distante")
        duration = data.get("duration", 0.0) 

        # 5. Retour au format exact attendu par views.py
        return {
            "status": "success",
            "transcription": transcription,
            "confidence_score": round(confidence, 4),
            "duration_seconds": round(float(duration), 2),
            "is_deepfake": is_deepfake
        }

    except requests.exceptions.ConnectionError:
        print("❌ [Inference] Impossible de contacter le serveur ML.")
        raise Exception("Le serveur d'analyse IA est injoignable.")
        
    except requests.exceptions.Timeout:
        print("❌ [Inference] Le serveur ML met trop de temps à répondre.")
        raise Exception("Timeout lors de l'analyse IA.")

    except Exception as e:
        print(f"❌ [Inference] Erreur inattendue : {e}")
        # On propage l'erreur pour que la View la gère (et supprime le fichier de la DB)
        raise e
