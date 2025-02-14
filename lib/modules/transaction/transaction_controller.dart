import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gartix/models/transaction.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:gartix/models/ticket.dart';
import 'package:gartix/models/ticket_type.dart';
import 'package:gartix/models/transaction_payload.dart';
import 'package:gartix/modules/transaction/transaction.dart';
import 'package:gartix/screens/home/components/transaction_done_dialog.dart';
import 'package:gartix/utils/formater.dart';

class TransactionController extends GetxController {
  final TransactionService _service;

  TransactionController(this._service);

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  final _state = const TransactionState().obs;

  final _loading = false.obs;
  bool get loading => _loading.value;

  TransactionState get state => _state.value;

  @override
  void onInit() {
    _loading.value = false;
    _state.value = const TransactionInProgress();
    super.onInit();
  }

  void selectTicket(TicketType ticket, int qty) {
    if (qty < 1) {
      return removeTicket(ticket.id, false);
    }
    TransactionInProgress cart = _state.value as TransactionInProgress;
    List<TransactionPayloadItem> items = cart.tickets;
    TransactionPayloadItem? item =
        items.firstWhereOrNull((t) => t.ticketTypeId == ticket.id);
    if (item != null) {
      item.qty = qty;
      item.subtotal = qty * item.price;
      item.total = item.subtotal - item.discount;
      _state.value = cart.copyWith(
          tickets: cart.tickets
              .map((t) => t.ticketTypeId == item.ticketTypeId ? item : t)
              .toList());
    } else {
      _state.value = cart.copyWith(
        tickets: [
          ...cart.tickets,
          TransactionPayloadItem(
            ticketTypeId: ticket.id,
            name: ticket.name,
            price: ticket.price,
            qty: qty,
            subtotal: ticket.price * qty,
            total: (ticket.price * qty),
          ),
        ],
      );
    }
    _loading.value = false;
  }

