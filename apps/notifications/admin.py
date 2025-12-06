# apps/notifications/admin.py
from django.contrib import admin
from .models import Notification

@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    # Colonnes visibles dans la liste
    list_display = ("id", "title", "read", "created_at")
    # Filtres latéraux
    list_filter = ("read", "created_at")
    # Recherche plein texte
    search_fields = ("title", "message")
    # Ordre par défaut
    ordering = ("-created_at",)
