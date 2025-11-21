import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App renders OrderScreen as home', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });

  group('OrderScreen - Initial State', () {
    testWidgets('displays initial state correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Sandwich Type'), findsAtLeastNWidgets(1));
      expect(find.text('Bread Type'), findsAtLeastNWidgets(1));
      expect(find.text('Quantity: '), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('Add to Cart'), findsOneWidget);
    });
  });

  group('OrderScreen - Quantity Management', () {
    testWidgets('increments quantity when + button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Scroll to make button visible
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('decrements quantity when - button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Increment first
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('2'), findsOneWidget);

      // Now decrement
      await tester.ensureVisible(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });
  });

  group('OrderScreen - Sandwich Type Selection', () {
    testWidgets('displays sandwich type dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Type'), findsAtLeastNWidgets(1));
      expect(find.text('Veggie Delight'), findsAtLeastNWidgets(1));
      expect(find.byType(DropdownMenu<SandwichType>), findsOneWidget);
    });

    testWidgets('can select different sandwich types',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Tap dropdown
      await tester.tap(find.byType(DropdownMenu<SandwichType>));
      await tester.pumpAndSettle();

      // Verify menu items exist
      expect(find.text('Chicken Teriyaki'), findsWidgets);
      expect(find.text('Tuna Melt'), findsWidgets);
      expect(find.text('Meatball Marinara'), findsWidgets);
    });
  });

  group('OrderScreen - Bread Type Selection', () {
    testWidgets('displays bread type dropdown', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Bread Type'), findsAtLeastNWidgets(1));
      expect(find.byType(DropdownMenu<BreadType>), findsOneWidget);
    });

    testWidgets('displays all bread options', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Tap dropdown
      await tester.tap(find.byType(DropdownMenu<BreadType>));
      await tester.pumpAndSettle();

      // Check bread types are available
      expect(find.text('white'), findsWidgets);
      expect(find.text('wheat'), findsWidgets);
      expect(find.text('wholemeal'), findsWidgets);
    });
  });

  group('OrderScreen - Size Toggle', () {
    testWidgets('displays size toggle switches', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Six-inch'), findsOneWidget);
      expect(find.text('Footlong'), findsOneWidget);
    });
  });

  group('OrderScreen - Add to Cart Button', () {
    testWidgets('displays Add to Cart button', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Add to Cart'), findsOneWidget);
      expect(find.byType(StyledButton), findsOneWidget);
    });

    testWidgets('Add to Cart button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      final addToCartButton = find.text('Add to Cart');

      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      expect(addToCartButton, findsOneWidget);

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Button should still be visible after tap
      expect(addToCartButton, findsOneWidget);
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
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Test Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
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
      await tester.pumpAndSettle();

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(elevatedButton.onPressed, isNull);
    });

    testWidgets('is enabled when onPressed is provided',
        (WidgetTester tester) async {
      var tapped = false;
      final testButton = StyledButton(
        onPressed: () => tapped = true,
        icon: Icons.check,
        label: 'Enabled',
        backgroundColor: Colors.green,
      );
      final testApp = MaterialApp(home: Scaffold(body: testButton));

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('OrderScreen - Cart Summary', () {
    testWidgets('displays initial cart summary with zero items',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      expect(find.text('Cart Summary'), findsOneWidget);
      expect(find.text('0 item(s)'), findsOneWidget);
      expect(find.text('£0.00'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
    });

    testWidgets('updates cart summary when item is added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('0 item(s)'), findsOneWidget);
      expect(find.text('£0.00'), findsOneWidget);

      // Add item to cart
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Verify cart updated
      expect(find.text('1 item(s)'), findsOneWidget);
      expect(find.text('0 item(s)'), findsNothing);

      // Price should be greater than 0
      expect(find.textContaining('£'), findsWidgets);
      expect(find.text('£0.00'), findsNothing);
    });

    testWidgets('updates cart summary with multiple quantities',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Increase quantity to 3
      await tester.ensureVisible(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      // Add to cart
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Verify cart shows 3 items
      expect(find.text('3 item(s)'), findsOneWidget);
    });

    testWidgets('updates total price correctly when multiple items added',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Add first item
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Wait for SnackBar to dismiss
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // Get first price
      final firstPriceFinder = find.textContaining('£').last;
      final firstPriceText = tester.widget<Text>(firstPriceFinder).data!;

      // Add second item
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();

      // Verify item count increased
      expect(find.text('2 item(s)'), findsOneWidget);

      // Get second price
      final secondPriceFinder = find.textContaining('£').last;
      final secondPriceText = tester.widget<Text>(secondPriceFinder).data!;

      // Second price should be different (higher) than first
      expect(secondPriceText, isNot(equals(firstPriceText)));
    });

    testWidgets('cart summary displays in a Card widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Verify card exists
      expect(find.byType(Card), findsWidgets);

      // Verify cart summary is within the card
      final card = find.ancestor(
        of: find.text('Cart Summary'),
        matching: find.byType(Card),
      );
      expect(card, findsOneWidget);
    });
  });

  group('OrderScreen - On-Screen Confirmation', () {
    testWidgets('shows SnackBar when item is added to cart',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pump(); // Start the animation
      await tester.pump(const Duration(milliseconds: 100)); // Advance animation

      // Verify SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to cart successfully!'), findsOneWidget);
    });

    testWidgets('SnackBar contains UNDO action', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify UNDO action exists
      expect(find.text('UNDO'), findsOneWidget);
      expect(find.byType(SnackBarAction), findsOneWidget);
    });

    testWidgets('UNDO button is tappable', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Add item to cart
      await tester.ensureVisible(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add to Cart'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap UNDO button
      await tester.tap(find.text('UNDO'));
      await tester.pumpAndSettle();

      // SnackBar should be dismissed after tapping UNDO
      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