  void removeTicket(int id, bool alert) {
    if (alert) {
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Hapus Tiket?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(closeOverlays: true);
                removeTicket(id, false);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
      );
    } else {
      TransactionInProgress cart = _state.value as TransactionInProgress;
      List<TransactionPayloadItem> filteredTickets = [...cart.tickets];
      filteredTickets.removeWhere((t) => t.ticketTypeId == id);
      _state.value = filteredTickets.isNotEmpty
          ? cart.copyWith(tickets: filteredTickets)
          : const TransactionInProgress();
    }
  }

  double getSubtotal(List<TransactionPayloadItem> tickets) {
    double subTotal = 0;
    for (var ticket in tickets) {
      subTotal += ticket.subtotal;
    }
    return subTotal;
  }

  void resetTransaction({bool snackbar = true}) {
    Get.back(closeOverlays: true);
    if (snackbar) {
      Get.snackbar('Transaksi Direset', 'Silahkan memulai transaksi baru');
    }
    _loading.value = false;
    _state.value = const TransactionInProgress();
  }

  void submitTransaction({
    required String paymentMethod,
    required double pay,
    String? refNo,
    required bool printTicket,
  }) async {
    if (_state.value is! TransactionInProgress) {
      return;
    }
    _loading.value = true;
    try {
      TransactionInProgress cart = _state.value as TransactionInProgress;
      double charge = 0;
      if (paymentMethod == 'cash' && pay > cart.grandTotal) {
        charge = pay - cart.grandTotal;
      }
      final TransactionPayload payload = TransactionPayload(
        purchaseDate: DateTime.now(),
        isGroup: false,
        grandTotal: cart.grandTotal,
        pay: pay,
        charge: charge,
        paymentMethod: paymentMethod,
        tickets: cart.tickets,
      );

      final data = await _service.postTransaction(payload.toJson());

      Get.back(closeOverlays: true);
      Get.showSnackbar(GetSnackBar(
        title: 'Transaksi Berhasil',
        message: 'Mencetak ${data["tickets"].length} tiket...',
        duration: const Duration(seconds: 5),
      ));

      Transaction transaction = Transaction.fromJson(data['transaction']);

      List<Ticket> tickets = (data['tickets'] as List<dynamic>)
          .map((e) => Ticket.fromJson(e))
          .toList();

      _loading.value = false;
      _state.value = TransactionDone(
        printTicket: printTicket,
        transaction: transaction,
        tickets: tickets,
        printing: true,
        printCount: 0,
      );

      return printTransactionTickets();
    } on DioException catch (e) {
      _loading.value = false;
      String? message = e.response?.data['message'] ?? e.message;
      Get.snackbar(
        'Transaksi Tiket Gagal',
        message ?? 'Terjadi kesalahan',
        backgroundColor: Colors.red.shade50,
      );
    } on PlatformException {
      _loading.value = false;
      if (kDebugMode) {
        print('Transaction Error');
      }
      Get.snackbar(
        'Tidak Dapat Memproses Transaksi',
        'Periksa Koneksi Server',
        backgroundColor: Colors.red.shade50,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      _loading.value = false;
    }
  }

  Future printTransactionTickets() async {
    Get.back(closeOverlays: true);
    if (_state.value is! TransactionDone) {
      return;
    }
    _state.value = (_state.value as TransactionDone)
        .copyWith(printCount: 0, printing: true);
    TransactionDone trx = _state.value as TransactionDone;
    try {
      _state.value = trx.copyWith(printCount: 0, printing: true);
      Get.dialog(const TransactionDoneDialog(), barrierDismissible: false);
      await printReceipt(trx.transaction);
      if (trx.printTicket) {
        for (int i = 0; i < trx.tickets.length; i++) {
          _state.value = trx.copyWith(printCount: (i + 1), printing: true);
          if (kDebugMode) {
            print('PRINTING: ${i + 1} / ${trx.tickets.length}');
            print(_state.value.toString());
          }
          await printTicket(trx.tickets[i]);
        }
        _state.value =
            trx.copyWith(printing: false, printCount: trx.tickets.length);
      } else {
        _state.value = trx.copyWith(printing: false, printCount: 0);
      }
      if (kDebugMode) {
        print('PRINT COMPLETED: ${_state.value.toString()}');
      }
    } on Error {
      _state.value = trx.copyWith(
        printing: false,
        printCount: 0,
      );
    }
  }

  Future<void> printReceipt(Transaction transaction) async {
    if (kDebugMode) {
      print('PRINT TRANSACTION: ${transaction.toString()}');
    }
    bool? isConnected = await bluetooth.isConnected ?? false;
    if (!isConnected) {
      throw Future.error('printer tidak terkoneksi');
    }
    String separator = '--------------------------------';

    ByteData bytesAsset = await rootBundle.load("assets/images/garut-bw.jpg");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    await bluetooth.printImageBytes(imageBytesFromAsset);
    await bluetooth.printNewLine();
    await bluetooth.printCustom('Situ Bagendit', 3, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printLeftRight('Waktu',
        DateFormat('dd/MM/yy hh:mm').format(transaction.purchaseDate), 1);
    await bluetooth.printLeftRight('Operator', transaction.operatorName, 1);
    int totalTicket = transaction.details
        .map((d) => d.qty)
        .reduce((value, element) => value + element);
    await bluetooth.printLeftRight('Jumlah Tiket', totalTicket.toString(), 1);
    await bluetooth.printCustom(separator, 1, 1);
    for (var i = 0; i < transaction.details.length; i++) {
      final detail = transaction.details[i];
      await bluetooth.printLeftRight('${detail.qty} x ${detail.ticketTypeName}',
          CurrencyFormat.idr(detail.total, 0), 1);
    }
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printLeftRight(
        'Total', CurrencyFormat.idr(transaction.grandTotal, 0), 1);
    await bluetooth.printLeftRight(
        'Bayar', CurrencyFormat.idr(transaction.pay, 0), 1);
    await bluetooth.printLeftRight(
        'Kembali', CurrencyFormat.idr(transaction.charge, 0), 1);
    await bluetooth.printLeftRight('Pembayaran', transaction.paymentMethod, 1);
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom('Terimakasih atas Kunjungan Anda', 1, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom(
        'Dinas Parisiwisata dan\nKebudayaan Garut', 1, 1);
    await bluetooth.paperCut();

    return Future.value();
  }

  Future<void> printTicket(Ticket ticket) async {
    if (kDebugMode) {
      print('PRINT TICKET: ${ticket.toString()}');
    }
    bool? isConnected = await bluetooth.isConnected ?? false;
    if (!isConnected) {
      throw Future.error('printer tidak terkoneksi');
    }
    String separator = '--------------------------------';

    await bluetooth.printCustom('TIKET MASUK', 3, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printLeftRight(
        'Waktu', DateFormat('dd/MM/yy hh:mm').format(ticket.purchaseDate), 1);
    await bluetooth.printLeftRight(
        'Berlaku untuk', '${ticket.entranceMax} orang', 1);
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printCustom('Scan tiket di pintu masuk', 1, 1);
    await bluetooth.printQRcode(ticket.id, 250, 250, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom('Terimakasih atas Kunjungan Anda', 1, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom(
        'Dinas Parisiwisata dan\nKebudayaan Garut', 1, 1);
    await bluetooth.paperCut();

    return Future.value();
  }
}
