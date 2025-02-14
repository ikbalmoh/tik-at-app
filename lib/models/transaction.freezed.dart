// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Transaction _$TransactionFromJson(Map<String, dynamic> json) {
  return _Transaction.fromJson(json);
}

/// @nodoc
mixin _$Transaction {
  String get id => throw _privateConstructorUsedError;
  double get grandTotal => throw _privateConstructorUsedError;
  double get pay => throw _privateConstructorUsedError;
  double get charge => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get operatorName => throw _privateConstructorUsedError;
  DateTime get purchaseDate => throw _privateConstructorUsedError;
  List<TransactionDetail> get details => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionCopyWith<Transaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) then) =
      _$TransactionCopyWithImpl<$Res, Transaction>;
  @useResult
  $Res call(
      {String id,
      double grandTotal,
      double pay,
      double charge,
      String paymentMethod,
      String operatorName,
      DateTime purchaseDate,
      List<TransactionDetail> details});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res, $Val extends Transaction>
    implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? grandTotal = null,
    Object? pay = null,
    Object? charge = null,
    Object? paymentMethod = null,
    Object? operatorName = null,
    Object? purchaseDate = null,
    Object? details = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      pay: null == pay
          ? _value.pay
          : pay // ignore: cast_nullable_to_non_nullable
              as double,
      charge: null == charge
          ? _value.charge
          : charge // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      operatorName: null == operatorName
          ? _value.operatorName
          : operatorName // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      details: null == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as List<TransactionDetail>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionImplCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$$TransactionImplCopyWith(
          _$TransactionImpl value, $Res Function(_$TransactionImpl) then) =
      __$$TransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      double grandTotal,
      double pay,
      double charge,
      String paymentMethod,
      String operatorName,
      DateTime purchaseDate,
      List<TransactionDetail> details});
}

/// @nodoc
class __$$TransactionImplCopyWithImpl<$Res>
    extends _$TransactionCopyWithImpl<$Res, _$TransactionImpl>
    implements _$$TransactionImplCopyWith<$Res> {
  __$$TransactionImplCopyWithImpl(
      _$TransactionImpl _value, $Res Function(_$TransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? grandTotal = null,
    Object? pay = null,
    Object? charge = null,
    Object? paymentMethod = null,
    Object? operatorName = null,
    Object? purchaseDate = null,
    Object? details = null,
  }) {
    return _then(_$TransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      grandTotal: null == grandTotal
          ? _value.grandTotal
          : grandTotal // ignore: cast_nullable_to_non_nullable
              as double,
      pay: null == pay
          ? _value.pay
          : pay // ignore: cast_nullable_to_non_nullable
              as double,
      charge: null == charge
          ? _value.charge
          : charge // ignore: cast_nullable_to_non_nullable
              as double,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      operatorName: null == operatorName
          ? _value.operatorName
          : operatorName // ignore: cast_nullable_to_non_nullable
              as String,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      details: null == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as List<TransactionDetail>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TransactionImpl extends _Transaction {
  const _$TransactionImpl(
      {required this.id,
      required this.grandTotal,
      required this.pay,
      required this.charge,
      required this.paymentMethod,
      required this.operatorName,
      required this.purchaseDate,
      required final List<TransactionDetail> details})
      : _details = details,
        super._();

  factory _$TransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionImplFromJson(json);

  @override
  final String id;
  @override
  final double grandTotal;
  @override
  final double pay;
  @override
  final double charge;
  @override
  final String paymentMethod;
  @override
  final String operatorName;
  @override
  final DateTime purchaseDate;
  final List<TransactionDetail> _details;
  @override
  List<TransactionDetail> get details {
    if (_details is EqualUnmodifiableListView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_details);
  }

  @override
  String toString() {
    return 'Transaction(id: $id, grandTotal: $grandTotal, pay: $pay, charge: $charge, paymentMethod: $paymentMethod, operatorName: $operatorName, purchaseDate: $purchaseDate, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.grandTotal, grandTotal) ||
                other.grandTotal == grandTotal) &&
            (identical(other.pay, pay) || other.pay == pay) &&
            (identical(other.charge, charge) || other.charge == charge) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.operatorName, operatorName) ||
                other.operatorName == operatorName) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      grandTotal,
      pay,
      charge,
      paymentMethod,
      operatorName,
      purchaseDate,
      const DeepCollectionEquality().hash(_details));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      __$$TransactionImplCopyWithImpl<_$TransactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionImplToJson(
      this,
    );
  }
}

abstract class _Transaction extends Transaction {
  const factory _Transaction(
      {required final String id,
      required final double grandTotal,
      required final double pay,
      required final double charge,
      required final String paymentMethod,
      required final String operatorName,
      required final DateTime purchaseDate,
      required final List<TransactionDetail> details}) = _$TransactionImpl;
  const _Transaction._() : super._();

