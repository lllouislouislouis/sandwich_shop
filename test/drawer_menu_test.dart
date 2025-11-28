import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/main.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/auth_screen.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
import 'package:sandwich_shop/views/cart_screen.dart';

void main() {
  group('Drawer Menu Tests', () {
    testWidgets('App opens with OrderScreen as home',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());

      // Verify OrderScreen is displayed
      expect(find.byType(OrderScreen), findsOneWidget);
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('Navigate to Auth screen from order screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Scroll to make Sign In button visible
      final signInButton = find.text('Sign In');
      expect(signInButton, findsOneWidget);

      await tester.ensureVisible(signInButton);
      await tester.pumpAndSettle();

      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Verify AuthScreen is displayed
      expect(find.byType(AuthScreen), findsOneWidget);
      expect(find.text('Welcome Back!'), findsOneWidget);
    });

    testWidgets('Navigate to cart screen', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Find and scroll to "View Cart" button
      final viewCartFinder = find.textContaining('View Cart');
      expect(viewCartFinder, findsOneWidget);

      await tester.ensureVisible(viewCartFinder);
      await tester.pumpAndSettle();

      await tester.tap(viewCartFinder);
      await tester.pumpAndSettle();

      // Verify we navigated to CartScreen
      expect(find.byType(CartScreen), findsOneWidget);
    });

    testWidgets('Back navigation returns to OrderScreen from AuthScreen',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Navigate to Auth screen
      final signInButton = find.text('Sign In');
      await tester.ensureVisible(signInButton);
      await tester.pumpAndSettle();
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen), findsOneWidget);

      // Navigate back using back button
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Verify we're back on OrderScreen
        expect(find.byType(OrderScreen), findsOneWidget);
        expect(find.text('Sandwich Counter'), findsOneWidget);
      } else {
        // Use Navigator.pop if no back button
        final NavigatorState navigator = tester.state(find.byType(Navigator));
        navigator.pop();
        await tester.pumpAndSettle();
        expect(find.byType(OrderScreen), findsOneWidget);
      }
    });

    testWidgets('AppBar contains title', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Verify AppBar exists with title
      expect(find.text('Sandwich Counter'), findsOneWidget);
    });

    testWidgets('Navigation maintains app state', (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byType(OrderScreen), findsOneWidget);

      // Navigate to AuthScreen
      final signInButton = find.text('Sign In');
      await tester.ensureVisible(signInButton);
      await tester.pumpAndSettle();
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      expect(find.byType(AuthScreen), findsOneWidget);

      // App should maintain state through navigation
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Add to cart button is enabled with positive quantity',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Find the add to cart button
      final addToCartButton =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      expect(addToCartButton, findsOneWidget);

      // Button should be enabled when quantity is 1 (default)
      final ElevatedButton button = tester.widget(addToCartButton);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('Cart displays correct item count',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Initially cart should have 0 items
      expect(find.textContaining('View Cart (0 items)'), findsOneWidget);

      // Add an item to cart
      final addToCartButton =
          find.widgetWithText(ElevatedButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Cart should now show 1 item
      expect(find.textContaining('View Cart (1 items)'), findsOneWidget);
    });

    testWidgets('Quantity can be increased and decreased',
        (WidgetTester tester) async {
      await tester.pumpWidget(const App());
      await tester.pumpAndSettle();

      // Find quantity display (starts at 1)
      expect(find.text('1'), findsWidgets);

      // Find and tap the add button - ensure it's visible first
      final addButton = find.widgetWithIcon(IconButton, Icons.add);
      expect(addButton, findsOneWidget);

      await tester.ensureVisible(addButton);
      await tester.pumpAndSettle();

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Quantity should now be 2
      expect(find.text('2'), findsWidgets);

      // Find and tap the remove button
      final removeButton = find.widgetWithIcon(IconButton, Icons.remove);
      expect(removeButton, findsOneWidget);

      await tester.ensureVisible(removeButton);
      await tester.pumpAndSettle();

      await tester.tap(removeButton);
      await tester.pumpAndSettle();

      // Quantity should be back to 1
      expect(find.text('1'), findsWidgets);
    });
  });
}
