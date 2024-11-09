class Product {
  final String name;
  final String offeringType;
  final String typeName;
  final String offeredByName;
  final double price;
  final bool isAvailable;

  Product({
    required this.name,
    required this.offeringType,
    required this.typeName,
    required this.offeredByName,
    required this.price,
    required this.isAvailable,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['product_name'],
      offeringType: json['offering_type'],
      typeName: json['type_name'],
      offeredByName: json['offered_by_name'],
      price: (json['price'] as num).toDouble(),
      isAvailable: json['is_available'],
    );
  }
}
