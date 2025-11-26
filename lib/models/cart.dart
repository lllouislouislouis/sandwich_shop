import 'sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final Map<Sandwich, int> _items = {};

  // Returns a read-only copy of the items and their quantities
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  void add(Sandwich sandwich, {int quantity = 1}) {
    // Validate that quantity is positive
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }

    if (_items.containsKey(sandwich)) {
      _items[sandwich] = _items[sandwich]! + quantity;
    } else {
      _items[sandwich] = quantity;
    }
    notifyListeners(); // Notify UI of cart changes for real-time updates
  }

  void remove(Sandwich sandwich, {int quantity = 1}) {
    // Validate that quantity is positive
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }

    if (_items.containsKey(sandwich)) {
      final currentQty = _items[sandwich]!;
      if (currentQty > quantity) {
        _items[sandwich] = currentQty - quantity;
      } else {
        // Auto-remove when quantity reaches zero
        _items.remove(sandwich);
      }
      notifyListeners(); // Notify UI of cart changes for real-time updates
    }
  }

  // Quick remove: completely removes an item from the cart regardless of quantity
  void removeItem(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      _items.remove(sandwich);
      notifyListeners(); // Notify UI of cart changes
    }
  }

  void clear() {
    _items.clear();
    notifyListeners(); // Notify UI when cart is cleared
  }

  double get totalPrice {
    final pricingRepository = PricingRepository();
    double total = 0.0;

    for (Sandwich sandwich in _items.keys) {
      int quantity = _items[sandwich]!;
      total += pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }

    return total;
  }

  bool get isEmpty => _items.isEmpty;

  int get length => _items.length;

  int get countOfItems {
    int total = 0;
    for (Sandwich sandwich in _items.keys) {
      total += _items[sandwich]!;
    }
    return total;
  }

  int getQuantity(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      return _items[sandwich]!;
    }
    return 0;
  }

  // Calculate the subtotal for a specific item in the cart
  double getItemSubtotal(Sandwich sandwich) {
    if (_items.containsKey(sandwich)) {
      final pricingRepository = PricingRepository();
      final quantity = _items[sandwich]!;
      return pricingRepository.calculatePrice(
        quantity: quantity,
        isFootlong: sandwich.isFootlong,
      );
    }
    return 0.0;
  }
}
