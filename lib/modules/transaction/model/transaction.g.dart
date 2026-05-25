// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionImpl _$$TransactionImplFromJson(Map<String, dynamic> json) =>
    _$TransactionImpl(
      id: json['id'] as String,
      grandTotal: (json['grand_total'] as num).toDouble(),
      pay: (json['pay'] as num).toDouble(),
      charge: (json['charge'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      operatorName: json['operator_name'] as String,
      purchaseDate: DateTime.parse(json['purchase_date'] as String),
      upt: json['upt'] as String,
      details: (json['details'] as List<dynamic>)
          .map((e) => TransactionDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TransactionImplToJson(_$TransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'grand_total': instance.grandTotal,
      'pay': instance.pay,
      'charge': instance.charge,
      'payment_method': instance.paymentMethod,
      'operator_name': instance.operatorName,
      'purchase_date': instance.purchaseDate.toIso8601String(),
      'upt': instance.upt,
      'details': instance.details,
    };

_$TransactionDetailImpl _$$TransactionDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionDetailImpl(
      id: (json['id'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      qty: (json['qty'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      ticketTypeName: json['ticket_type_name'] as String,
    );

Map<String, dynamic> _$$TransactionDetailImplToJson(
        _$TransactionDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'qty': instance.qty,
      'subtotal': instance.subtotal,
      'discount': instance.discount,
      'total': instance.total,
      'ticket_type_name': instance.ticketTypeName,
    };
