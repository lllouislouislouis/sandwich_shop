import 'package:flutter/material.dart';
import 'package:sandwich_shop/widgets/app_scaffold.dart';
import '../views/app_styles.dart';

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
          content: Text(
            'Welcome, ${_usernameController.text}!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
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
    return AppScaffold(
      title: 'Sign In',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App Logo or Icon
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.orange,
                ),
                const SizedBox(height: 32),

                // Welcome Text
                const Text(
                  'Welcome Back!',
                  style: heading1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  style: normalText,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Username Field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: normalText,
                    errorText: _usernameError,
                    prefixIcon: const Icon(Icons.person),
                    border: const OutlineInputBorder(),
                  ),
                  style: normalText,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: normalText,
                    errorText: _passwordError,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                  style: normalText,
                ),
                const SizedBox(height: 24),

                // Sign In Button
                ElevatedButton(
                  onPressed: _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: heading2,
                  ),
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 16),

                // Register Link (placeholder)
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration coming soon!'),
                      ),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Register',
                    style: normalText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
