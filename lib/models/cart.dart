import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class Cart {
  final Map<Sandwich, int> _items = {};

  // Get all items in the cart
  Map<Sandwich, int> get items => Map.unmodifiable(_items);

  // Get quantity of a specific sandwich
  int getQuantity(Sandwich sandwich) {
    return _items[sandwich] ?? 0;
  }

  // Add sandwiches to cart with optional quantity parameter
  void add(Sandwich sandwich, {int quantity = 1}) {
    if (quantity <= 0) return;
    _items[sandwich] = (_items[sandwich] ?? 0) + quantity;
  }

  // Add one sandwich to the cart
  void increment(Sandwich sandwich) {
    _items[sandwich] = (_items[sandwich] ?? 0) + 1;
  }

  // Remove one sandwich from the cart (minimum 0)
  void decrement(Sandwich sandwich) {
    final currentQuantity = _items[sandwich] ?? 0;
    if (currentQuantity > 0) {
      _items[sandwich] = currentQuantity - 1;
      // Remove from map if quantity reaches 0
      if (_items[sandwich] == 0) {
        _items.remove(sandwich);
      }
    }
  }

  // Set specific quantity for a sandwich
  void setQuantity(Sandwich sandwich, int quantity) {
    if (quantity < 0) return;
    if (quantity == 0) {
      _items.remove(sandwich);
    } else {
      _items[sandwich] = quantity;
    }
  }

  // Remove sandwich completely from cart
  void remove(Sandwich sandwich) {
    _items.remove(sandwich);
  }

  // Clear entire cart
  void clear() {
    _items.clear();
  }

  // Check if cart is empty
  bool get isEmpty => _items.isEmpty;

  // Get total number of sandwiches
  int get totalItems {
    return _items.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // Calculate total price using PricingRepository
  int get totalPrice {
    int total = 0;
    _items.forEach((sandwich, quantity) {
      String sandwichType = sandwich.isFootlong ? 'footlong' : 'six-inch';
      final pricing = PricingRepository(
        quantity: quantity,
        sandwichType: sandwichType,
      );
      total += pricing.totalPrice;
    });
    return total;
  }
}
