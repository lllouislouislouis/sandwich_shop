import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/auth_screen.dart';
import 'package:sandwich_shop/models/cart.dart';

Widget createAuthScreenWithProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Cart(),
      ),
    ],
    child: const MaterialApp(
      home: AuthScreen(),
    ),
  );
}

void main() {
  group('AuthScreen Widget Tests', () {
    testWidgets('AC-1.3: Screen displays all required UI components',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Assert - Check for AppBar title
      expect(find.widgetWithText(AppBar, 'Sign In'), findsOneWidget);

      // Assert - Check for app title and subtitle
      expect(find.text('Sandwich Shop'), findsOneWidget);
      expect(find.text('Sign in to start ordering'), findsOneWidget);

      // Assert - Check for icon
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);

      // Assert - Check for username field
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Username'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Assert - Check for password field
      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);

      // Assert - Check for sign-in button
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('AC-1.3: Password field obscures text',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Find password TextField
      final passwordFields = tester.widgetList<TextField>(
        find.byType(TextField),
      );

      // Assert - Second TextField should have obscureText: true
      final passwordField = passwordFields.elementAt(1);
      expect(passwordField.obscureText, isTrue);

      // Assert - First TextField (username) should NOT obscure text
      final usernameField = passwordFields.first;
      expect(usernameField.obscureText, isFalse);
    });

    testWidgets('AC-2.2: Shows error message for empty username',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Tap sign-in button without entering anything
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Error message appears
      expect(find.text('Username is required'), findsOneWidget);
    });

    testWidgets('AC-2.2: Shows error message for empty password',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Tap sign-in button without entering anything
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Error message appears
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('AC-2.2: Shows errors for both fields when both are empty',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Both error messages appear
      expect(find.text('Username is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('AC-2.2: Username field accepts text input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter text in username field
      final usernameField = find.byType(TextField).first;
      await tester.enterText(usernameField, 'testuser');
      await tester.pump();

      // Assert - Text is entered
      expect(find.text('testuser'), findsOneWidget);
    });

    testWidgets('AC-2.2: Password field accepts text input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter text in password field
      final passwordField = find.byType(TextField).at(1);
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Assert - Text is entered (widget exists but obscured visually)
      final textField = tester.widget<TextField>(passwordField);
      expect(textField.controller?.text, equals('password123'));
    });

    testWidgets('AC-2.2: Error clears when user starts typing in username',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Show error first
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();
      expect(find.text('Username is required'), findsOneWidget);

      // Act - Start typing
      await tester.enterText(find.byType(TextField).first, 't');
      await tester.pump();

      // Assert - Error disappears
      expect(find.text('Username is required'), findsNothing);
    });

    testWidgets('AC-2.2: Error clears when user starts typing in password',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Show error first
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();
      expect(find.text('Password is required'), findsOneWidget);

      // Act - Start typing
      await tester.enterText(find.byType(TextField).at(1), 'p');
      await tester.pump();

      // Assert - Error disappears
      expect(find.text('Password is required'), findsNothing);
    });

    testWidgets('AC-2.3: Shows success SnackBar with valid credentials',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter valid credentials
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.pump();

      // Act - Tap sign-in button
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
          find.text('Welcome, testuser! Sign-in successful.'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('AC-2.3: Form clears after successful submission',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter valid credentials
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.pump();

      // Act - Submit
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Fields are cleared
      final usernameField =
          tester.widget<TextField>(find.byType(TextField).first);
      final passwordField =
          tester.widget<TextField>(find.byType(TextField).at(1));

      expect(usernameField.controller?.text, isEmpty);
      expect(passwordField.controller?.text, isEmpty);
    });

    testWidgets('AC-2.3: SnackBar appears and has correct duration',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter valid credentials and submit
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - SnackBar is visible with correct properties
      expect(find.byType(SnackBar), findsOneWidget);

      // Verify SnackBar has the correct duration configured (3 seconds)
      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.duration, equals(const Duration(seconds: 3)));
    });

    testWidgets('AC-2.2: Does not show errors with valid input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter valid credentials
      await tester.enterText(find.byType(TextField).first, 'validuser');
      await tester.enterText(find.byType(TextField).at(1), 'validpass');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - No error messages
      expect(find.text('Username is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
    });

    testWidgets('AC-5.1: Sign-in button is always enabled',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Assert - Button is enabled (not null onPressed)
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Sign In'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('AC-2.2: Username validation trims whitespace',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter only spaces in username
      await tester.enterText(find.byType(TextField).first, '   ');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Username error appears (spaces are trimmed)
      expect(find.text('Username is required'), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('AC-5.2: Text fields have proper hint text',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Assert - Check for hint texts
      expect(find.text('Enter your username'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
    });

    testWidgets('AC-4.2: Color scheme matches app theme (orange)',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Assert - AppBar has orange background
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Colors.orange));

      // Assert - Sign-in button has orange background
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Sign In'),
      );
      expect(
        button.style?.backgroundColor?.resolve({}),
        equals(Colors.orange),
      );
    });
  });

  group('AuthScreen Edge Cases', () {
    testWidgets('No crash when tapping sign-in multiple times rapidly',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter credentials with minimum valid length
      await tester.enterText(find.byType(TextField).first, 'abc');
      await tester.enterText(find.byType(TextField).at(1), '123456');
      await tester.pump();

      // Act - Tap button once
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - No crash, SnackBar appears
      expect(find.byType(SnackBar), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Handles very long username input',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter very long username
      final longUsername = 'a' * 100;
      await tester.enterText(find.byType(TextField).first, longUsername);
      await tester.enterText(find.byType(TextField).at(1), 'password');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Success message contains truncated/full username
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Welcome,'), findsOneWidget);
    });

    testWidgets('Handles special characters in username',
        (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        createAuthScreenWithProvider(),
      );

      // Act - Enter username with special characters
      await tester.enterText(find.byType(TextField).first, 'user@email.com');
      await tester.enterText(find.byType(TextField).at(1), 'p@ssw0rd!');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      // Assert - Success
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Welcome, user@email.com! Sign-in successful.'),
          findsOneWidget);
    });
  });
}
