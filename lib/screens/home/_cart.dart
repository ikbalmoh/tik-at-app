import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';
import 'package:tik_at_app/screens/home/components/cart_item.dart';
import 'package:tik_at_app/utils/utils.dart';
import 'components/checkout_dialog.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  TransactionController controller = Get.find();

  void openPayment() {
    Get.dialog(
      const CheckoutDialog(),
      barrierDismissible: false,
    );
  }

  Widget summary(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: controller.tickets.isNotEmpty
            ? Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: controller.tickets
                          .asMap()
                          .entries
                          .map(
                            (item) => CartItem(
                              item: item.value,
                              onDelete: () => controller.removeTicket(
                                item.value.ticketTypeId,
                                true,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          width: 0.5,
                          color: Colors.black12,
                        ),
                        bottom: BorderSide(
                          width: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        summary(
                          'Subtotal',
                          CurrencyFormat.idr(controller.subtotal.toDouble(), 0),
                          textTheme,
                        ),
                        summary(
                          'Total Diskon',
                          CurrencyFormat.idr(controller.discount.toDouble(), 0),
                          textTheme,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 15,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: textTheme.bodyMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            Text(
                              CurrencyFormat.idr(
                                  controller.grandTotal.toDouble(), 0),
                              style: textTheme.headlineSmall
                                  ?.copyWith(color: Colors.black),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () => controller.resetTransaction(),
                              icon: const Icon(
                                CupertinoIcons.trash,
                                size: 15,
                              ),
                              label: const Text('RESET'),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  backgroundColor: Colors.green.shade50,
                                  padding: const EdgeInsets.all(15),
                                ),
                                onPressed: () => openPayment(),
                                child: const Text('PEMBAYARAN'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              )
            : Center(
                child: Text(
                  'Belum ada tiket yang dipilih',
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
      ),
    );
  }
}
