class TransactionItem {
  int id;
  String name;
  double price;
  int qty;
  double subtotal;
  double discount;
  double total;

  TransactionItem({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.discount,
    required this.subtotal,
    required this.total,
  });
}

class Transaction {
  bool isGroup;
  double grandTotal;
  double pay;
  double charge;
  String paymentMethod;
  String? paymentRef;
  List<TransactionItem> tickets;

  Transaction({
    required this.isGroup,
    required this.grandTotal,
    required this.pay,
    required this.charge,
    required this.paymentMethod,
    this.paymentRef,
    required this.tickets,
  });
}
