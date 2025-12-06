// lib/features/home/widgets/shield_widget.dart
import 'package:flutter/material.dart';

class ShieldWidget extends StatelessWidget {
  const ShieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5), Color(0xFF64B5F6)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF42A5F5).withOpacity(0.7),
            blurRadius: 50,
            spreadRadius: 15,
          ),
        ],
      ),
      child: const Icon(Icons.shield, size: 130, color: Colors.white),
    );
  }
}