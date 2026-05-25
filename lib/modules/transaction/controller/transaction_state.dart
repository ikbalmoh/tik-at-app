import 'package:equatable/equatable.dart';
import 'package:gartix/modules/ticket/model/ticket.dart';
import 'package:gartix/modules/transaction/model/transaction.dart';
import 'package:gartix/modules/transaction/model/transaction_payload.dart';

class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInProgress extends TransactionState {
  final List<TransactionPayloadItem> tickets;
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
    List<TransactionPayloadItem>? tickets,
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
  final Transaction transaction;
  final List<Ticket> tickets;
  final bool printing;
  final bool printTicket;
  final int printCount;

  const TransactionDone({
    required this.transaction,
    required this.tickets,
    required this.printTicket,
    required this.printing,
    required this.printCount,
  });

  TransactionDone copyWith({
    Transaction? transaction,
    List<Ticket>? tickets,
    bool? printing,
    bool? printTicket,
    int? printCount,
  }) {
    return TransactionDone(
        transaction: transaction ?? this.transaction,
        tickets: tickets ?? this.tickets,
        printing: printing ?? this.printing,
        printTicket: printTicket ?? this.printTicket,
        printCount: printCount ?? this.printCount);
  }

  @override
  List<Object> get props => [tickets, printCount, printing];

  @override
  String toString() {
    return 'TransactionDone({"printing": $printing, "printCount": $printCount, "total_ticket": ${tickets.length}})';
  }
}
