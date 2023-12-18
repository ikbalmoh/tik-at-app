class Ticket {
  final String id;
  final int entranceMax;
  final int entranceCount;
  final String operatorName;
  final String ticketTypeName;
  final double ticketPrice;
  final bool isGroup;
  final DateTime purchaseDate;

  Ticket({
    required this.id,
    required this.entranceMax,
    required this.entranceCount,
    required this.operatorName,
    required this.ticketTypeName,
    required this.ticketPrice,
    required this.isGroup,
    required this.purchaseDate,
  });

  Ticket.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        entranceMax = json['entrance_max'] as int,
        entranceCount = json['entrance_count'] as int,
        operatorName = json['operator_name'],
        ticketTypeName = json['ticket_type_name'],
        ticketPrice = double.tryParse(json['ticket_price'].toString()) ?? 0,
        isGroup = json['is_group'] as bool,
        purchaseDate = DateTime.parse(json['purchase_date']);

  @override
  String toString() {
    return '{"id": $id, "ticket_type_name": $ticketTypeName, "operator_name": $operatorName, "entrance_max": $entranceMax, "ticket_price": $ticketPrice, "purchase_date": $purchaseDate}';
  }
}
