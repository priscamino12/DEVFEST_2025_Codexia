import 'package:flutter/material.dart';
import 'package:voice_deepfake_shield/features/views/history_view.dart';

enum DetectionState { safe, warning, danger }

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with TickerProviderStateMixin {
  DetectionState currentState = DetectionState.safe;

  late AnimationController _pulseController;
  late AnimationController _blinkController;
  late Animation<double> _pulse;
  late Animation<double> _blink;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.09).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _blink = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );

    // Simule des changements d'état
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) setState(() => currentState = DetectionState.warning);
    });
    Future.delayed(const Duration(seconds: 16), () {
      if (mounted) setState(() => currentState = DetectionState.danger);
      _blinkController.repeat(reverse: true);
    });
    Future.delayed(const Duration(seconds: 25), () {
      if (mounted) setState(() => currentState = DetectionState.safe);
      _blinkController.stop();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  Color get backgroundColor {
    switch (currentState) {
      case DetectionState.safe:
        return const Color(0xFFF8FAFF);
      case DetectionState.warning:
        return const Color(0xFFFFFBEB);
      case DetectionState.danger:
        return const Color(0xFFFFF0F0);
    }
  }

  Color get circleColor {
    switch (currentState) {
      case DetectionState.safe:
        return const Color(0xFF00C853);
      case DetectionState.warning:
        return const Color(0xFFFFB300);
      case DetectionState.danger:
        return const Color(0xFFE53935);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HistoryScreen(),
                transitionsBuilder: (_, a, __, c) =>
                    FadeTransition(opacity: a, child: c),
              ),
            ),
            icon: const Icon(Icons.history, size: 28),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // CERCLE CENTRAL ANIMÉ
                AnimatedBuilder(
                  animation: currentState == DetectionState.danger
                      ? _blinkController
                      : _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: currentState == DetectionState.danger
                          ? _blink.value
                          : _pulse.value,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: circleColor,
                          boxShadow: [
                            BoxShadow(
                              color: circleColor.withOpacity(
                                  currentState == DetectionState.danger ? 0.7 : 0.5),
                              blurRadius: currentState == DetectionState.danger ? 80 : 60,
                              spreadRadius: currentState == DetectionState.danger ? 30 : 20,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              currentState == DetectionState.safe
                                  ? Icons.shield
                                  : currentState == DetectionState.warning
                                      ? Icons.warning_amber
                                      : Icons.dangerous,
                              size: 120,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              currentState == DetectionState.safe
                                  ? 'PROTÉGÉ'
                                  : currentState == DetectionState.warning
                                      ? 'ATTENTION'
                                      : 'DANGER !',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (currentState != DetectionState.safe) ...[
                              Text(
                                currentState == DetectionState.warning
                                    ? 'Voix suspecte détectée'
                                    : 'VOIX IA CONFIRMÉE',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentState == DetectionState.warning
                                    ? 'Risque modéré – Restez vigilant'
                                    : 'NE DONNEZ RIEN !\nEnregistrement en cours...',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // STATUT EN BAS
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  decoration: BoxDecoration(
                    color: currentState == DetectionState.safe
                        ? const Color(0xFFE8F5E8)
                        : currentState == DetectionState.warning
                            ? const Color(0xFFFFF8E1)
                            : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: circleColor,
                      width: 3,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        currentState == DetectionState.safe
                            ? Icons.check_circle
                            : currentState == DetectionState.warning
                                ? Icons.warning
                                : Icons.error,
                        color: circleColor,
                        size: 30,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        currentState == DetectionState.safe
                            ? 'Protection active • Tout va bien'
                            : currentState == DetectionState.warning
                                ? 'Analyse approfondie en cours...'
                                : 'Alerte maximale • Enregistrement activé',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: circleColor,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Bouton danger uniquement si rouge
                if (currentState == DetectionState.danger) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Enregistrement envoyé à la police'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 20,
                      ),
                      child: const Text(
                        'SIGNALER IMMÉDIATEMENT À LA POLICE',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: backgroundColor,
        child: Text(
          currentState == DetectionState.safe
              ? 'Voice Deepfake Shield • Protection active en arrière-plan'
              : currentState == DetectionState.warning
                  ? 'Appel en cours • Analyse en cours...'
                  : 'Appel en cours • Voix IA détectée',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
      ),
    );
  }
}
