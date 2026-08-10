import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:india_post_offices/main.dart';

void main() {
  testWidgets('App loads search field and header successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the title header exists
    expect(find.text('INDIA POST'), findsOneWidget);
    expect(find.text('OFFICES DIRECTORY'), findsOneWidget);

    // Verify that the search input field is present
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Enter 3+ digit Pincode or Office Name...'), findsOneWidget);

    // Verify that the initial search state is "Ready to Search"
    expect(find.text('Ready to Search'), findsOneWidget);
  });
}
