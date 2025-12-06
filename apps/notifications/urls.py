# apps/notifications/urls.py
from django.urls import path
from .views import NotificationListCreateView, NotificationDetailView

urlpatterns = [
    # /api/notifications/
    path("", NotificationListCreateView.as_view(), name="notifications-list"),
    # /api/notifications/1/
    path("<int:pk>/", NotificationDetailView.as_view(), name="notification-detail"),
]
