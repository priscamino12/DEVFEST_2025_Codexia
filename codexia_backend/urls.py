"""
URL configuration for codexia_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.http import HttpResponse, JsonResponse

def index(request):
    # simple page d'accueil
    return HttpResponse("<h1>Bienvenue sur Codexia API</h1><p>Accès API: /api/audio/, /api/vision/, /api/notifications/</p>")

urlpatterns = [
    path("", index, name="home"),  # <-- route racine
    path('admin/', admin.site.urls),

    # API audio
    path("api/audio/", include("apps.audio.urls")), # http://127.0.0.1:8300/api/audio/

    # API notifications
    path("api/notifications/", include("apps.notifications.urls")), # http://127.0.0.1:8300/api/notifications/
    
    # API image
    path('api/vision/', include('apps.vision.urls')) # http://127.0.0.1:8300/api/vision/detect/
]

# Servir media en dev
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
