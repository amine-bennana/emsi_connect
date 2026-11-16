import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emsi_connect/main.dart';

void main() {
  testWidgets('LoginPage Partie 2 validation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Vérifier la présence du bouton de validation
    final bouton = find.text('Vérifier la saisie');
    expect(bouton, findsOneWidget);

    // Appuyer sans rien saisir pour déclencher les validateurs
    await tester.tap(bouton);
    await tester.pump();

    // Vérifier l'affichage des messages d'erreur obligatoires
    expect(find.text('Email obligatoire'), findsOneWidget);
    expect(find.text('Mot de passe obligatoire'), findsOneWidget);
  });
}
