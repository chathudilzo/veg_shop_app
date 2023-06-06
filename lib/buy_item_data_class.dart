class BuyItemData {
  final String name;
  final double grams;
  final double pricePerKg;
  final double price;

  BuyItemData(
      {required this.name,
      required this.pricePerKg,
      required this.grams,
      required this.price});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'pricePerKg': pricePerKg,
      'grams': grams,
      'price': price,
    };
  }
}
