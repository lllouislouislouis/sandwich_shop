import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  group('CartScreen Widget Tests', () {
    late Cart cart;
    late Sandwich testSandwich1;
    late Sandwich testSandwich2;

    setUp(() {
      cart = Cart();
      testSandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: false,
      );
      testSandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        breadType: BreadType.wheat,
        isFootlong: true,
      );
    });

    Widget createCartScreen() {
      return MaterialApp(
        home: CartScreen(cart: cart),
      );
    }

    group('Empty Cart State (AC-008)', () {
      testWidgets('displays empty cart message when cart is empty',
          (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.text('Your cart is empty'), findsOneWidget);
        expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
        expect(
            find.text('Add some sandwiches to get started!'), findsOneWidget);
      });

      testWidgets('displays back to order button in empty state',
          (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.widgetWithText(ElevatedButton, 'Back to Order'),
            findsOneWidget);
      });

      testWidgets('back button pops navigation', (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartScreen(cart: cart)),
                ),
                child: const Text('Go to Cart'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Go to Cart'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Back to Order'));
        await tester.pumpAndSettle();

        expect(find.byType(CartScreen), findsNothing);
      });
    });

    group('Cart Item Display (AC-004, AC-018)', () {
      testWidgets('displays cart items with correct information',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('BLT'), findsOneWidget);
        expect(find.text('6-inch'), findsOneWidget);
        expect(find.textContaining('Turkey Club'), findsOneWidget);
        expect(find.text('Footlong'), findsOneWidget);
      });

      testWidgets('displays quantity for each item',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        expect(find.text('3'), findsOneWidget);
      });

      testWidgets('displays item subtotals', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        final subtotal = cart.getItemSubtotal(testSandwich1);
        expect(find.text('\$${subtotal.toStringAsFixed(2)}'), findsOneWidget);
      });
    });

    group('Quantity Adjustment - Increase (AC-001)', () {
      testWidgets('displays increase quantity button',
          (WidgetTester tester) async {
        cart.add(testSandwich1);

        await tester.pumpWidget(createCartScreen());

        expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
      });

      testWidgets('increases quantity by 1 when tapped',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        expect(find.text('2'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();

        expect(find.text('3'), findsOneWidget);
        expect(cart.getQuantity(testSandwich1), 3);
      });

      testWidgets('updates item subtotal immediately after increase',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final initialSubtotal = cart.getItemSubtotal(testSandwich1);

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();

        final newSubtotal = cart.getItemSubtotal(testSandwich1);
        expect(newSubtotal, greaterThan(initialSubtotal));
      });

      testWidgets('updates cart total after quantity increase',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final initialTotal = cart.totalPrice;

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();

        final newTotal = cart.totalPrice;
        expect(newTotal, greaterThan(initialTotal));
      });
    });

    group('Quantity Adjustment - Decrease (AC-002)', () {
      testWidgets('displays decrease quantity button',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        expect(find.byIcon(Icons.remove_circle_outline), findsOneWidget);
      });

      testWidgets('decreases quantity by 1 when tapped',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        expect(find.text('3'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pump();

        expect(find.text('2'), findsOneWidget);
        expect(cart.getQuantity(testSandwich1), 2);
      });

      testWidgets('updates item subtotal immediately after decrease',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        final initialSubtotal = cart.getItemSubtotal(testSandwich1);

        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pump();

        final newSubtotal = cart.getItemSubtotal(testSandwich1);
        expect(newSubtotal, lessThan(initialSubtotal));
      });

      testWidgets('updates cart total after quantity decrease',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        final initialTotal = cart.totalPrice;

        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pump();

        final newTotal = cart.totalPrice;
        expect(newTotal, lessThan(initialTotal));
      });
    });

    group('Auto-Remove at Zero Quantity (AC-003)', () {
      testWidgets('removes item when quantity reaches zero',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.text('BLT'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pumpAndSettle();

        expect(find.text('BLT'), findsNothing);
        expect(cart.isEmpty, true);
      });

      testWidgets('displays empty state after last item removed',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pumpAndSettle();

        expect(find.text('Your cart is empty'), findsOneWidget);
      });

      testWidgets('updates total to zero when last item removed',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.byIcon(Icons.remove_circle_outline));
        await tester.pump();

        expect(cart.totalPrice, 0.0);
      });
    });

    group('Quick Remove Item (AC-005, AC-006, AC-007)', () {
      testWidgets('displays remove button for each item',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      });

      testWidgets('shows confirmation dialog for items with quantity > 1',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        expect(find.text('Remove Item?'), findsOneWidget);
        expect(find.textContaining('BLT'), findsOneWidget);
        expect(find.textContaining('quantity: 3'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Remove'), findsOneWidget);
      });

      testWidgets('cancel button in dialog does not remove item',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.textContaining('BLT'), findsOneWidget);
        expect(cart.getQuantity(testSandwich1), 2);
      });

      testWidgets('confirm button in dialog removes item',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();

        expect(find.textContaining('BLT'), findsNothing);
        expect(cart.getQuantity(testSandwich1), 0);
      });

      testWidgets('shows snackbar confirmation after removal',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Remove'));
        await tester.pumpAndSettle();

        expect(find.textContaining('removed from cart'), findsOneWidget);
      });

      testWidgets('removes item immediately when quantity is 1',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.byIcon(Icons.delete_outline));
        await tester.pumpAndSettle();

        expect(find.text('Remove Item?'), findsNothing);
        expect(find.textContaining('BLT'), findsNothing);
        expect(cart.isEmpty, true);
      });
    });

    group('Cart Total Display (AC-009, AC-014)', () {
      testWidgets('displays cart total at bottom of screen',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        expect(find.text('Total'), findsOneWidget);
        expect(find.text('\$${cart.totalPrice.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('updates total in real-time when quantity changes',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final initialTotal = cart.totalPrice;
        expect(
            find.text('\$${initialTotal.toStringAsFixed(2)}'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.add_circle_outline));
        await tester.pump();

        final newTotal = cart.totalPrice;
        expect(find.text('\$${newTotal.toStringAsFixed(2)}'), findsOneWidget);
        expect(newTotal, greaterThan(initialTotal));
      });

      testWidgets('displays prices with 2 decimal places',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final totalText = '\$${cart.totalPrice.toStringAsFixed(2)}';
        expect(totalText, matches(r'\$\d+\.\d{2}'));
        expect(find.text(totalText), findsOneWidget);
      });
    });

    group('Checkout Button (AC-018)', () {
      testWidgets('displays checkout button', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.widgetWithText(ElevatedButton, 'Checkout'), findsOneWidget);
      });

      testWidgets('checkout button is disabled when cart is empty',
          (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());
        await tester.pump();

        // Navigate away from empty state to see the checkout button
        cart.add(testSandwich1, quantity: 1);
        await tester.pump();

        cart.removeItem(testSandwich1);
        await tester.pumpAndSettle();

        // In empty state, checkout button shouldn't be visible
        expect(find.widgetWithText(ElevatedButton, 'Checkout'), findsNothing);
      });

      testWidgets('checkout button shows placeholder message when tapped',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        await tester.tap(find.widgetWithText(ElevatedButton, 'Checkout'));
        await tester.pumpAndSettle();

        expect(find.text('Checkout functionality not yet implemented'),
            findsOneWidget);
      });
    });

    group('Multiple Items (AC-018)', () {
      testWidgets('displays multiple different items correctly',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('BLT'), findsOneWidget);
        expect(find.textContaining('Turkey Club'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('each item has its own quantity controls',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.byIcon(Icons.add_circle_outline), findsNWidgets(2));
        expect(find.byIcon(Icons.remove_circle_outline), findsNWidgets(2));
        expect(find.byIcon(Icons.delete_outline), findsNWidgets(2));
      });

      testWidgets('modifying one item does not affect others',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        // Increase first item quantity
        final addButtons = find.byIcon(Icons.add_circle_outline);
        await tester.tap(addButtons.first);
        await tester.pump();

        expect(cart.getQuantity(testSandwich1), 3);
        expect(cart.getQuantity(testSandwich2), 3);
      });
    });

    group('Accessibility (AC-017)', () {
      testWidgets('buttons have semantic labels', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        expect(find.byTooltip('Increase quantity'), findsOneWidget);
        expect(find.byTooltip('Decrease quantity'), findsOneWidget);
        expect(find.byTooltip('Remove item'), findsOneWidget);
      });
    });

    group('State Management (AC-013)', () {
      testWidgets('cart updates are reflected immediately',
          (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.text('Your cart is empty'), findsOneWidget);

        cart.add(testSandwich1, quantity: 1);
        await tester.pump();

        expect(find.textContaining('BLT'), findsOneWidget);
        expect(find.text('Your cart is empty'), findsNothing);
      });

      testWidgets('rapid button taps are handled correctly',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final addButton = find.byIcon(Icons.add_circle_outline);

        // Tap multiple times rapidly
        await tester.tap(addButton);
        await tester.tap(addButton);
        await tester.tap(addButton);
        await tester.pump();

        expect(cart.getQuantity(testSandwich1), 4);
      });
    });
  });
}
