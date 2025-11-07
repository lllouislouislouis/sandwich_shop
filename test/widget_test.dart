// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sandwich_shop/main.dart';

void main() {
  testWidgets('Initial UI shows quantity, size and bread',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Initial quantity and size text.
    expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);

    // Bread defaults to White.
    expect(find.text('Bread: White'), findsOneWidget);

    // Add and Remove buttons present.
    expect(find.widgetWithText(ElevatedButton, 'Add'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Remove'), findsOneWidget);
  });

  testWidgets('Add and Remove update quantity and icons',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Tap Add once.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pumpAndSettle();

    // Expect one sandwich displayed.
    expect(find.text('1 Footlong sandwich(es): 🥪'), findsOneWidget);

    // Tap Add again.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.text('2 Footlong sandwich(es): 🥪🥪'), findsOneWidget);

    // Tap Remove once.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
    await tester.pumpAndSettle();
    expect(find.text('1 Footlong sandwich(es): 🥪'), findsOneWidget);
  });

  testWidgets('Entering a note displays it in the OrderItemDisplay',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Enter a note.
    final Finder noteField = find.byType(TextField);
    expect(noteField, findsOneWidget);
    await tester.enterText(noteField, 'no onions');
    await tester.pumpAndSettle();

    // Notes should be visible.
    expect(find.text('Notes: no onions'), findsOneWidget);
  });

  testWidgets('Selecting a different bread updates the display',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Open the dropdown by tapping the current value ('White').
    await tester.tap(find.text('White'));
    await tester.pumpAndSettle();

    // Select 'Brown' from the dropdown.
    await tester.tap(find.text('Brown').last);
    await tester.pumpAndSettle();

    // Bread should update.
    expect(find.text('Bread: Brown'), findsOneWidget);
  });

  testWidgets('Segmented control switches between Footlong and Six-inch',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    // Initially Footlong.
    expect(find.text('0 Footlong sandwich(es): '), findsOneWidget);

    // Tap the Six-inch segment.
    await tester.tap(find.text('Six-inch'));
    await tester.pumpAndSettle();

    // Expect the display to show Six-inch.
    expect(find.text('0 Six-inch sandwich(es): '), findsOneWidget);

    // Tap Add and verify the size is kept.
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pumpAndSettle();
    expect(find.text('1 Six-inch sandwich(es): 🥪'), findsOneWidget);
  });
}
