import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Part 3 : AppBar ──────────────────────────────────────────────
      appBar: AppBar(
        title: const Text(
          'EMSI Connect',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              debugPrint('Notifications consultées');
            },
          ),
        ],
      ),

      // ── Parts 4 & 5 : Body ──────────────────────────────────────────
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Image du campus ─────────────────────────────────────
              Image.asset(
                'assets/images/Emsi.png',
                height: 120,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              // ── Titre de bienvenue ──────────────────────────────────
              const Text(
                'Bienvenue sur EMSI Connect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ── Description ─────────────────────────────────────────
              const Text(
                'Votre espace universitaire pour accéder à vos cours, '
                'votre planning et vos informations personnelles.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // ── Rubriques (grille 2 × 2) ────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildRubrique(Icons.menu_book, 'Mes cours'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRubrique(Icons.calendar_month, 'Planning'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildRubrique(Icons.person, 'Mon profil'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildRubrique(Icons.task_alt, 'Mes tâches'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // ── Part 6 : FloatingActionButton ───────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Fonctionnalité bientôt disponible');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ── Helper : bloc de rubrique ─────────────────────────────────────────
  Widget _buildRubrique(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: Colors.green),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
