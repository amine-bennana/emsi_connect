import 'package:flutter/material.dart';
import 'screens/login_page.dart';

// ── TP4 : Material 3 et Bascule de thème clair / sombre (Partie Bonus 4) ───────

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Notifier global accessible pour basculer le thème depuis n'importe quelle page
  static final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'EMSI Connect',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,

          // ── Thème Clair Material 3 ────────────────────────────────────────
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),

          // ── Thème Sombre Material 3 ───────────────────────────────────────
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),

          // Point d'entrée pour le TP4
          home: const LoginPage(),
        );
      },
    );
  }
}