  factory _Transaction.fromJson(Map<String, dynamic> json) =
      _$TransactionImpl.fromJson;

  @override
  String get id;
  @override
  double get grandTotal;
  @override
  double get pay;
  @override
  double get charge;
  @override
  String get paymentMethod;
  @override
  String get operatorName;
  @override
  DateTime get purchaseDate;
  @override
  List<TransactionDetail> get details;
  @override
  @JsonKey(ignore: true)
  _$$TransactionImplCopyWith<_$TransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TransactionDetail _$TransactionDetailFromJson(Map<String, dynamic> json) {
  return _TransactionDetail.fromJson(json);
}

/// @nodoc
mixin _$TransactionDetail {
  int get id => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get qty => throw _privateConstructorUsedError;
  double get subtotal => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;
  String get ticketTypeName => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransactionDetailCopyWith<TransactionDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionDetailCopyWith<$Res> {
  factory $TransactionDetailCopyWith(
          TransactionDetail value, $Res Function(TransactionDetail) then) =
      _$TransactionDetailCopyWithImpl<$Res, TransactionDetail>;
  @useResult
  $Res call(
      {int id,
      double price,
      int qty,
      double subtotal,
      double discount,
      double total,
      String ticketTypeName});
}

/// @nodoc
class _$TransactionDetailCopyWithImpl<$Res, $Val extends TransactionDetail>
    implements $TransactionDetailCopyWith<$Res> {
  _$TransactionDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? qty = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? total = null,
    Object? ticketTypeName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      ticketTypeName: null == ticketTypeName
          ? _value.ticketTypeName
          : ticketTypeName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionDetailImplCopyWith<$Res>
    implements $TransactionDetailCopyWith<$Res> {
  factory _$$TransactionDetailImplCopyWith(_$TransactionDetailImpl value,
          $Res Function(_$TransactionDetailImpl) then) =
      __$$TransactionDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      double price,
      int qty,
      double subtotal,
      double discount,
      double total,
      String ticketTypeName});
}

/// @nodoc
class __$$TransactionDetailImplCopyWithImpl<$Res>
    extends _$TransactionDetailCopyWithImpl<$Res, _$TransactionDetailImpl>
    implements _$$TransactionDetailImplCopyWith<$Res> {
  __$$TransactionDetailImplCopyWithImpl(_$TransactionDetailImpl _value,
      $Res Function(_$TransactionDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? qty = null,
    Object? subtotal = null,
    Object? discount = null,
    Object? total = null,
    Object? ticketTypeName = null,
  }) {
    return _then(_$TransactionDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as int,
      subtotal: null == subtotal
          ? _value.subtotal
          : subtotal // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
      ticketTypeName: null == ticketTypeName
          ? _value.ticketTypeName
          : ticketTypeName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TransactionDetailImpl extends _TransactionDetail {
  const _$TransactionDetailImpl(
      {required this.id,
      required this.price,
      required this.qty,
      required this.subtotal,
      required this.discount,
      required this.total,
      required this.ticketTypeName})
      : super._();

  factory _$TransactionDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionDetailImplFromJson(json);

  @override
  final int id;
  @override
  final double price;
  @override
  final int qty;
  @override
  final double subtotal;
  @override
  final double discount;
  @override
  final double total;
  @override
  final String ticketTypeName;

  @override
  String toString() {
    return 'TransactionDetail(id: $id, price: $price, qty: $qty, subtotal: $subtotal, discount: $discount, total: $total, ticketTypeName: $ticketTypeName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.ticketTypeName, ticketTypeName) ||
                other.ticketTypeName == ticketTypeName));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, price, qty, subtotal, discount, total, ticketTypeName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionDetailImplCopyWith<_$TransactionDetailImpl> get copyWith =>
      __$$TransactionDetailImplCopyWithImpl<_$TransactionDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionDetailImplToJson(
      this,
    );
  }
}

abstract class _TransactionDetail extends TransactionDetail {
  const factory _TransactionDetail(
      {required final int id,
      required final double price,
      required final int qty,
      required final double subtotal,
      required final double discount,
      required final double total,
      required final String ticketTypeName}) = _$TransactionDetailImpl;
  const _TransactionDetail._() : super._();

  factory _TransactionDetail.fromJson(Map<String, dynamic> json) =
      _$TransactionDetailImpl.fromJson;

  @override
  int get id;
  @override
  double get price;
  @override
  int get qty;
  @override
  double get subtotal;
  @override
  double get discount;
  @override
  double get total;
  @override
  String get ticketTypeName;
  @override
  @JsonKey(ignore: true)
  _$$TransactionDetailImplCopyWith<_$TransactionDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
