import 'package:flutter/material.dart';

class TicketType {
  final int id;
  final String name;
  final String description;
  final double regularPrice;
  final double holidayPrice;
  final double price;
  final Color? color;

  TicketType({
    required this.id,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.holidayPrice,
    required this.price,
    this.color,
  });

  TicketType.fromJson(Map<dynamic, dynamic> json)
      : id = int.tryParse(json['id']?.toString() ?? '') ?? 0,
        name = json['name']?.toString() ?? '',
        description = json['description']?.toString() ?? '',
        color = Color(json['color']),
        regularPrice = double.tryParse(json['regular_price'].toString()) ?? 0.0,
        holidayPrice = double.tryParse(json['holiday_price'].toString()) ?? 0.0,
        price = double.tryParse(json['price'].toString()) ?? 0.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'regular_price': regularPrice,
        'holiday_price': holidayPrice,
        'price': price
      };

  double currentPrice() {
    return DateTime.now().weekday == DateTime.saturday ||
            DateTime.now().weekday == DateTime.sunday
        ? holidayPrice
        : regularPrice;
  }

  @override
  String toString() {
    return '{"id": $id, "name": $name, "description": $description, "regular_price": $regularPrice, "holiday_price": $holidayPrice, "price": $price}';
  }
}
