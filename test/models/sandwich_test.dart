import 'package:flutter_test/flutter_test.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('Sandwich model', () {
    test('name getter returns expected display name for each sandwich type', () {
      final expectedNames = {
        SandwichType.veggieDelight: 'Veggie Delight',
        SandwichType.chickenTeriyaki: 'Chicken Teriyaki',
        SandwichType.tunaMelt: 'Tuna Melt',
        SandwichType.meatballMarinara: 'Meatball Marinara',
      };

      for (final entry in expectedNames.entries) {
        final s = Sandwich(type: entry.key, isFootlong: false, breadType: BreadType.white);
        expect(s.name, entry.value);
      }
    });

    test('image getter builds correct asset path for footlong and six_inch', () {
      for (final type in SandwichType.values) {
        final footlong = Sandwich(type: type, isFootlong: true, breadType: BreadType.wheat);
        final sixInch = Sandwich(type: type, isFootlong: false, breadType: BreadType.wheat);

        final typeString = type.name;
        expect(footlong.image, 'assets/images/${typeString}_footlong.png');
        expect(sixInch.image, 'assets/images/${typeString}_six_inch.png');
      }
    });

    test('breadType is stored on the model', () {
      final s = Sandwich(type: SandwichType.tunaMelt, isFootlong: false, breadType: BreadType.wholemeal);
      expect(s.breadType, BreadType.wholemeal);
    });
  });
}