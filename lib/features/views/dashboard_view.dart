import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === TITRE + ICÔNE MALGACHE ===
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Tableau de bord',
                      style: TextStyle(
                        fontSize: screenWidth > 360 ? 34 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.red, Colors.green]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('MG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Protection active • Tout Madagascar avec vous',
                style: TextStyle(color: Colors.grey[600], fontSize: screenWidth > 360 ? 16 : 14),
              ),
              const SizedBox(height: 32),

              // === CONTENU SCROLLABLE ===
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // === CARTES STATISTIQUES ===
                      Row(
                        children: [
                          Expanded(child: _bigStatCard('45', 'Appels sécurisés', Colors.green, Icons.check_circle, screenWidth)),
                          const SizedBox(width: 16),
                          Expanded(child: _bigStatCard('8', 'Suspects détectés', Colors.orange, Icons.warning_amber, screenWidth)),
                          const SizedBox(width: 16),
                          Expanded(child: _bigStatCard('3', 'Deepfakes bloqués', Colors.red, Icons.block, screenWidth)),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // === ANALYSE RAPIDE ===
                      Text(
                        'Analyse rapide',
                        style: TextStyle(fontSize: screenWidth > 360 ? 24 : 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: screenWidth > 500 ? 3 : 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _quickAction(icon: Icons.mic, label: 'Voix en direct', color: const Color(0xFF1E88E5), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Analyse vocale en cours...'))), screenWidth: screenWidth),
                          _quickAction(icon: Icons.image, label: 'Image', color: const Color(0xFF00C853), onTap: () {}, screenWidth: screenWidth),
                          _quickAction(icon: Icons.videocam, label: 'Vidéo', color: const Color(0xFFE91E63), onTap: () {}, screenWidth: screenWidth),
                          _quickAction(icon: Icons.text_fields, label: 'Texte', color: const Color(0xFF9C27B0), onTap: () {}, screenWidth: screenWidth),
                          _quickAction(icon: Icons.record_voice_over, label: 'Voix enregistrée', color: const Color(0xFFFFB300), onTap: () {}, screenWidth: screenWidth),
                          _quickAction(icon: Icons.shield_moon, label: 'Mode nuit', color: Colors.deepPurple, onTap: () {}, screenWidth: screenWidth),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // === DERNIÈRES ALERTES ===
                      Text('Dernières alertes', style: TextStyle(fontSize: screenWidth > 360 ? 24 : 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      ...List.generate(3, (index) => _recentAlert(index)),

                      const SizedBox(height: 30),

                      // === CARTE FUN ===
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)]),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20)],
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.auto_awesome, size: screenWidth > 360 ? 50 : 40, color: Colors.white),
                            const SizedBox(height: 12),
                            Text(
                              'Prochainement : détection WhatsApp, Telegram, Messenger !',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: screenWidth > 360 ? 18 : 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text('On protège toute la famille', style: TextStyle(color: Colors.white70, fontSize: screenWidth > 360 ? 14 : 12)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets ---
  Widget _bigStatCard(String number, String label, Color color, IconData icon, double screenWidth) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: screenWidth > 360 ? 50 : 40, color: color),
          const SizedBox(height: 12),
          Text(number, style: TextStyle(fontSize: screenWidth > 360 ? 48 : 36, fontWeight: FontWeight.w900, color: color)),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: screenWidth > 360 ? 16 : 14, color: color.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _quickAction({required IconData icon, required String label, required Color color, required VoidCallback onTap, required double screenWidth}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenWidth > 360 ? 20 : 16),
              decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, size: screenWidth > 360 ? 40 : 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontSize: screenWidth > 360 ? 15 : 13, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _recentAlert(int index) {
    final titles = ['Voix IA détectée', 'Appel suspect', 'Numéro inconnu bloqué'];
    final times = ['Il y a 12 min', 'Il y a 1h', 'Hier à 19:42'];
    final colors = [Colors.red, Colors.orange, Colors.green];

    return ListTile(
      leading: CircleAvatar(backgroundColor: colors[index], child: const Icon(Icons.call, color: Colors.white)),
      title: Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(times[index]),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
