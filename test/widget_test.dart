import 'package:flutter_test/flutter_test.dart';
import 'package:dartcode_campus/main.dart';

void main() {
  testWidgets('App loads MainLayout', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DartCodeCampusApp());

    // Verify that the Home tab is selected and text is visible.
    expect(find.text('Welcome back,'), findsOneWidget);
    expect(find.text('Home'), findsWidgets);
    expect(find.text('Learn'), findsWidgets);
    expect(find.text('Practice'), findsWidgets);
  });
}
