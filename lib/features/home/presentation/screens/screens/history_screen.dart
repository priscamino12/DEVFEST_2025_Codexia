// lib/features/home/presentation/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _staggerAnimation;

  final List<Map<String, dynamic>> alerts = [
    {
      "date": DateTime.now().subtract(const Duration(minutes: 45)),
      "number": "+261 34 12 345 67",
      "risk": 96,
      "status": "danger",
      "duration": "2 min 34s",
    },
    {
      "date": DateTime.now().subtract(const Duration(hours: 3)),
      "number": "Numéro masqué",
      "risk": 88,
      "status": "danger",
      "duration": "1 min 12s",
    },
    {
      "date": DateTime.now().subtract(const Duration(hours: 6)),
      "number": "+261 38 90 123 45",
      "risk": 12,
      "status": "safe",
      "duration": "45s",
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "number": "+261 32 55 678 90",
      "risk": 99,
      "status": "danger",
      "duration": "3 min 08s",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _staggerAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Historique des alertes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Rapport exporté pour la police'),
                  backgroundColor: Color(0xFF1E88E5),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF1E88E5)),
          ),
        ],
      ),
      body: alerts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_moon, size: 100, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'Aucune alerte pour le moment\nVous êtes en sécurité',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                final delay = index * 0.12;

                return AnimatedBuilder(
                  animation: _staggerAnimation,
                  builder: (context, child) {
                    final animationValue =
                        (_staggerAnimation.value - delay).clamp(0.0, 1.0);

                    return Transform(
                      transform: Matrix4.translationValues(
                        0,
                        40 * (1 - animationValue),
                        0,
                      ),
                      child: Opacity(
                        opacity: animationValue,
                        child: _buildAlertCard(alert),
                      ),
                    );
                  },
                );
              },
            ),

    floatingActionButton: FloatingActionButton.extended(
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rapport complet envoyé à la police'),
        backgroundColor: Color(0xFF00C853),
      ),
    );
  },
  backgroundColor: const Color(0xFF1E88E5),
  icon: const Icon(Icons.local_police),
  label: Text(
    'Signaler tout',
    style: const TextStyle(fontWeight: FontWeight.bold),
  ),
),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final isDanger = alert["status"] == "danger";
    final risk = alert["risk"] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDanger
              ? const Color(0xFFE53935).withOpacity(0.3)
              : const Color(0xFF00C853).withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDanger ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isDanger ? Icons.warning_amber : Icons.check_circle,
              size: 36,
              color:
                  isDanger ? const Color(0xFFE53935) : const Color(0xFF00C853),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert["number"],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM yyyy • HH:mm').format(alert["date"]),
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(alert["duration"],
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDanger
                            ? const Color(0xFFE53935)
                            : const Color(0xFF00C853),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$risk% risque',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.play_circle_fill,
              size: 36,
              color: Color(0xFF1E88E5),
            ),
          ),
        ],
      ),
    );
  }
}
