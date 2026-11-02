import 'package:flutter_test/flutter_test.dart';

import 'package:ecom_frontend/app/modules/home/views/home_view.dart';
import 'package:ecom_frontend/main.dart';

void main() {
  testWidgets('App renders initial route', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the initial home view is shown even when unauthenticated.
    expect(find.byType(HomeView), findsOneWidget);
  });
}
