import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

void main() {
  group('PricingRepository', () {
    test('footlong (1) costs 11', () {
      const pricing = PricingRepository(quantity: 1, sandwichType: 'footlong');
      expect(pricing.totalPrice, 11);
    });

    test('footlong (3) costs 33', () {
      const pricing = PricingRepository(quantity: 3, sandwichType: 'footlong');
      expect(pricing.totalPrice, 33);
    });

    test('six-inch (1) costs 7', () {
      const pricing = PricingRepository(quantity: 1, sandwichType: 'six-inch');
      expect(pricing.totalPrice, 7);
    });

    test('six-inch (4) costs 28', () {
      const pricing = PricingRepository(quantity: 4, sandwichType: 'six-inch');
      expect(pricing.totalPrice, 28);
    });

    test('zero quantity is free for both types', () {
      const footlong = PricingRepository(quantity: 0, sandwichType: 'footlong');
      const sixInch = PricingRepository(quantity: 0, sandwichType: 'six-inch');
      expect(footlong.totalPrice, 0);
      expect(sixInch.totalPrice, 0);
    });

    test('negative quantity clamps to 0', () {
      const footlong =
          PricingRepository(quantity: -5, sandwichType: 'footlong');
      const sixInch = PricingRepository(quantity: -2, sandwichType: 'six-inch');
      expect(footlong.totalPrice, 0);
      expect(sixInch.totalPrice, 0);
    });

    test('non-footlong type falls back to six-inch pricing', () {
      const pricing = PricingRepository(quantity: 2, sandwichType: 'unknown');
      // Fallback uses six-inch unit price (7).
      expect(pricing.totalPrice, 14);
    });

    test('large quantities compute correctly', () {
      const footlong =
          PricingRepository(quantity: 1000, sandwichType: 'footlong');
      const sixInch =
          PricingRepository(quantity: 1000, sandwichType: 'six-inch');
      expect(footlong.totalPrice, 11000);
      expect(sixInch.totalPrice, 7000);
    });
  });
}
