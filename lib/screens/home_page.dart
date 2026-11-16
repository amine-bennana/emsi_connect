import 'package:flutter/material.dart';
import '../main.dart';
import 'courses_page.dart';
import 'login_page.dart';
import 'profile_page.dart';

// ── Partie 7 du TP4 : GridView adaptatif sur HomePage ─────────────────────────
// - Remplacement des Row par GridView.count
// - Utilisation de LayoutBuilder pour adapter le nombre de colonnes :
//   * 2 colonnes sur écran mobile (< 600 px)
//   * 3 colonnes sur écran large / tablette (>= 600 px)
// - Emploi de shrinkWrap: true et NeverScrollableScrollPhysics pour s'intégrer
//   dans le SingleChildScrollView sans conflit de scroll.

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar ──────────────────────────────────────────────────────────
      appBar: AppBar(
        title: const Text(
          'EMSI Connect',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.white,
            ),
            tooltip: 'Basculer le thème',
            onPressed: () {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              MyApp.themeModeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Connexion',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            tooltip: 'Notifications',
            onPressed: () {
              debugPrint('Notifications consultées');
            },
          ),
        ],
      ),

      // ── Body défilable ──────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Image du campus ─────────────────────────────────────────
              Image.asset(
                'assets/images/Emsi.png',
                height: 110,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 16),

              // ── Titre de bienvenue ──────────────────────────────────────
              const Text(
                'Bienvenue sur EMSI Connect',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ── Description ─────────────────────────────────────────────
              const Text(
                'Votre espace universitaire pour accéder à vos cours, '
                'votre planning et vos informations personnelles.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // ── Grille de rubriques adaptative avec LayoutBuilder (Partie 7) ──
              LayoutBuilder(
                builder: (context, constraints) {
                  // 2 colonnes sur smartphone, 3 colonnes sur tablette/desktop
                  final columns = constraints.maxWidth < 600 ? 2 : 3;

                  return GridView.count(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.25,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildRubrique(
                        context,
                        icon: Icons.menu_book,
                        label: 'Mes cours',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CoursesPage(),
                            ),
                          );
                        },
                      ),
                      _buildRubrique(
                        context,
                        icon: Icons.calendar_month,
                        label: 'Planning',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Planning bientôt disponible'),
                            ),
                          );
                        },
                      ),
                      _buildRubrique(
                        context,
                        icon: Icons.person,
                        label: 'Mon profil',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                      _buildRubrique(
                        context,
                        icon: Icons.task_alt,
                        label: 'Mes tâches',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Section Mes tâches bientôt disponible'),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // ── FloatingActionButton ────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Fonctionnalité d\'ajout rapide bientôt disponible');
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ── Helper : Carte de rubrique interactive ──────────────────────────────
  Widget _buildRubrique(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 38, color: Colors.blue.shade700),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
