import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
  });

  void _handleNavigation(BuildContext context, String routeName) {
    // Close the drawer first
    Navigator.pop(context);

    // Get current route
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Don't navigate if already on the target screen
    if (currentRoute == routeName) {
      return;
    }

    // For checkout, verify cart has items
    if (routeName == '/checkout') {
      final cart = Provider.of<Cart>(context, listen: false);

      if (cart.countOfItems == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your cart is empty. Add items before checking out.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }
    }

    // Navigate to the target screen
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: heading1),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.orange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // App Logo
                  SizedBox(
                    height: 60,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.restaurant_menu,
                          size: 60,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Sandwich Shop',
                    style: heading2.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Order Menu Item
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Colors.orange),
              title: const Text('Order', style: normalText),
              onTap: () => _handleNavigation(context, '/'),
            ),

            // Checkout Menu Item
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.orange),
              title: const Text('Checkout', style: normalText),
              onTap: () => _handleNavigation(context, '/checkout'),
            ),

            // Sign In Menu Item
            ListTile(
              leading: const Icon(Icons.login, color: Colors.orange),
              title: const Text('Sign In', style: normalText),
              onTap: () => _handleNavigation(context, '/auth'),
            ),

            // About Us Menu Item
            ListTile(
              leading: const Icon(Icons.info, color: Colors.orange),
              title: const Text('About Us', style: normalText),
              onTap: () => _handleNavigation(context, '/about'),
            ),
          ],
        ),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
