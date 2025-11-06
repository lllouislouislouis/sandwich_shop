import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Sandwich Shop App', home: OrderScreen(maxQuantity: 5));
  }
}

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 0;

  // Controller for the order note input.
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _increaseQuantity() {
    if (_quantity < widget.maxQuantity) {
      setState(() => _quantity++);
    }
  }

  void _decreaseQuantity() {
    if (_quantity > 0) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sandwich Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Show the item display including the current note.
            OrderItemDisplay(
              _quantity,
              'Footlong',
              note: _noteController.text,
            ),
            const SizedBox(height: 12),
            // Note input (enter before pressing Add/Remove)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., "no onions")',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // Update UI as user types so the OrderItemDisplay shows the note.
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increaseQuantity,
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: _decreaseQuantity,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItemDisplay extends StatelessWidget {
  final int quantity;
  final String itemType;
  final String? note;

  const OrderItemDisplay(this.quantity, this.itemType, {this.note, super.key});

  @override
  Widget build(BuildContext context) {
    final String sandwichIcons = '🥪' * quantity;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$quantity $itemType sandwich(es): $sandwichIcons',
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (note != null && note!.trim().isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            'Notes: ${note!}',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
          ),
        ],
      ],
    );
  }
}
