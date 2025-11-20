import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Cart', () {
    late Cart cart;
    late Sandwich footlongWhite;
    late Sandwich sixInchWheat;
    late Sandwich footlongWholemeal;

    setUp(() {
      cart = Cart();
      footlongWhite = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.white,
        isFootlong: true,
      );
      sixInchWheat = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.wheat,
        isFootlong: false,
      );
      footlongWholemeal = Sandwich(
        type: SandwichType.veggieDelight,
        breadType: BreadType.wholemeal,
        isFootlong: true,
      );
    });

    test('starts empty', () {
      expect(cart.isEmpty, true);
      expect(cart.totalItems, 0);
      expect(cart.totalPrice, 0);
    });

    test('increment adds sandwich to cart', () {
      cart.increment(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 1);
      expect(cart.isEmpty, false);
      expect(cart.totalItems, 1);
    });

    test('increment increases quantity for same sandwich', () {
      cart.increment(footlongWhite);
      cart.increment(footlongWhite);
      cart.increment(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 3);
      expect(cart.totalItems, 3);
    });

    test('decrement reduces quantity', () {
      cart.increment(footlongWhite);
      cart.increment(footlongWhite);
      cart.decrement(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 1);
    });

    test('decrement removes sandwich when quantity reaches 0', () {
      cart.increment(footlongWhite);
      cart.decrement(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 0);
      expect(cart.isEmpty, true);
    });

    test('decrement does not go below 0', () {
      cart.decrement(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 0);
      cart.increment(footlongWhite);
      cart.decrement(footlongWhite);
      cart.decrement(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 0);
    });

    test('handles multiple different sandwiches', () {
      cart.increment(footlongWhite);
      cart.increment(sixInchWheat);
      cart.increment(footlongWholemeal);
      expect(cart.getQuantity(footlongWhite), 1);
      expect(cart.getQuantity(sixInchWheat), 1);
      expect(cart.getQuantity(footlongWholemeal), 1);
      expect(cart.totalItems, 3);
    });

    test('setQuantity sets specific quantity', () {
      cart.setQuantity(footlongWhite, 5);
      expect(cart.getQuantity(footlongWhite), 5);
      expect(cart.totalItems, 5);
    });

    test('setQuantity with 0 removes sandwich', () {
      cart.increment(footlongWhite);
      cart.setQuantity(footlongWhite, 0);
      expect(cart.getQuantity(footlongWhite), 0);
      expect(cart.isEmpty, true);
    });

    test('setQuantity ignores negative values', () {
      cart.increment(footlongWhite);
      cart.setQuantity(footlongWhite, -5);
      expect(cart.getQuantity(footlongWhite), 1);
    });

    test('remove deletes sandwich from cart', () {
      cart.increment(footlongWhite);
      cart.increment(footlongWhite);
      cart.remove(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 0);
      expect(cart.isEmpty, true);
    });

    test('clear empties entire cart', () {
      cart.increment(footlongWhite);
      cart.increment(sixInchWheat);
      cart.increment(footlongWholemeal);
      cart.clear();
      expect(cart.isEmpty, true);
      expect(cart.totalItems, 0);
      expect(cart.getQuantity(footlongWhite), 0);
      expect(cart.getQuantity(sixInchWheat), 0);
    });

    test('totalPrice calculates correctly for single footlong', () {
      cart.increment(footlongWhite);
      expect(cart.totalPrice, 11);
    });

    test('totalPrice calculates correctly for multiple footlongs', () {
      cart.setQuantity(footlongWhite, 3);
      expect(cart.totalPrice, 33);
    });

    test('totalPrice calculates correctly for single six-inch', () {
      cart.increment(sixInchWheat);
      expect(cart.totalPrice, 7);
    });

    test('totalPrice calculates correctly for multiple six-inch', () {
      cart.setQuantity(sixInchWheat, 4);
      expect(cart.totalPrice, 28);
    });

    test('totalPrice calculates correctly for mixed sandwiches', () {
      cart.setQuantity(footlongWhite, 2); // 2 * 11 = 22
      cart.setQuantity(sixInchWheat, 3); // 3 * 7 = 21
      expect(cart.totalPrice, 43);
    });

    test('totalPrice handles large quantities', () {
      cart.setQuantity(footlongWhite, 100);
      cart.setQuantity(sixInchWheat, 50);
      expect(cart.totalPrice, 1450); // 100*11 + 50*7
    });

    test('items returns unmodifiable map', () {
      cart.increment(footlongWhite);
      final items = cart.items;
      expect(items[footlongWhite], 1);
      expect(() => items[footlongWhite] = 5, throwsUnsupportedError);
    });

    test('totalItems counts across all sandwiches', () {
      cart.setQuantity(footlongWhite, 2);
      cart.setQuantity(sixInchWheat, 3);
      cart.setQuantity(footlongWholemeal, 1);
      expect(cart.totalItems, 6);
    });

    test('add method with quantity parameter adds multiple sandwiches', () {
      cart.add(footlongWhite, quantity: 5);
      expect(cart.getQuantity(footlongWhite), 5);
      expect(cart.totalItems, 5);
    });

    test('add method with default quantity adds one sandwich', () {
      cart.add(footlongWhite);
      expect(cart.getQuantity(footlongWhite), 1);
    });

    test('add method ignores zero or negative quantities', () {
      cart.add(footlongWhite, quantity: 0);
      expect(cart.isEmpty, true);
      cart.add(footlongWhite, quantity: -3);
      expect(cart.isEmpty, true);
    });

    test('add method accumulates quantities for same sandwich', () {
      cart.add(footlongWhite, quantity: 3);
      cart.add(footlongWhite, quantity: 2);
      expect(cart.getQuantity(footlongWhite), 5);
    });
  });
}
