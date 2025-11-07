import 'package:flutter/material.dart';

// Enum representing bread options.
enum BreadType { white, brown, multigrain }

// Convert an enum value to a readable label.
String breadTypeToLabel(BreadType type) {
  switch (type) {
    case BreadType.white:
      return 'White';
    case BreadType.brown:
      return 'Brown';
    case BreadType.multigrain:
      return 'Multi-grain';
  }
}

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

  // Currently selected sandwich size (single-selection via Set).
  final Set<String> _selectedSize = <String>{'Footlong'};

  // Selected bread type.
  BreadType _selectedBread = BreadType.white;

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
            // Segmented control to switch sandwich size.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SegmentedButton<String>(
                segments: const <ButtonSegment<String>>[
                  ButtonSegment<String>(
                      value: 'Footlong', label: Text('Footlong')),
                  ButtonSegment<String>(
                      value: 'Six-inch', label: Text('Six-inch')),
                ],
                selected: _selectedSize,
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    // Keep only the single selection.
                    _selectedSize
                      ..clear()
                      ..addAll(newSelection);
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            // Dropdown to pick bread type.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: DropdownButtonFormField<BreadType>(
                initialValue: _selectedBread,
                decoration: const InputDecoration(
                  labelText: 'Bread type',
                  border: OutlineInputBorder(),
                ),
                items: BreadType.values.map((BreadType bt) {
                  return DropdownMenuItem<BreadType>(
                    value: bt,
                    child: Text(breadTypeToLabel(bt)),
                  );
                }).toList(),
                onChanged: (BreadType? newType) {
                  if (newType == null) return;
                  setState(() {
                    _selectedBread = newType;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            // Show the item display including the current note.
            OrderItemDisplay(
              _quantity,
              // Use the currently selected size.
              _selectedSize.isNotEmpty ? _selectedSize.first : 'Footlong',
              note: _noteController.text,
              breadType: _selectedBread,
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
                  onPressed:
                      _quantity < widget.maxQuantity ? _increaseQuantity : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledBackgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white70,
                  ),
                  child: const Text('Add'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _quantity > 0 ? _decreaseQuantity : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    disabledBackgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.white70,
                  ),
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
  final BreadType? breadType;

  const OrderItemDisplay(this.quantity, this.itemType,
      {this.note, this.breadType, super.key});

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
        if (breadType != null) ...[
          const SizedBox(height: 6),
          Text(
            'Bread: ${breadTypeToLabel(breadType!)}',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
        ],
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
