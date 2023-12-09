import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/models/ticket.dart';
import 'package:tik_at_app/models/transaction.dart';

class TransactionController extends GetxController {
  TransactionController();

  final tickets = <TransactionItem>[].obs;
  final subtotal = (0.0).obs;
  final discount = (0.0).obs;
  final total = (0.0).obs;
  final loading = false.obs;

  void selectTicket(Ticket ticket, int qty) {
    if (qty < 1) {
      return removeTicket(ticket.id, false);
    }
    int idx = tickets.indexWhere((t) => t.id == ticket.id);
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
          id: ticket.id,
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
                Get.back();
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
      tickets.removeWhere((t) => t.id == id);
      calculateTransaction();
    }
  }

  void calculateTransaction() {
    double subTotal = 0;
    for (var ticket in tickets) {
      subTotal += ticket.subtotal;
    }
    subtotal.value = subTotal;
    total.value = subTotal;
  }

  void resetTransaction() {
    tickets.clear();
    Get.snackbar('Transaksi Direset', 'Silahkan memulai transaksi baru');
  }
}
