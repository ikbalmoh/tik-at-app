class Ticket {
  final int id;
  final String name;
  final String description;
  final double price;

  Ticket({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  Ticket.fromJson(Map<dynamic, dynamic> json)
      : id = int.tryParse(json['id']?.toString() ?? '') ?? 0,
        name = json['name']?.toString() ?? '',
        description = json['description']?.toString() ?? '',
        price = json['price'] ?? 0;

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'description': description, 'price': price};

  @override
  String toString() {
    return '{"id": $id, "name": $name, "description": $description, "price": $price}';
  }
}
