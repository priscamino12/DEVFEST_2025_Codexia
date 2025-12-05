// lib/features/home/presentation/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:voice_deepfake_shield/features/home/presentation/screens/screens/permissions_screen.dart';
import 'dart:math' as math;
import '../../widgets/shield_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late AnimationController _buttonController;

  late Animation<double> _pulse;
  late Animation<double> _title;
  late Animation<double> _subtitle;
  late Animation<double> _button;

  @override
  void initState() {
    super.initState();

    // Pulsation du bouclier
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _pulse = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Rotation lente
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // ---- CORRECTION : créer et garder les controllers ----

    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _subtitleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // ---- Animations ----

    _title = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );

    _subtitle = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeOutCubic),
    );

    _button = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );

    // Lancer les animations dans l'ordre
    _titleController.forward();
    _subtitleController.forward();
    _buttonController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _titleController.dispose();
    _subtitleController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final small = size.height < 700;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 1.3,
            colors: [Color(0xFFEBF4FF), Colors.white, Color(0xFFF8FBFF)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              children: [
                SizedBox(height: small ? 60 : 100),

                // ------ TITRE ------
                AnimatedBuilder(
                  animation: _title,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _title.value,
                      child: Transform.translate(
                        offset: Offset(0, 50 * (1 - _title.value)),
                        child: ShaderMask(
                          shaderCallback: (rect) => const LinearGradient(
                            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                          ).createShader(rect),
                          child: Text(
                            'Voice Deepfake\nShield',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: small ? 40 : 45,
                              fontWeight: FontWeight.w900,
                              height: 0.9,
                              color: Colors.white,
                              letterSpacing: -1.5,
                              shadows: const [
                                Shadow(
                                  blurRadius: 15,
                                  color: Colors.black38,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // ------ SOUS-TITRE ------
                AnimatedBuilder(
                  animation: _subtitle,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _subtitle.value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - _subtitle.value)),
                        child: Text(
                          'Protégez-vous instantanément des arnaques vocales',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: small ? 17 : 20,
                            color: Colors.grey[800],
                            height: 1.6,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 2),

                // ------ BOUCLIER ------
                AnimatedBuilder(
                  animation: Listenable.merge([
                    _pulseController,
                    _rotateController,
                  ]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulse.value,
                      child: Transform.rotate(
                        angle: _rotateController.value * 2 * math.pi,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF42A5F5).withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            const ShieldWidget(),
                            ...List.generate(6, (i) {
                              final angle =
                                  i * math.pi / 3 +
                                  _rotateController.value * 2 * math.pi;
                              return Transform.rotate(
                                angle: angle,
                                child: Transform.translate(
                                  offset: const Offset(0, -140),
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    size: 24,
                                    color: Color(0xFF42A5F5),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const Spacer(flex: 3),

                // ------ BOUTON ------
                AnimatedBuilder(
                  animation: _button,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _button.value,
                      child: Opacity(
                        opacity: _button.value,
                        child: SizedBox(
                          width: double.infinity,
                          height: 68,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                      ) => const PermissionsScreen(),
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimation,
                                        child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                  transitionDuration: const Duration(
                                    milliseconds: 600,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1565C0),
                              elevation: 20,
                              shadowColor: const Color(0xFF42A5F5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(34),
                              ),
                            ),
                            child: const Text(
                              'ACTIVER LA PROTECTION',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 40),

                AnimatedBuilder(
                  animation: _button,
                  builder: (context, child) => Opacity(
                    opacity: _button.value,
                    child: const Text(
                      'Analyse en temps réel • Alerte instantanée • 100% gratuit',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 15.5),
                    ),
                  ),
                ),

                SizedBox(height: small ? 40 : 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
