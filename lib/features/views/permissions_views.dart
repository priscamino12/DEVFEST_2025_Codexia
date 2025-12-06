import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:voice_deepfake_shield/features/views/home_wrapper.dart';
import 'main_view.dart';

class PermissionsViews extends StatefulWidget {
  const PermissionsViews({super.key});

  @override
  State<PermissionsViews> createState() => _PermissionsViewsState();
}

class _PermissionsViewsState extends State<PermissionsViews>
    with TickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  bool micGranted = false;
  bool phoneGranted = false;
  bool notifGranted = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slide = Tween<double>(begin: 120.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _anim,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _anim.forward();

    _simulatePermissionsForWeb();
  }

  // Méthode pour simuler les permissions sur Chrome / Desktop
  Future<void> _simulatePermissionsForWeb() async {
    try {
      final micRestricted = await Permission.microphone.isRestricted;
      final phoneRestricted = await Permission.phone.isRestricted;

      if (!micRestricted && !phoneRestricted) {
        setState(() {
          micGranted = true;
          phoneGranted = true;
          notifGranted = true;
        });
      }
    } catch (e) {
      // Si l'API n'existe pas sur Web, simuler l'autorisation
      setState(() {
        micGranted = true;
        phoneGranted = true;
        notifGranted = true;
      });
    }
  }

  Future<void> _requestPermission(
      Permission permission, VoidCallback onGranted) async {
    try {
      final status = await permission.status;
      if (status.isGranted) {
        onGranted();
        setState(() {});
        return;
      }

      final result = await permission.request();
      if (result.isGranted) {
        onGranted();
        setState(() {});
      }
    } catch (e) {
      // Pour Web / Desktop, simuler autorisation
      onGranted();
      setState(() {});
    }
  }

  void _goToMainIfAllGranted() {
    if (micGranted && phoneGranted && notifGranted) {
      Navigator.of(context).pushReplacement(
  PageRouteBuilder(
    pageBuilder: (_, __, ___) => const HomeWrapper(),
    transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
  ),
);
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allGranted = micGranted && phoneGranted && notifGranted;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Center(
          child: AnimatedBuilder(
            animation: _anim,
            builder: (context, child) {
              return Opacity(
                opacity: _fade.value,
                child: Transform.translate(
                  offset: Offset(0, _slide.value),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1E88E5).withOpacity(0.3),
                                blurRadius: 40,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.mic, size: 90, color: Color(0xFF1E88E5)),
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          'Autorisations nécessaires',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Cliquez sur chaque permission pour l’activer.\nL’app vous protégera en temps réel.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 40),

                        _permissionTile(
                          icon: Icons.mic,
                          title: "Microphone",
                          subtitle: "Écouter les appels en temps réel",
                          color: const Color(0xFF1E88E5),
                          isGranted: micGranted,
                          onTap: () => _requestPermission(Permission.microphone, () {
                            micGranted = true;
                          }),
                        ),
                        const SizedBox(height: 18),
                        _permissionTile(
                          icon: Icons.phone_in_talk,
                          title: "Téléphone",
                          subtitle: "Détecter les appels entrants/sortants",
                          color: const Color(0xFF00C853),
                          isGranted: phoneGranted,
                          onTap: () => _requestPermission(Permission.phone, () {
                            phoneGranted = true;
                          }),
                        ),
                        const SizedBox(height: 18),
                        _permissionTile(
                          icon: Icons.notifications_active,
                          title: "Notifications",
                          subtitle: "Alerte instantanée même en arrière-plan",
                          color: const Color(0xFFFFB300),
                          isGranted: notifGranted,
                          onTap: () => _requestPermission(Permission.notification, () {
                            notifGranted = true;
                          }),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 66,
                          child: ElevatedButton(
                            onPressed: allGranted ? _goToMainIfAllGranted : null,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>((states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.grey[400]!;
                                }
                                return allGranted ? const Color(0xFF00C853) : const Color(0xFF1E88E5);
                              }),
                              elevation: MaterialStateProperty.resolveWith<double>((states) {
                                if (states.contains(MaterialState.disabled)) return 10;
                                return allGranted ? 20 : 10;
                              }),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(34)),
                              ),
                            ),
                            child: Text(
                              allGranted
                                  ? 'TOUT EST PRÊT ! LANCER LA PROTECTION'
                                  : 'AUTORISER LES 3 ACCÈS POUR CONTINUER',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Plus tard', style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  

  Widget _permissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isGranted ? color.withOpacity(0.7) : Colors.grey.withOpacity(0.2),
            width: isGranted ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isGranted ? color.withOpacity(0.2) : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
              child: Icon(
                isGranted ? Icons.check_circle : Icons.arrow_forward_ios,
                key: ValueKey(isGranted),
                size: 30,
                color: isGranted ? color : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
