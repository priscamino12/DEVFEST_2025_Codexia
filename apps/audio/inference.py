# apps/audio/inference.py
import torch
import torchaudio
from transformers import Wav2Vec2Processor, Wav2Vec2ForCTC
import numpy as np

# --- CHARGEMENT DU MODÈLE (Au démarrage) ---
print("Chargement du modèle Wav2Vec2...")
try:
    PROCESSOR = Wav2Vec2Processor.from_pretrained("facebook/wav2vec2-base-960h")
    MODEL = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-base-960h")
    MODEL.eval()
    print("Modèle chargé avec succès.")
except Exception as e:
    print(f"FATAL ERROR lors du chargement du modèle : {e}")

def load_and_preprocess_audio(file_path: str, target_sr: int = 16000):
    """
    Charge un fichier audio, convertit en Mono et Resample à 16kHz.
    """
    # torchaudio gère automatiquement wav, mp3, flac via ffmpeg
    waveform, sample_rate = torchaudio.load(file_path)

    # 1. Conversion Stéréo -> Mono (si nécessaire)
    if waveform.shape[0] > 1:
        waveform = torch.mean(waveform, dim=0, keepdim=True)

    # 2. Resampling vers 16000Hz (requis par Wav2Vec2)
    if sample_rate != target_sr:
        resampler = torchaudio.transforms.Resample(orig_freq=sample_rate, new_freq=target_sr)
        waveform = resampler(waveform)

    # On retire la dimension du channel pour avoir un tenseur (N_samples,)
    return waveform.squeeze()

def analyze_audio(file_path: str) -> dict:
    """
    Exécute le pipeline complet : Load -> Transcribe -> Score
    """
    try:
        # A. Préparation
        waveform = load_and_preprocess_audio(file_path)
        
        # Sécurité : Si l'audio est trop court (< 0.1s), on rejette
        if waveform.numel() < 1600: 
             return {"error": "Audio trop court", "status": "failed"}

        duration = len(waveform) / 16000

        # B. Tokenization (Conversion audio -> format modèle)
        inputs = PROCESSOR(
            waveform, 
            sampling_rate=16000, 
            return_tensors="pt", 
            padding=True
        )

        # C. Inférence
        with torch.no_grad():
            logits = MODEL(inputs.input_values).logits

        # D. Décodage (Logits -> Texte)
        predicted_ids = torch.argmax(logits, dim=-1)
        transcription = PROCESSOR.batch_decode(predicted_ids)[0]

        # E. Calcul de confiance (CORRIGÉ)
        probs = torch.nn.functional.softmax(logits, dim=-1)
        
        # On récupère la probabilité maximale pour chaque pas de temps (frame)
        # dim=-1 est CRUCIAL pour avoir un tuple (values, indices)
        max_probs, _ = torch.max(probs, dim=-1) 
        
        # On fait la moyenne de ces probabilités maximales
        confidence = float(max_probs.mean().item())

        return {
            "status": "success",
            "transcription": transcription,
            "confidence_score": round(confidence, 4),
            "duration_seconds": round(duration, 2),
            "is_deepfake": False # Placeholder logique
        }

    except Exception as e:
        # On print l'erreur complète dans le terminal serveur pour débugger
        import traceback
        traceback.print_exc()
        raise e
