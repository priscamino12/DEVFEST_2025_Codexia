// lib/features/home/presentation/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import '../../widgets/shield_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shieldAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _shieldAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.7, curve: Curves.elasticOut)),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive : s’adapte à tous les écrans
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5F9FF),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              children: [
                SizedBox(height: isSmallScreen ? 30 : 60),

                // Petit logo AlgoMada + drapeau malgache discret
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "AlgoMada",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        color: const Color(0xFF1E88E5),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.red,
                      ),
                      child: const Column(
                        children: [
                          Expanded(flex: 1, child: ColoredBox(color: Colors.white)),
                          Expanded(flex: 1, child: ColoredBox(color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(flex: 2),

                // Titre avec animation fade
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Voice Deepfake\nShield',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 36 : 44,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                      color: const Color(0xFF1E88E5),
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Protégez-vous des arnaques vocales\npar intelligence artificielle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 17 : 19,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Bouclier qui grandit avec effet élastique
                ScaleTransition(
                  scale: _shieldAnimation,
                  child: const ShieldWidget(),
                ),

                const Spacer(flex: 4),

                // Bouton
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: () {
                        // Plus tard : Navigator.push vers écran permissions
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Protection activée !'),
                            backgroundColor: Color(0xFF00C853),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'ACTIVER LA PROTECTION',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Analyse en temps réel • Alerte instantanée • 100% gratuit',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      color: Colors.grey[600],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}