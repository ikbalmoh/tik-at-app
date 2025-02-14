// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const Transaction._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Transaction({
    required String id,
    required double grandTotal,
    required double pay,
    required double charge,
    required String paymentMethod,
    required String operatorName,
    required DateTime purchaseDate,
    required List<TransactionDetail> details,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
}

@freezed
class TransactionDetail with _$TransactionDetail {
  const TransactionDetail._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TransactionDetail({
    required int id,
    required double price,
    required int qty,
    required double subtotal,
    required double discount,
    required double total,
    required String ticketTypeName,
  }) = _TransactionDetail;

  factory TransactionDetail.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailFromJson(json);
}
