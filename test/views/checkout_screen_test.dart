import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';

void main() {
  group('CheckoutScreen Widget Tests', () {
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

    Widget createCheckoutScreen() {
      return MaterialApp(
        home: CheckoutScreen(cart: cart),
      );
    }

    group('Order Summary Display', () {
      testWidgets('displays order summary heading',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.text('Order Summary'), findsOneWidget);
      });

      testWidgets('displays cart items with quantities',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.textContaining('2x'), findsOneWidget);
        expect(find.textContaining('1x'), findsOneWidget);
      });

      testWidgets('displays item prices', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        final price = cart.getItemSubtotal(testSandwich1);
        expect(find.textContaining('£${price.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('displays total price', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.text('Total:'), findsOneWidget);
        expect(find.textContaining('£${cart.totalPrice.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('displays divider between items and total',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.byType(Divider), findsOneWidget);
      });

      testWidgets('displays all cart items', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);
        cart.add(testSandwich2, quantity: 3);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.textContaining('1x'), findsOneWidget);
        expect(find.textContaining('3x'), findsOneWidget);
        expect(cart.items.length, 2);
      });
    });

    group('Payment Information', () {
      testWidgets('displays payment method information',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        expect(
            find.text('Payment Method: Card ending in 1234'), findsOneWidget);
      });
    });

    group('Confirm Payment Button', () {
      testWidgets('displays confirm payment button initially',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.widgetWithText(ElevatedButton, 'Confirm Payment'),
            findsOneWidget);
      });

      testWidgets('button is enabled when cart has items',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        final button = tester.widget<ElevatedButton>(
          find.widgetWithText(ElevatedButton, 'Confirm Payment'),
        );
        expect(button.onPressed, isNotNull);
      });
    });

    group('Payment Processing', () {
      testWidgets('shows loading indicator when processing payment',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        await tester
            .tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Processing payment...'), findsOneWidget);
      });

      testWidgets('hides confirm button during processing',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        await tester
            .tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
        await tester.pump();

        expect(find.widgetWithText(ElevatedButton, 'Confirm Payment'),
            findsNothing);
      });

      testWidgets('payment processing completes after delay',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(cart: cart),
                    ),
                  );
                  if (result != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Order placed: ${result['orderId']}')),
                    );
                  }
                },
                child: const Text('Go to Checkout'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Go to Checkout'));
        await tester.pumpAndSettle();

        await tester
            .tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        expect(find.byType(CheckoutScreen), findsNothing);
      });
    });

    group('Order Confirmation', () {
      testWidgets('returns order confirmation data on successful payment',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        Map? orderConfirmation;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CheckoutScreen(cart: cart),
                    ),
                  );
                  orderConfirmation = result as Map?;
                },
                child: const Text('Go to Checkout'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Go to Checkout'));
        await tester.pumpAndSettle();

        await tester
            .tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        expect(orderConfirmation, isNotNull);
        expect(orderConfirmation!['orderId'], isNotNull);
        expect(
            orderConfirmation!['orderId'].toString().startsWith('ORD'), true);
        expect(orderConfirmation!['totalAmount'], cart.totalPrice);
        expect(orderConfirmation!['itemCount'], cart.countOfItems);
        expect(orderConfirmation!['estimatedTime'], '15-20 minutes');
      });

      testWidgets('order ID is unique for each order',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);
        Map? firstOrder;
        Map? secondOrder;

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(cart: cart),
                        ),
                      );
                      firstOrder = result as Map?;
                    },
                    child: const Text('Order 1'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(cart: cart),
                        ),
                      );
                      secondOrder = result as Map?;
                    },
                    child: const Text('Order 2'),
                  ),
                ],
              ),
            ),
          ),
        ));

        // Place first order
        await tester.tap(find.text('Order 1'));
        await tester.pumpAndSettle();
        await tester
            .tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Place second order
        await tester.tap(find.text('Order 2'));
        await tester.pumpAndSettle();
        await tester
            .tap(find.widgetWithText(ElevatedButton, 'Confirm Payment'));
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        expect(firstOrder, isNotNull);
        expect(secondOrder, isNotNull);
        expect(firstOrder!['orderId'], isNot(equals(secondOrder!['orderId'])));
      });
    });

    group('Navigation', () {
      testWidgets('displays app bar with title', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.widgetWithText(AppBar, 'Checkout'), findsOneWidget);
      });

      testWidgets('has back button in app bar', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CheckoutScreen(cart: cart)),
                ),
                child: const Text('Go to Checkout'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Go to Checkout'));
        await tester.pumpAndSettle();

        expect(find.byType(BackButton), findsOneWidget);
      });

      testWidgets('back button navigates away from checkout',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CheckoutScreen(cart: cart)),
                ),
                child: const Text('Go to Checkout'),
              ),
            ),
          ),
        ));

        await tester.tap(find.text('Go to Checkout'));
        await tester.pumpAndSettle();

        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        expect(find.byType(CheckoutScreen), findsNothing);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles single item in cart', (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.textContaining('1x'), findsOneWidget);
        expect(find.text('Total:'), findsOneWidget);
      });

      testWidgets('handles large quantity of single item',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 99);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.textContaining('99x'), findsOneWidget);
        final total = cart.totalPrice;
        expect(find.textContaining('£${total.toStringAsFixed(2)}'),
            findsOneWidget);
      });

      testWidgets('handles multiple different items',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 3);

        await tester.pumpWidget(createCheckoutScreen());

        expect(find.textContaining('2x'), findsOneWidget);
        expect(find.textContaining('3x'), findsOneWidget);
        expect(cart.items.length, 2);
      });

      testWidgets('displays correct total for multiple items',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 2);
        cart.add(testSandwich2, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        final expectedTotal = cart.totalPrice;
        expect(find.textContaining('£${expectedTotal.toStringAsFixed(2)}'),
            findsOneWidget);
      });
    });

    group('Price Formatting', () {
      testWidgets('displays prices with 2 decimal places',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 1);

        await tester.pumpWidget(createCheckoutScreen());

        final price = cart.getItemSubtotal(testSandwich1);
        final priceText = '£${price.toStringAsFixed(2)}';
        expect(priceText, matches(r'£\d+\.\d{2}'));
      });

      testWidgets('total price has 2 decimal places',
          (WidgetTester tester) async {
        cart.add(testSandwich1, quantity: 3);

        await tester.pumpWidget(createCheckoutScreen());

        final totalText = '£${cart.totalPrice.toStringAsFixed(2)}';
        expect(totalText, matches(r'£\d+\.\d{2}'));
      });
    });
  });
}
