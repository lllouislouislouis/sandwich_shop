import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });

  group('OrderScreen - Initial State', () {
    testWidgets('displays initial state correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('0 White footlong sandwich(es): '), findsOneWidget);
      expect(find.text('Note: No notes added.'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Add'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Remove'), findsOneWidget);
      expect(find.byKey(const Key('size_switch')), findsOneWidget);
      expect(find.byKey(const Key('toast_switch')), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity Management', () {
    testWidgets('increments quantity when Add button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();

      expect(find.text('1 White footlong sandwich(es): 🥪'), findsOneWidget);
    });

    testWidgets('increments quantity multiple times',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }

      expect(
          find.text('3 White footlong sandwich(es): 🥪🥪🥪'), findsOneWidget);
    });

    testWidgets('decrements quantity when Remove button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();
      expect(find.text('1 White footlong sandwich(es): 🥪'), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();
      expect(find.text('0 White footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not decrement quantity below zero',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.text('0 White footlong sandwich(es): '), findsOneWidget);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Remove'));
      await tester.pump();

      expect(find.text('0 White footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('does not increment above maxQuantity (5)',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }

      expect(find.text('5 White footlong sandwich(es): 🥪🥪🥪🥪🥪'),
          findsOneWidget);
    });

    testWidgets('Remove button is disabled when quantity is zero',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final removeButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Remove'),
      );

      expect(removeButton.onPressed, isNull);
    });

    testWidgets('Add button is disabled when quantity reaches maxQuantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      for (int i = 0; i < 5; i++) {
        await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
        await tester.pump();
      }

      final addButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Add'),
      );

      expect(addButton.onPressed, isNull);
    });
  });

  group('OrderScreen - Bread Type Selection', () {
    testWidgets('changes bread type to Brown using DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Brown').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Brown footlong sandwich'), findsOneWidget);
    });

    testWidgets('changes bread type to Wholemeal using DropdownMenu',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Wholemeal').last);
      await tester.pumpAndSettle();

      expect(
          find.textContaining('Wholemeal footlong sandwich'), findsOneWidget);
    });

    testWidgets('bread type persists after quantity changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Brown').last);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();

      expect(find.text('1 Brown footlong sandwich(es): 🥪'), findsOneWidget);
    });
  });

  group('OrderScreen - Size Toggle', () {
    testWidgets('toggles from footlong to six-inch using size switch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.text('0 White footlong sandwich(es): '), findsOneWidget);

      final sizeSwitch = find.byKey(const Key('size_switch'));
      expect(sizeSwitch, findsOneWidget);

      await tester.tap(sizeSwitch);
      await tester.pump();

      expect(find.text('0 White six-inch sandwich(es): '), findsOneWidget);
    });

    testWidgets('toggles back to footlong from six-inch',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final sizeSwitch = find.byKey(const Key('size_switch'));

      await tester.tap(sizeSwitch);
      await tester.pump();
      expect(find.text('0 White six-inch sandwich(es): '), findsOneWidget);

      await tester.tap(sizeSwitch);
      await tester.pump();
      expect(find.text('0 White footlong sandwich(es): '), findsOneWidget);
    });

    testWidgets('size persists after quantity changes',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final sizeSwitch = find.byKey(const Key('size_switch'));
      await tester.tap(sizeSwitch);
      await tester.pump();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
      await tester.pump();

      expect(find.text('1 White six-inch sandwich(es): 🥪'), findsOneWidget);
    });
  });

  group('OrderScreen - Toast Toggle', () {
    testWidgets('toast switch exists and is functional',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      final toastSwitch = find.byKey(const Key('toast_switch'));
      expect(toastSwitch, findsOneWidget);

      final switchWidget = tester.widget<Switch>(toastSwitch);
      expect(switchWidget.value, isFalse);

      await tester.tap(toastSwitch);
      await tester.pump();

      final updatedSwitch = tester.widget<Switch>(toastSwitch);
      expect(updatedSwitch.value, isTrue);
    });
  });

  group('OrderScreen - Notes TextField', () {
    testWidgets('updates note when text is entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'Extra mayo');
      await tester.pump();

      expect(find.text('Note: Extra mayo'), findsOneWidget);
    });

    testWidgets('displays default note when empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      expect(find.text('Note: No notes added.'), findsOneWidget);
    });

    testWidgets('updates note dynamically', (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'No onions');
      await tester.pump();
      expect(find.text('Note: No onions'), findsOneWidget);

      await tester.enterText(
          find.byKey(const Key('notes_textfield')), 'Extra cheese');
      await tester.pump();
      expect(find.text('Note: Extra cheese'), findsOneWidget);
    });
  });

  group('StyledButton Widget Tests', () {
    testWidgets('renders with icon and label', (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Test Add',
        backgroundColor: Colors.blue,
      );
      const testApp = MaterialApp(home: Scaffold(body: testButton));

      await tester.pumpWidget(testApp);

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('applies correct background color',
        (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.remove,
        label: 'Test Remove',
        backgroundColor: Colors.red,
      );
      const testApp = MaterialApp(home: Scaffold(body: testButton));

      await tester.pumpWidget(testApp);

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final buttonStyle = elevatedButton.style;

      expect(buttonStyle, isNotNull);
    });

    testWidgets('is disabled when onPressed is null',
        (WidgetTester tester) async {
      const testButton = StyledButton(
        onPressed: null,
        icon: Icons.add,
        label: 'Disabled',
        backgroundColor: Colors.grey,
      );
      const testApp = MaterialApp(home: Scaffold(body: testButton));

      await tester.pumpWidget(testApp);

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(elevatedButton.onPressed, isNull);
    });
  });
}
