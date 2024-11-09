class Service {
  final String name;
  final String typeName;
  final String offeredByName;
  final double price;
  final bool isAvailable;

  Service({
    required this.name,
    required this.typeName,
    required this.offeredByName,
    required this.price,
    required this.isAvailable,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      name: json['service_name'],
      typeName: json['type_name'],
      offeredByName: json['offered_by_name'],
      price: (json['price'] as num).toDouble(),
      isAvailable: json['is_available'],
    );
  }
}
