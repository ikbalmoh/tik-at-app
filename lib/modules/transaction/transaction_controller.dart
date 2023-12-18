import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tik_at_app/models/ticket.dart';
import 'package:tik_at_app/models/ticket_type.dart';
import 'package:tik_at_app/models/transaction.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';
import 'package:tik_at_app/screens/home/components/transaction_done_dialog.dart';
import 'package:tik_at_app/utils/formater.dart';

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
    _state.value = const TransactionInProgress();
    super.onInit();
  }

  void selectTicket(TicketType ticket, int qty) {
    if (qty < 1) {
      return removeTicket(ticket.id, false);
    }
    TransactionInProgress cart = _state.value as TransactionInProgress;
    List<TransactionItem> items = cart.tickets;
    TransactionItem? item =
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
          TransactionItem(
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
      List<TransactionItem> filteredTickets = [...cart.tickets];
      filteredTickets.removeWhere((t) => t.ticketTypeId == id);
      _state.value = cart.copyWith(tickets: filteredTickets);
    }
  }

  double getSubtotal(List<TransactionItem> tickets) {
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
    _state.value = const TransactionInProgress();
  }

  void submitTransaction(String paymentMethod, double pay, String refNo) async {
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
      final Transaction transaction = Transaction(
        isGroup: false,
        grandTotal: cart.grandTotal,
        pay: pay,
        charge: charge,
        paymentMethod: paymentMethod,
        tickets: cart.tickets,
      );
      final data = await _service.postTransaction(transaction.toJson());

      Get.back(closeOverlays: true);
      Get.showSnackbar(GetSnackBar(
        title: 'Transaksi Berhasil',
        message: 'Mencetak ${data["tickets"].length} tiket...',
        duration: const Duration(seconds: 5),
      ));

      List<Ticket> tickets = (data['tickets'] as List<dynamic>)
          .map((e) => Ticket.fromJson(e))
          .toList();

      _loading.value = false;
      _state.value =
          TransactionDone(tickets: tickets, printing: true, printCount: 0);

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
      Get.dialog(const TransactionDoneDialog(), barrierDismissible: false);
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

  Future<void> printTicket(Ticket ticket) async {
    if (kDebugMode) {
      print('PRINT TICKET: ${ticket.toString()}');
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
    await bluetooth.printCustom('TIKET MASUK', 3, 1);
    await bluetooth.printCustom('Situ Bagendit', 2, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printLeftRight(
        'Waktu', DateFormat('dd/MM/yy hh:mm').format(ticket.purchaseDate), 1);
    await bluetooth.printLeftRight('Operator', ticket.operatorName, 1);
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printLeftRight('Tiket', ticket.ticketTypeName, 1);
    await bluetooth.printLeftRight(
        'Harga', CurrencyFormat.idr(ticket.ticketPrice, 0), 1);
    await bluetooth.printLeftRight(
        'Berlaku untuk', '${ticket.entranceMax} orang', 1);
    await bluetooth.printCustom(separator, 1, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom(
        'Dinas Parisiwisata dan\nKebudayaan Garut', 1, 1);
    await bluetooth.printNewLine();
    await bluetooth.printQRcode(ticket.id, 250, 250, 1);
    await bluetooth.printNewLine();
    await bluetooth.printCustom('Terimakasih atas Kunjungan Anda', 1, 1);
    await bluetooth.paperCut();

    return Future.value();
  }
}
