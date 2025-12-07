# apps/audio/inference.py
import os
import requests
import json

ML_API_URL = os.getenv("AUDIO_ML_API_URL", "http://34.63.213.198:8080/predict")

def analyze_audio(file_path: str) -> dict:
    print(f"📡 [Inference] Envoi vers {ML_API_URL}...")
    
    try:
        with open(file_path, 'rb') as f:
            # MODIFICATION ICI : On passe à 120 secondes (2 minutes)
            response = requests.post(ML_API_URL, files={'audio': f}, timeout=120)

        response.raise_for_status()
        data = response.json()
        
        print(f"✅ Réponse brute API : {data}")

        # --- MAPPING EXACT (Conservé de l'étape précédente) ---
        
        # 1. Score
        confidence = float(data.get("deepfake_prob", 0.0))

        # 2. Verdict
        prediction_label = data.get("prediction", "bonafide")
        is_deepfake = (prediction_label == "deepfake")

        # 3. Métadonnées
        transcription = "Transcription non fournie par le modèle"
        duration = 0.0 

        result = {
            "status": "success",
            "transcription": transcription,
            "confidence_score": round(confidence, 4),
            "duration_seconds": duration,
            "is_deepfake": is_deepfake
        }
        
        print(f"🚀 Résultat formaté pour DB : {result}")
        return result

    except requests.exceptions.Timeout:
        # On capture spécifiquement l'erreur de timeout pour l'afficher clairement
        print("❌ ERREUR : Le serveur IA est trop lent (Timeout > 120s)")
        raise Exception("Le serveur IA met trop de temps à répondre. Essayez un fichier plus court.")

    except Exception as e:
        print(f"❌ Erreur API ML : {e}")
        raise e
