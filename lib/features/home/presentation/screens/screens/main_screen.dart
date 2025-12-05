import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  bool isSafe = true;

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

    _pulse = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _blink = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _blinkController, curve: Curves.easeInOut),
    );
  }

  void toggleDanger() {
    setState(() {
      isSafe = !isSafe;
      if (!isSafe) {
        _blinkController.repeat(reverse: true);
      } else {
        _blinkController.stop();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isSafe ? const Color(0xFFF8FAFF) : const Color(0xFFFFF0F0),
      body: SafeArea(
        child: Center( // <-- CENTRAGE GLOBAL
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // <-- tout est centré verticalement
              children: [

                // === Cercle central animé ===
                AnimatedBuilder(
                  animation: isSafe ? _pulseController : _blinkController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isSafe ? _pulse.value : _blink.value,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSafe ? const Color(0xFF00C853) : const Color(0xFFE53935),
                          boxShadow: [
                            BoxShadow(
                              color: (isSafe
                                      ? const Color(0xFF00C853)
                                      : const Color(0xFFE53935))
                                  .withOpacity(0.5),
                              blurRadius: isSafe ? 50 : 70,
                              spreadRadius: isSafe ? 20 : 30,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSafe ? Icons.shield : Icons.warning_amber,
                              size: 110,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              isSafe ? 'PROTÉGÉ' : 'DANGER !',
                              style: const TextStyle(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2.5,
                              ),
                            ),
                            if (!isSafe) ...[
                              const SizedBox(height: 12),
                              const Text(
                                'VOIX FAUSSE DÉTECTÉE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Ne donnez aucune information !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
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

                const SizedBox(height: 50),

                // Texte d’état
                Text(
                  isSafe
                      ? 'Analyse en cours...\nAucune menace détectée'
                      : 'Alerte en cours !\nEnregistrement activé',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: isSafe ? Colors.grey[700] : Colors.red[700],
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // Indicateur de statut
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                  decoration: BoxDecoration(
                    color: isSafe ? const Color(0xFFE8F5E8) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: isSafe ? const Color(0xFF00C853) : const Color(0xFFE53935),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSafe ? Icons.check_circle : Icons.error,
                        color: isSafe ? const Color(0xFF00C853) : const Color(0xFFE53935),
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isSafe ? 'Protection active' : 'Menace détectée',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: isSafe ? const Color(0xFF00C853) : const Color(0xFFE53935),
                        ),
                      ),
                    ],
                  ),
                ),

                if (!isSafe) ...[
                  const SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'ENREGISTRER & SIGNALER',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: toggleDanger,
                    child: const Text('Ignorer cette alerte',
                        style: TextStyle(color: Colors.grey)),
                  )
                ],
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Text(
          isSafe
              ? 'Voice Deepfake Shield tourne en arrière-plan'
              : 'Appel en cours • Analyse en temps réel',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ),
    );
  }
}
