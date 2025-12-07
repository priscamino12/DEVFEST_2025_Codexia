import time
import random

def analyze_image(image_path: str) -> dict:
    """
    Simule une analyse de deepfake sur une image.
    À remplacer par le vrai modèle PyTorch (EfficientNet, ResNet, etc.)
    """
    start_time = time.time()
    
    # --- ICI : Code de chargement du modèle et prédiction ---
    # ex: image = cv2.imread(image_path)
    # ex: pred = model(image)
    
    # Simulation d'un résultat
    is_fake = random.choice([True, False])
    score = random.uniform(0.5, 0.99) if is_fake else random.uniform(0.0, 0.49)
    
    duration = time.time() - start_time

    return {
        "is_deepfake": is_fake,
        "confidence_score": round(score, 4),
        "processing_time": round(duration, 3)
    }
