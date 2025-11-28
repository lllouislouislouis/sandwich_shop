import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:sandwich_shop/widgets/app_scaffold.dart';

class CheckoutScreen extends StatefulWidget {
  final Cart cart;

  const CheckoutScreen({super.key, required this.cart});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    // A fake delay to simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    final Map orderConfirmation = {
      'orderId': orderId,
      'timestamp': currentTime.toString(),
      'items': widget.cart.countOfItems,
      'total': widget.cart.totalPrice,
    };

    // Check if this State object is being shown in the widget tree
    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Order Confirmed!'),
            content: Text(
              'Order ID: ${orderConfirmation['orderId']}\n'
              'Items: ${orderConfirmation['items']}\n'
              'Total: £${orderConfirmation['total'].toStringAsFixed(2)}\n\n'
              'Thank you for your order!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context)
                      .pushReplacementNamed('/'); // Return to order screen
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      // Clear the cart after successful order
      widget.cart.clear();
    }
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
        quantity: quantity, isFootlong: sandwich.isFootlong);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnChildren = [];

    columnChildren.add(const Text('Order Summary', style: heading2));
    columnChildren.add(const SizedBox(height: 20));

    for (MapEntry<Sandwich, int> entry in widget.cart.items.entries) {
      final Sandwich sandwich = entry.key;
      final int quantity = entry.value;
      final double itemPrice = _calculateItemPrice(sandwich, quantity);

      final Widget itemCard = Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sandwich.name,
                style: heading2.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Size: ${sandwich.isFootlong ? 'Footlong' : '6"'}',
                style: normalText,
              ),
              Text(
                'Bread: ${sandwich.breadType.name}',
                style: normalText,
              ),
              Text(
                'Quantity: $quantity',
                style: normalText,
              ),
              const SizedBox(height: 8),
              Text(
                'Price: £${itemPrice.toStringAsFixed(2)}',
                style: heading2.copyWith(fontSize: 16),
              ),
            ],
          ),
        ),
      );
      columnChildren.add(itemCard);
    }

    columnChildren.add(const Divider());
    columnChildren.add(const SizedBox(height: 10));

    final Widget totalRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Total:', style: heading2),
        Text(
          '£${widget.cart.totalPrice.toStringAsFixed(2)}',
          style: heading2.copyWith(color: Colors.green),
        ),
      ],
    );
    columnChildren.add(totalRow);
    columnChildren.add(const SizedBox(height: 40));

    final Widget checkoutButton = ElevatedButton(
      onPressed: _isProcessing ? null : _processPayment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: heading2,
      ),
      child: _isProcessing
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 12),
                Text('Processing...'),
              ],
            )
          : const Text('Complete Payment'),
    );
    columnChildren.add(checkoutButton);

    return AppScaffold(
      title: 'Checkout',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: columnChildren,
          ),
        ),
      ),
    );
  }
}
