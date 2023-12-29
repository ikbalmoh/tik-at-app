import 'package:intl/intl.dart';

class TransactionItem {
  int ticketTypeId;
  String name;
  double price;
  int qty;
  double subtotal;
  double discount;
  double total;

  TransactionItem({
    required this.ticketTypeId,
    required this.name,
    required this.price,
    required this.qty,
    this.discount = 0,
    required this.subtotal,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
        'ticket_type_id': ticketTypeId,
        'name': name,
        'price': price,
        'qty': qty,
        'discount': discount,
        'subtotal': subtotal,
        'total': total,
      };

  @override
  String toString() {
    return '{"ticket_type_id": $ticketTypeId, "name": $name, "price": $price, "qty": $qty, "discount": $discount, "subtotal": $subtotal, "total": $total}';
  }
}

class Transaction {
  bool isGroup;
  double grandTotal;
  double pay;
  double charge;
  String paymentMethod;
  String? paymentRef;
  List<TransactionItem> tickets;
  DateTime purchaseDate;

  Transaction({
    required this.isGroup,
    required this.grandTotal,
    required this.pay,
    required this.charge,
    required this.paymentMethod,
    this.paymentRef,
    required this.tickets,
    required this.purchaseDate,
  });

  @override
  String toString() {
    return '{"purchase_date": $purchaseDate, "is_group": $isGroup, "pay": $pay, "charge": $charge, "payment_method": $paymentMethod, "payment_ref": $paymentRef, "grand_total": $grandTotal, "tickets": $tickets}';
  }

  Map<String, dynamic> toJson() => {
        'purchase_date': DateFormat('yyyy-MM-dd hh:mm:ss').format(purchaseDate),
        'is_group': isGroup,
        'pay': pay,
        'charge': charge,
        'payment_method': paymentMethod,
        'payment_ref': paymentRef,
        'grand_total': grandTotal,
        'tickets': tickets.map((ticket) => ticket.toJson()).toList()
      };
}
