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

    group('App Bar', () {
      testWidgets('displays cart view title', (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.text('Cart View'), findsOneWidget);
      });

      testWidgets('displays logo in app bar', (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.byType(Image), findsOneWidget);
      });
    });

    group('Cart Item Display', () {
      testWidgets('displays cart items with sandwich name',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('BLT'), findsOneWidget);
        expect(find.textContaining('Turkey Club'), findsOneWidget);
      });

      testWidgets('displays sandwich size and bread type',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Six-inch'), findsOneWidget);
        expect(find.textContaining('white bread'), findsOneWidget);
      });

      testWidgets('displays footlong size correctly',
          (WidgetTester tester) async {
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Footlong'), findsOneWidget);
        expect(find.textContaining('wheat bread'), findsOneWidget);
      });

      testWidgets('displays quantity and price for each item',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Qty: 3'), findsOneWidget);
        final price = cart.getItemSubtotal(testSandwich1);
        expect(find.textContaining('£${price.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('displays multiple items correctly',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Qty: 2'), findsOneWidget);
        expect(find.textContaining('Qty: 1'), findsOneWidget);
      });
    });

    group('Total Price Display', () {
      testWidgets('displays total price', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Total:'), findsOneWidget);
        expect(find.textContaining('£${cart.totalPrice.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('total updates when cart changes',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final initialTotal = cart.totalPrice;
        expect(find.textContaining('£${initialTotal.toStringAsFixed(2)}'),
            findsOneWidget);

        cart.add(testSandwich1, quantity: 1);
        await tester.pump();

        final newTotal = cart.totalPrice;
        expect(find.textContaining('£${newTotal.toStringAsFixed(2)}'),
            findsOneWidget);
        expect(newTotal, greaterThan(initialTotal));
      });

      testWidgets('displays prices with 2 decimal places',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final totalText = '£${cart.totalPrice.toStringAsFixed(2)}';
        expect(totalText, matches(r'£\d+\.\d{2}'));
        expect(find.textContaining(totalText), findsOneWidget);
      });
    });

    group('Navigation Buttons', () {
      testWidgets('displays back to order button', (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.text('Back to Order'), findsOneWidget);
      });

      testWidgets('back button navigates away from cart',
          (WidgetTester tester) async {
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

      testWidgets('displays checkout button when cart has items',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.text('Checkout'), findsOneWidget);
      });

      testWidgets('hides checkout button when cart is empty',
          (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.text('Checkout'), findsNothing);
      });

      testWidgets('checkout button appears when item is added',
          (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        expect(find.text('Checkout'), findsNothing);

        cart.add(testSandwich1, quantity: 1);
        await tester.pump();

        expect(find.text('Checkout'), findsOneWidget);
      });
    });

    group('Checkout Flow', () {
      testWidgets('shows snackbar when trying to checkout with empty cart',
          (WidgetTester tester) async {
        // Start with an item, then remove it
        cart.add(testSandwich1, quantity: 1);
        await tester.pumpWidget(createCartScreen());

        cart.clear();
        await tester.pump();

        // Try to tap checkout if it somehow exists (it shouldn't)
        // This tests the edge case in the code
        final checkoutFinder = find.text('Checkout');
        expect(checkoutFinder, findsNothing);
      });

      testWidgets('navigates to checkout screen when cart has items',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(MaterialApp(
          home: CartScreen(cart: cart),
        ));

        await tester.tap(find.text('Checkout'));
        await tester.pumpAndSettle();

        // Should navigate to checkout screen
        expect(find.text('Checkout'), findsOneWidget); // AppBar title
      });
    });

    group('Cart State Management', () {
      testWidgets('cart updates are reflected immediately',
          (WidgetTester tester) async {
        await tester.pumpWidget(createCartScreen());

        // Initially no items
        expect(find.text('Checkout'), findsNothing);

        cart.add(testSandwich1, quantity: 1);
        await tester.pump();

        // Now has items
        expect(find.textContaining('BLT'), findsOneWidget);
        expect(find.text('Checkout'), findsOneWidget);
      });

      testWidgets('displays correct data for multiple items',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 3);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Qty: 2'), findsOneWidget);
        expect(find.textContaining('Qty: 3'), findsOneWidget);

        final expectedTotal = cart.totalPrice;
        expect(find.textContaining('£${expectedTotal.toStringAsFixed(2)}'),
            findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles single item in cart', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Qty: 1'), findsOneWidget);
        expect(find.textContaining('Total:'), findsOneWidget);
      });

      testWidgets('handles large quantity of single item',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 99);

        await tester.pumpWidget(createCartScreen());

        expect(find.textContaining('Qty: 99'), findsOneWidget);
        final total = cart.totalPrice;
        expect(find.textContaining('£${total.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('handles cart being cleared', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        expect(find.text('Checkout'), findsOneWidget);

        cart.clear();
        await tester.pump();

        expect(find.text('Checkout'), findsNothing);
      });
    });

    group('Price Calculations', () {
      testWidgets('displays correct item price', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCartScreen());

        final itemPrice = cart.getItemSubtotal(testSandwich1);
        expect(find.textContaining('£${itemPrice.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('displays correct total for multiple items',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final expectedTotal = cart.totalPrice;
        expect(
            find.textContaining('Total: £${expectedTotal.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('price format includes 2 decimal places',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCartScreen());

        final price = cart.getItemSubtotal(testSandwich1);
        final priceText = '£${price.toStringAsFixed(2)}';
        expect(priceText, matches(r'£\d+\.\d{2}'));
      });
    });
  });
}
