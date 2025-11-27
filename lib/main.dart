import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/about_screen.dart';
import 'package:sandwich_shop/views/auth_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Cart(),
      child: MaterialApp(
        title: 'Sandwich Shop App',
        home: const OrderScreen(maxQuantity: 5),
        routes: {
          '/about': (context) => const AboutScreen(),
        },
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key, required this.maxQuantity});

  final int maxQuantity;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // ...existing state variables...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Shop - Order'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ...existing widgets (size toggle, bread dropdown, notes field, etc.)...

            const SizedBox(height: 24),

            // Navigation to Sign In Screen
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign In to Your Account'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.orange,
                side: const BorderSide(color: Colors.orange, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
