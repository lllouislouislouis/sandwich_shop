import 'package:flutter/material.dart';
import '../views/app_styles.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Text editing controllers
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  // Error state variables
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    // Add listeners to clear errors when user types
    _usernameController.addListener(_clearUsernameError);
    _passwordController.addListener(_clearPasswordError);
  }

  @override
  void dispose() {
    // Remove listeners before disposing
    _usernameController.removeListener(_clearUsernameError);
    _passwordController.removeListener(_clearPasswordError);

    // Dispose controllers to prevent memory leaks
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearUsernameError() {
    if (_usernameError != null) {
      setState(() {
        _usernameError = null;
      });
    }
  }

  void _clearPasswordError() {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
      });
    }
  }

  bool _validateForm() {
    bool isValid = true;

    setState(() {
      // Reset errors
      _usernameError = null;
      _passwordError = null;

      // Validate username
      if (_usernameController.text.trim().isEmpty) {
        _usernameError = 'Username is required';
        isValid = false;
      } else if (_usernameController.text.trim().length < 3) {
        _usernameError = 'Username must be at least 3 characters';
        isValid = false;
      }

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Password is required';
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        isValid = false;
      }
    });

    return isValid;
  }

  void _handleSignIn() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    if (_validateForm()) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Welcome, ${_usernameController.text}! Sign-in successful.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Clear form
      _usernameController.clear();
      _passwordController.clear();

      // Navigate back to order screen
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            child: Image.asset('assets/images/logo.png'),
          ),
        ),
        title: Text(
          'Sign In',
          style: heading1,
        ),
        actions: [
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_cart),
                      const SizedBox(width: 4),
                      Text('${cart.countOfItems}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // App title and icon
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                const Icon(Icons.restaurant_menu, size: 32, color: Colors.orange),
                const SizedBox(width: 8),
                Text('Sandwich Shop', style: heading1),
              ],
            ),
            const SizedBox(height: 12),
            // Subtitle
            Center(
              child: Text(
                'Sign in to start ordering',
                style: heading2,
              ),
            ),
            const SizedBox(height: 30),
            Text('Please sign in:', style: heading2),
            const SizedBox(height: 20),
            // Username field
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Enter your username',
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
                errorText: _usernameError,
              ),
            ),
            const SizedBox(height: 16),
            // Password field
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                errorText: _passwordError,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
