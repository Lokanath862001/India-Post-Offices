import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:india_post_offices/main.dart';

void main() {
  testWidgets('Top and Bottom banner ad widgets are present on PostOfficeFinderScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(TopBannerAdWidget), findsOneWidget);
    expect(find.byType(BottomBannerAdWidget), findsOneWidget);
  });

  testWidgets('Top and Bottom banner ad widgets are present on ThemeSelectorScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ThemeSelectorScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TopBannerAdWidget), findsOneWidget);
    expect(find.byType(BottomBannerAdWidget), findsOneWidget);
    expect(find.text('Color Palette & Themes'), findsOneWidget);
    expect(find.byType(ThemePaletteContent), findsOneWidget);
  });

  testWidgets('Top and Bottom banner ad widgets are present on AppInfoScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppInfoScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TopBannerAdWidget), findsOneWidget);
    expect(find.byType(BottomBannerAdWidget), findsOneWidget);
    expect(find.text('India Post Offices'), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);
  });

  testWidgets('Top and Bottom banner ad widgets are present on AssociatedOfficeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AssociatedOfficeScreen(
          po: const {
            'Name': 'Khurda H.O',
            'Pincode': '752055',
            'BranchType': 'Head Office',
            'DeliveryStatus': 'Delivery',
            'District': 'Khurda',
            'State': 'Odisha',
            'Division': 'Puri',
            'Region': 'Bhubaneswar',
            'Circle': 'Odisha',
          },
          onDictate: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TopBannerAdWidget), findsOneWidget);
    expect(find.byType(BottomBannerAdWidget), findsOneWidget);
    expect(find.text('Associated Main Office'), findsOneWidget);
    expect(find.text('Khurda H.O'), findsOneWidget);
    expect(find.text('752055'), findsOneWidget);
  });
}
