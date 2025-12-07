# apps/audio/inference.py
import os
import requests
import json

ML_API_URL = os.getenv("AUDIO_ML_API_URL", "http://34.63.213.198:8080/predict")

def analyze_audio(file_path: str) -> dict:
    print(f"📡 [Inference] Envoi vers {ML_API_URL}...")
    
    try:
        with open(file_path, 'rb') as f:
            # Note: Assure-toi que la clé 'audio' est bien ce que le serveur attend
            # Parfois c'est 'file', parfois 'audio'.
            response = requests.post(ML_API_URL, files={'audio': f}, timeout=30)

        response.raise_for_status()
        data = response.json()
        
        # --- DEBUG CRUCIAL ---
        # Regarde ce print dans ton terminal Django quand tu fais la requête !
        print(f"🔍 [DEBUG RAW JSON] Le serveur a répondu : {json.dumps(data, indent=2)}") 
        # ---------------------

        # 1. Extraction du Score (Confiance)
        # On cherche toutes les clés possibles
        confidence = 0.0
        possible_score_keys = ['confidence', 'score', 'probability', 'prob', 'fake_prob']
        
        for key in possible_score_keys:
            if key in data:
                confidence = float(data[key])
                break
        
        # 2. Décision Deepfake
        is_deepfake = False
        
        # Logique A : Basée sur un label textuel
        if 'class' in data or 'prediction' in data or 'label' in data:
            label = str(data.get('class') or data.get('prediction') or data.get('label')).lower()
            # 'spoof' = deepfake, 'bonafide' = réel (standard ASVspoof)
            if label in ['fake', 'spoof', 'generated', 'deepfake', '1']:
                is_deepfake = True
            elif label in ['real', 'bonafide', 'original', '0']:
                is_deepfake = False
        
        # Logique B : Basée sur le score si pas de label
        # Attention : Parfois 1.0 veut dire "Réel", parfois "Fake".
        # On suppose ici que le score est une probabilité d'être FAKE.
        elif confidence > 0.5:
            is_deepfake = True

        # 3. Transcription & Durée
        transcription = data.get("transcription", data.get("text", "Non disponible"))
        duration = data.get("duration", data.get("length", 0.0))

        return {
            "status": "success",
            "transcription": transcription,
            "confidence_score": round(confidence, 4),
            "duration_seconds": round(float(duration), 2),
            "is_deepfake": is_deepfake
        }

    except Exception as e:
        print(f"❌ Erreur API ML : {e}")
        raise e
