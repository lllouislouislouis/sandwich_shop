import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/order_screen.dart';
import 'package:sandwich_shop/views/checkout_screen.dart';
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
        initialRoute: '/',
        routes: {
          '/': (context) => const OrderScreen(maxQuantity: 5),
          '/about': (context) => const AboutScreen(),
          '/auth': (context) => const AuthScreen(),
        },
        onGenerateRoute: (settings) {
          // Handle the checkout route specially to pass the cart
          if (settings.name == '/checkout') {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                final cart = Provider.of<Cart>(context, listen: false);
                return CheckoutScreen(cart: cart);
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
