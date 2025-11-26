import 'package:flutter/material.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

class CartScreen extends StatelessWidget {
  final Cart cart;

  const CartScreen({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, child) {
          if (cart.isEmpty) {
            return _buildEmptyCart(context);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final sandwich = cart.items.keys.elementAt(index);
                    final quantity = cart.items[sandwich]!;
                    return _buildCartItem(context, sandwich, quantity);
                  },
                ),
              ),
              _buildCartTotal(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some sandwiches to get started!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, Sandwich sandwich, int quantity) {
    final subtotal = cart.getItemSubtotal(sandwich);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sandwich.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sandwich.isFootlong ? 'Footlong' : '6-inch',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                // Decrease quantity button
                IconButton(
                  onPressed: () => cart.remove(sandwich),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: Theme.of(context).colorScheme.primary,
                  iconSize: 32,
                  tooltip: 'Decrease quantity',
                ),
                // Quantity display
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                // Increase quantity button
                IconButton(
                  onPressed: () => cart.add(sandwich),
                  icon: const Icon(Icons.add_circle_outline),
                  color: Theme.of(context).colorScheme.primary,
                  iconSize: 32,
                  tooltip: 'Increase quantity',
                ),
                const SizedBox(width: 8),
                // Remove item button
                IconButton(
                  onPressed: () =>
                      _showRemoveDialog(context, sandwich, quantity),
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red[400],
                  iconSize: 28,
                  tooltip: 'Remove item',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTotal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${cart.totalPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed:
                  cart.isEmpty ? null : () => _proceedToCheckout(context),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(
      BuildContext context, Sandwich sandwich, int quantity) {
    if (quantity > 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Remove Item?'),
            content: Text(
              'Remove ${sandwich.name} (quantity: $quantity) from your cart?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  cart.removeItem(sandwich);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${sandwich.name} removed from cart'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    } else {
      cart.removeItem(sandwich);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${sandwich.name} removed from cart'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _proceedToCheckout(BuildContext context) {
    // Placeholder for checkout functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout functionality not yet implemented'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
