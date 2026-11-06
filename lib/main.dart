import 'package:flutter/material.dart';
import 'screens/courses_page.dart';
// Note : HomePage et ProfilePage restent disponibles pour la suite du projet
// import 'screens/home_page.dart';
// import 'screens/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EMSI Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // Affichage provisoire de CoursesPage pour le TP3
      home: const CoursesPage(),
    );
  }
}
