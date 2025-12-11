import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/settings_screen.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Set up shared_preferences mock
    SharedPreferences.setMockInitialValues({'fontSize': 16.0});
    await AppStyles.loadFontSize();
  });
  group('SettingsScreen Widget Tests', () {
    testWidgets('SettingsScreen renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => Cart(),
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      // Wait for loading spinner to disappear
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
    });

    testWidgets('Font size setting changes UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => Cart(),
          child: const MaterialApp(
            home: SettingsScreen(),
          ),
        ),
      );
      // Wait for loading spinner to disappear
      await tester.pumpAndSettle();
      // Find the font size slider
      final sliderFinder = find.byType(Slider);
      expect(sliderFinder, findsOneWidget);

      // Drag the slider to increase font size
      await tester.drag(sliderFinder, const Offset(50, 0));
      await tester.pump();

      // Verify sample text is still present
      expect(find.text('This is sample text to preview the font size.'),
          findsOneWidget);
    });

    testWidgets('Navigating to SettingsScreen from App',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SettingsScreen()));
      expect(find.byType(SettingsScreen), findsOneWidget);
    });
  });
}
