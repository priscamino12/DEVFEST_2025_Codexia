from django.urls import path
from .views import VisionAnalysisView

urlpatterns = [
    # POST /api/vision/detect/
    path('detect/', VisionAnalysisView.as_view(), name='vision_detect'),
]
