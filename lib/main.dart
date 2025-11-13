import 'package:flutter/material.dart';
import 'package:sandwich_shop/viewa/app_styles.dart';
import 'package:sandwich_shop/repositories/order_repository.dart';

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

class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;

  const StyledButton(
      {required this.text,
      required this.onPressed,
      this.backgroundColor = Colors.green,
      this.foregroundColor = Colors.white,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? backgroundColor : Colors.grey,
          disabledBackgroundColor: Colors.grey,
          foregroundColor: foregroundColor,
          disabledForegroundColor: Colors.white70,
          textStyle: normalText),
      child: Text(text),
    );
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
  late final OrderRepository _orderRepository;
  final TextEditingController _notesController = TextEditingController();
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;

  @override
  void initState() {
    super.initState();
    _orderRepository = OrderRepository(maxQuantity: widget.maxQuantity);
    _notesController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  VoidCallback? _getIncreaseCallback() {
    if (_orderRepository.canIncrement) {
      return () => setState(_orderRepository.increment);
    }
    return null;
  }

  VoidCallback? _getDecreaseCallback() {
    if (_orderRepository.canDecrement) {
      return () => setState(_orderRepository.decrement);
    }
    return null;
  }

  void _onSandwichTypeChanged(bool value) {
    setState(() => _isFootlong = value);
  }

  void _onBreadTypeSelected(BreadType? value) {
    if (value != null) {
      setState(() => _selectedBreadType = value);
    }
  }

  List<DropdownMenuEntry<BreadType>> _buildDropdownEntries() {
    List<DropdownMenuEntry<BreadType>> entries = [];
    for (BreadType bread in BreadType.values) {
      DropdownMenuEntry<BreadType> newEntry = DropdownMenuEntry<BreadType>(
        value: bread,
        label: bread.name,
      );
      entries.add(newEntry);
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    String sandwichType = 'footlong';
    if (!_isFootlong) {
      sandwichType = 'six-inch';
    }

    String noteForDisplay;
    if (_notesController.text.isEmpty) {
      noteForDisplay = 'No notes added.';
    } else {
      noteForDisplay = _notesController.text;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sandwich Counter',
          style: heading1,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OrderItemDisplay(
              quantity: _orderRepository.quantity,
              itemType: sandwichType,
              breadType: _selectedBreadType,
              orderNote: noteForDisplay,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('six-inch', style: normalText),
                Switch(
                  value: _isFootlong,
                  onChanged: _onSandwichTypeChanged,
                ),
                const Text('footlong', style: normalText),
              ],
            ),
            const SizedBox(height: 10),
            DropdownMenu<BreadType>(
              textStyle: normalText,
              initialSelection: _selectedBreadType,
              onSelected: _onBreadTypeSelected,
              dropdownMenuEntries: _buildDropdownEntries(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: TextField(
                key: const Key('notes_textfield'),
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Add a note (e.g., no onions)',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StyledButton(
                  onPressed: _getIncreaseCallback(),
                  icon: Icons.add,
                  label: 'Add',
                  backgroundColor: Colors.green,
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: _getDecreaseCallback(),
                  icon: Icons.remove,
                  label: 'Remove',
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
  int _quantity = 0;

  // Currently selected sandwich size (single value now).
  String _selectedSize = 'Footlong';

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
      appBar: AppBar(title: const Text('Sandwich Counter', style: heading1)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Slider to choose sandwich size (Six-inch <-> Footlong).
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Size: $_selectedSize', style: normalText),
                  Slider(
                    value: _selectedSize == 'Footlong' ? 1.0 : 0.0,
                    min: 0.0,
                    max: 1.0,
                    divisions: 1,
                    label: _selectedSize,
                    onChanged: (double newValue) {
                      setState(() {
                        _selectedSize =
                            newValue >= 0.5 ? 'Footlong' : 'Six-inch';
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Dropdown to pick bread type.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: DropdownButtonFormField<BreadType>(
                style: normalText,
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
              _selectedSize,
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
                StyledButton(
                    text: "Add",
                    onPressed: _quantity < widget.maxQuantity
                        ? _increaseQuantity
                        : null),
                const SizedBox(width: 12),
                StyledButton(
                    text: "Remove",
                    onPressed: _quantity > 0 ? _decreaseQuantity : null,
                    backgroundColor: Colors.red),
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
        Text('$quantity $itemType sandwich(es): $sandwichIcons',
            style: normalText),
        if (breadType != null) ...[
          const SizedBox(height: 6),
          Text('Bread: ${breadTypeToLabel(breadType!)}', style: normalText),
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
