class PricingRepository {
  final int _footlongPrice = 11;
  final int _sixInchPrice = 7;

  final int quantity;
  final String sandwichType;

  const PricingRepository({
    required this.quantity, 
    required this.sandwichType
    });

  int get _unitPrice =>
      sandwichType == 'footlong' ? _footlongPrice : _sixInchPrice;

  int get totalPrice => (_unitPrice * (quantity < 0 ? 0 : quantity));
}