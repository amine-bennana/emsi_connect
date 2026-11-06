import 'package:flutter_test/flutter_test.dart';
import 'package:emsi_connect/main.dart';

void main() {
  testWidgets('CoursesPage smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the AppBar title is displayed.
    expect(find.text('Mes cours'), findsOneWidget);

    // Verify that the modules header is displayed.
    expect(find.text('Modules du semestre (S5)'), findsOneWidget);
  });
}
