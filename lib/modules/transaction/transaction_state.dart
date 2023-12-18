import 'package:equatable/equatable.dart';
import 'package:tik_at_app/models/ticket.dart';
import 'package:tik_at_app/models/transaction.dart';

class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInProgress extends TransactionState {
  final List<TransactionItem> tickets;
  final double subtotal;
  final double discount;
  final double grandTotal;

  const TransactionInProgress({
    this.tickets = const [],
    this.subtotal = 0,
    this.discount = 0,
    this.grandTotal = 0,
  });

  TransactionInProgress copyWith({
    List<TransactionItem>? tickets,
    // double? subtotal,
    double? discount,
    // double? grandTotal,
  }) {
    return TransactionInProgress(
      tickets: tickets ?? this.tickets,
      subtotal: (tickets ?? this.tickets)
          .map((t) => t.subtotal)
          .reduce((value, element) => value + element),
      discount: discount ?? this.discount,
      grandTotal: (tickets ?? this.tickets)
          .map((t) => t.subtotal)
          .reduce((value, element) => value + element),
    );
  }

  @override
  List<Object> get props => [tickets, subtotal, discount, grandTotal];
}

class TransactionDone extends TransactionState {
  final List<Ticket> tickets;
  final bool printing;
  final int printCount;

  const TransactionDone(
      {required this.tickets,
      required this.printing,
      required this.printCount});

  TransactionDone copyWith(
      {List<Ticket>? tickets, bool? printing, int? printCount}) {
    return TransactionDone(
        tickets: tickets ?? this.tickets,
        printing: printing ?? this.printing,
        printCount: printCount ?? this.printCount);
  }

  @override
  List<Object> get props => [tickets, printCount, printing];

  @override
  String toString() {
    return 'TransactionDone({"printing": $printing, "printCount": $printCount, "total_ticket": ${tickets.length}})';
  }
}
