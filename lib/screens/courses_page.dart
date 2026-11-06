import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Défi A : Liste de données riche pour chaque module ─────────────────
    final List<Map<String, dynamic>> modules = [
      {
        'nom': 'Développement Multi-Plateforme (Flutter)',
        'enseignant': 'Mme Aouraghe',
        'heures': 32,
        'icone': Icons.flutter_dash,
      },
      {
        'nom': 'Bases de données avancées & NoSQL',
        'enseignant': 'M. Benali',
        'heures': 28,
        'icone': Icons.storage,
      },
      {
        'nom': 'Réseaux informatiques & Télécoms',
        'enseignant': 'M. Mansouri',
        'heures': 24,
        'icone': Icons.network_check,
      },
      {
        'nom': 'Intelligence Artificielle & Machine Learning',
        'enseignant': 'Mme Tazi',
        'heures': 30,
        'icone': Icons.psychology,
      },
      {
        'nom': 'Sécurité des Systèmes d\'Information',
        'enseignant': 'M. Idrissi',
        'heures': 24,
        'icone': Icons.security,
      },
      {
        'nom': 'Architecture Logicielle & Cloud Computing',
        'enseignant': 'M. El Amrani',
        'heures': 28,
        'icone': Icons.cloud_done,
      },
      {
        'nom': 'Gestion de projet Agile & DevOps',
        'enseignant': 'Mme Chraibi',
        'heures': 20,
        'icone': Icons.task_alt,
      },
      {
        'nom': 'Systèmes Embarqués & IoT',
        'enseignant': 'M. Alami',
        'heures': 24,
        'icone': Icons.memory,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes cours',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      // ── Gestion des contraintes de hauteur (Partie 7 du TP3) ──────────────
      // Utilisation d'une Column avec un en-tête fixe et un Expanded
      // pour éviter l'erreur « Vertical viewport was given unbounded height ».
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── En-tête fixe avec résumé ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border(
                bottom: BorderSide(color: Colors.green.shade200, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Modules du semestre (S5)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '5IIR • Année 2026/2027',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${modules.length} modules',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Liste défilante générée dynamiquement (ListView.builder) ─────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                final String nom = module['nom'] as String;
                final String enseignant = module['enseignant'] as String;
                final int heures = module['heures'] as int;
                final IconData icone = module['icone'] as IconData? ?? Icons.menu_book;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    // Défi B : Numéro du module avec CircleAvatar stylisé
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      foregroundColor: Colors.green.shade800,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Nom du module
                    title: Text(
                      nom,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    // Défi A : Enseignant et volume horaire
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Icon(
                            icone,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Prof : $enseignant  •  $heures h',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Flèche de navigation à droite
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.green,
                    ),
                    // Défi C : Interaction au clic avec SnackBar informatif
                    onTap: () {
                      debugPrint('Module sélectionné : $nom');
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text('Module sélectionné : $nom'),
                              ),
                            ],
                          ),
                          backgroundColor: Colors.green.shade700,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}