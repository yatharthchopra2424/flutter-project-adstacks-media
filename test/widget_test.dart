import 'package:flutter_test/flutter_test.dart';

import 'package:my_dashboard_app/main.dart';

void main() {
  testWidgets('Dashboard layout test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar has the correct title.
    expect(find.text('Dashboard'), findsOneWidget);

    // Verify that the sidebar is present.
    expect(find.text('Sidebar'), findsOneWidget);

    // Verify that the main content area is present.
    expect(find.text('Main Content'), findsOneWidget);

    // Verify that the calendar is present.
    expect(find.text('Calendar'), findsOneWidget);
  });
}
