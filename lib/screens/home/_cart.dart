import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';
import 'package:tik_at_app/screens/home/components/cart_item.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  TransactionController controller = Get.find();

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
      () => controller.tickets.isNotEmpty
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
                              item.value.id,
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
                  ))),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      summary(
                        'Subtotal',
                        controller.subtotal.toString(),
                        textTheme,
                      ),
                      summary(
                        'Total Diskon',
                        controller.discount.toString(),
                        textTheme,
                      ),
                      summary(
                        'Total',
                        controller.total.toString(),
                        textTheme,
                      ),
                      const SizedBox(
                        height: 10,
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.green,
                                backgroundColor: Colors.green.shade50,
                                padding: const EdgeInsets.all(15),
                              ),
                              onPressed: () {},
                              child: const Text('PEMBAYARAN'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
    );
  }
}
