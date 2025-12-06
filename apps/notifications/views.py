# apps/notifications/views.py
from rest_framework import generics
from .models import Notification
from .serializers import NotificationSerializer

class NotificationListCreateView(generics.ListCreateAPIView):
    """
    GET: liste paginée des notifications (par défaut, récentes d'abord).
    POST: crée une notification (title, message, read en option).
    """
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer

class NotificationDetailView(generics.RetrieveUpdateDestroyAPIView):
    """
    GET: récupère une notification par id.
    PUT/PATCH: met à jour la notification (ex: read=True).
    DELETE: supprime la notification.
    """
    queryset = Notification.objects.all()
    serializer_class = NotificationSerializer
