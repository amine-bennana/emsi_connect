import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _compactMode = false;
  // Exercice TP : Troisième variable booléenne pour les informations complémentaires
  bool _showExtraInfo = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paramètres',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Préférences',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 16),

            // 1. Interrupteur des notifications
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Autoriser les notifications'),
              secondary: const Icon(Icons.notifications_outlined),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
            ),
            const Divider(),

            // 2. Interrupteur mode compact
            SwitchListTile(
              title: const Text('Mode compact'),
              subtitle: const Text('Réduire certains espacements'),
              secondary: const Icon(Icons.view_compact_outlined),
              value: _compactMode,
              onChanged: (value) {
                setState(() => _compactMode = value);
              },
            ),
            const Divider(),

            // 3. Exercice TP : Troisième interrupteur « Afficher les informations complémentaires »
            SwitchListTile(
              title: const Text('Afficher les informations complémentaires'),
              subtitle: const Text('Afficher une aide explicative'),
              secondary: const Icon(Icons.info_outline),
              value: _showExtraInfo,
              onChanged: (value) {
                setState(() => _showExtraInfo = value);
              },
            ),

            // Texte explicatif conditionnel affiché uniquement si activé
            if (_showExtraInfo) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.green.shade800),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Ces réglages sont maintenus en mémoire dans l\'objet State du widget. '
                        'Comme ils ne sont pas persistés dans une base de données, '
                        'quitter cette page réinitialisera les valeurs par défaut.',
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Carte récapitulative dynamique dont le padding dépend de _compactMode
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(_compactMode ? 8 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'État des paramètres',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Notifications : ${_notificationsEnabled ? "Activées" : "Désactivées"}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mode compact : ${_compactMode ? "Activé" : "Désactivé"}',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Infos complémentaires : ${_showExtraInfo ? "Visibles" : "Masquées"}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton de confirmation SnackBar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Paramètres modifiés localement'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Afficher une confirmation'),
            ),
          ],
        ),
      ),
    );
  }
}
