// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:voice_deepfake_shield/features/views/welcome_view.dart';
import 'theme.dart';

class VoiceDeepfakeShieldApp extends StatelessWidget {
  const VoiceDeepfakeShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Deepfake Shield',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      home: const WelcomeScreen(),
    );
  }
}