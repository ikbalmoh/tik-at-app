import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/models/ticket.dart';
import 'package:tik_at_app/models/transaction.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';

class TransactionController extends GetxController {
  final TransactionService _service;

  TransactionController(this._service);

  final tickets = <TransactionItem>[].obs;
  final subtotal = (0.0).obs;
  final discount = (0.0).obs;
  final grandTotal = (0.0).obs;

  final _loading = false.obs;
  bool get loading => _loading.value;

  void selectTicket(Ticket ticket, int qty) {
    if (qty < 1) {
      return removeTicket(ticket.id, false);
    }
    int idx = tickets.indexWhere((t) => t.ticketTypeId == ticket.id);
    double discount = 0;
    if (idx > -1) {
      TransactionItem item = tickets[idx];
      item.qty = qty;
      item.subtotal = qty * item.price;
      item.discount = discount;
      item.total = item.subtotal - discount;
      tickets[idx] = item;
    } else {
      tickets.add(
        TransactionItem(
          ticketTypeId: ticket.id,
          name: ticket.name,
          price: ticket.price,
          qty: qty,
          discount: discount,
          subtotal: ticket.price * qty,
          total: (ticket.price * qty) - discount,
        ),
      );
    }
    calculateTransaction();
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
      tickets.removeWhere((t) => t.ticketTypeId == id);
      calculateTransaction();
    }
  }

  void calculateTransaction() {
    double subTotal = 0;
    for (var ticket in tickets) {
      subTotal += ticket.subtotal;
    }
    subtotal.value = subTotal;
    grandTotal.value = subTotal;
  }

  void resetTransaction({bool snackbar = true}) {
    tickets.clear();
    calculateTransaction();
    Get.snackbar('Transaksi Direset', 'Silahkan memulai transaksi baru');
  }

  void submitTransaction(String paymentMethod, double pay, String refNo) async {
    _loading.value = true;
    try {
      double charge = 0;
      if (paymentMethod == 'cash' && pay > grandTotal.value) {
        charge = pay - grandTotal.value;
      }
      final Transaction transaction = Transaction(
        isGroup: false,
        grandTotal: grandTotal.value,
        pay: pay,
        charge: charge,
        paymentMethod: paymentMethod,
        tickets: tickets,
      );
      final data = await _service.postTransaction(transaction.toJson());
      _loading.value = false;
      Get.back(closeOverlays: true);
      Get.snackbar(
        data["message"],
        'Mencetak ${data["tickets"].length} tiket...',
        duration: const Duration(seconds: 5),
      );
      resetTransaction(snackbar: false);
    } on DioException catch (e) {
      _loading.value = false;
      String? message = e.message;
      if (e.response != null) {
        message = e.response?.data['message'];
      }
      Get.snackbar(
        'Transaksi Tiket Gagal',
        message ?? 'Terjadi kesalahan',
        backgroundColor: Colors.red.shade50,
      );
    } catch (e) {
      _loading.value = false;
      if (kDebugMode) {
        print('Transaction Error: $e');
      }
    }
  }
}
