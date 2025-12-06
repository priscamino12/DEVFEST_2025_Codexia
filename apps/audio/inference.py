"""
# apps/audio/inference.py
from transformers import Wav2Vec2Processor, Wav2Vec2ForCTC
import torch
import torchaudio

# Charge once
processor = Wav2Vec2Processor.from_pretrained("facebook/wav2vec2-base-960h")
model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-base-960h")
device = "cuda" if torch.cuda.is_available() else "cpu"
model.to(device)
model.eval()

def analyze_audio(path: str) -> dict:
    waveform, sr = torchaudio.load(path)
    if sr != 16000:
        waveform = torchaudio.functional.resample(waveform, sr, 16000)
    if waveform.ndim > 1:
        waveform = waveform.mean(dim=0)
    inputs = processor(waveform.numpy(), sampling_rate=16000, return_tensors="pt", padding=True)
    input_values = inputs.input_values.to(device)
    with torch.no_grad():
        logits = model(input_values).logits
    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)[0]
    # Placeholder deepfake score — remplacer par modèle spécialisé plus tard
    deepfake_score = 0.5
    return {"transcription": transcription, "deepfake_score": float(deepfake_score)}
"""
# apps/audio/inference.py (tel que fourni)
import torch
from torchcodec.decoders import FFmpegAudioDecoder
from transformers import Wav2Vec2Processor, Wav2Vec2ForCTC

# Chargement modèle une seule fois (performances)
processor = Wav2Vec2Processor.from_pretrained("facebook/wav2vec2-base-960h")
model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-base-960h")
model.eval()


def load_audio(file_path: str):
    """
    Décode un fichier audio avec FFmpegAudioDecoder (torchcodec).
    Retourne : waveform (Tensor), sample_rate (int)
    """
    decoder = FFmpegAudioDecoder(
        streams="0:a:0",
        format="fltp",
        sample_rate=16000,
        channels=1,
    )
    out = decoder.decode(file_path)

    # out["audio"] → Tensor (channels, samples)
    waveform = out["audio"].squeeze(0)  # (samples,)
    sample_rate = out["sample_rate"]

    return waveform, sample_rate


def transcribe_audio(waveform: torch.Tensor, sample_rate: int):
    """
    Transcrit une waveform 16kHz avec wav2vec2.
    """

    # Normalisation
    inputs = processor(
        waveform,
        sampling_rate=sample_rate,
        return_tensors="pt",
        padding=True
    )

    with torch.no_grad():
        logits = model(inputs.input_values).logits

    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)[0]

    return transcription


def compute_confidence(logits: torch.Tensor) -> float:
    """
    Calcule un score simple de confiance (softmax max).
    """

    probs = torch.softmax(logits, dim=-1)
    confidence = float(probs.max().item())
    return confidence


def analyze_audio(file_path: str) -> dict:
    """
    Lit, décode et analyse un fichier audio :
    - Décode via torchcodec
    - Transcription via wav2vec2
    - Calcule un score de confiance

    Retourne :
    {
        "transcription": str,
        "confidence": float,
        "sample_rate": int,
        "duration_sec": float
    }
    """

    waveform, sample_rate = load_audio(file_path)

    inputs = processor(
        waveform,
        sampling_rate=sample_rate,
        return_tensors="pt",
        padding=True
    )

    with torch.no_grad():
        logits = model(inputs.input_values).logits

    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)[0].strip()

    confidence = compute_confidence(logits)

    duration_sec = waveform.shape[0] / sample_rate

    return {
        "transcription": transcription,
        "confidence": confidence,
        "sample_rate": sample_rate,
        "duration_sec": duration_sec
    }

"""
import torch
from transformers import Wav2Vec2Processor, Wav2Vec2ForCTC
from torchcodec.decoders import AudioDecoder

# Initialisation modèle Wav2Vec2
processor = Wav2Vec2Processor.from_pretrained("facebook/wav2vec2-base-960h")
model = Wav2Vec2ForCTC.from_pretrained("facebook/wav2vec2-base-960h")
device = "cuda" if torch.cuda.is_available() else "cpu"
model.to(device)
model.eval()

def analyze_audio(path: str) -> dict:
    """
    Lit et analyse un fichier audio pour retourner transcription et score.
    """
    # Créer un décodeur pour ce fichier
    decoder = AudioDecoder(path, sample_rate=16000)
    waveform, sr = decoder.decode()

    # Convertir en mono si nécessaire
    if waveform.ndim > 1:
        waveform = waveform.mean(dim=0)

    # Préparer pour Wav2Vec2
    inputs = processor(
        waveform.numpy(), sampling_rate=sr, return_tensors="pt", padding=True
    )
    input_values = inputs.input_values.to(device)

    # Inférence
    with torch.no_grad():
        logits = model(input_values).logits

    predicted_ids = torch.argmax(logits, dim=-1)
    transcription = processor.batch_decode(predicted_ids)[0]

    # Score fictif
    fake_score = torch.rand(1).item()

    return {
        "transcription": transcription,
        "fake_score": fake_score
    }
"""

"""
import torchcodec.decoders as d
dir(d)
"""
