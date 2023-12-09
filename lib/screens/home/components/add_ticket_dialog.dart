import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/models/ticket.dart';
import 'package:tik_at_app/models/transaction.dart';
import 'package:tik_at_app/modules/transaction/transaction_controller.dart';

class AddTicketDialog extends StatefulWidget {
  const AddTicketDialog({super.key, required this.ticket});

  final Ticket ticket;

  @override
  State<AddTicketDialog> createState() => _AddTicketDialogState();
}

class _AddTicketDialogState extends State<AddTicketDialog> {
  TransactionController controller = Get.find();

  TextEditingController qty = TextEditingController();
  FocusNode qtyFocusNode = FocusNode();

  TransactionItem? item;

  @override
  void initState() {
    item = controller.tickets.firstWhereOrNull((t) => t.id == widget.ticket.id);
    qty.text = (item == null ? '1' : item?.qty.toString())!;
    qtyFocusNode.requestFocus();

    super.initState();
  }

  void submit() {
    controller.selectTicket(widget.ticket, int.parse(qty.text));
    Get.back();
  }

  Row rowField(String label, dynamic content, TextTheme textTheme) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(color: Colors.black87),
          ),
          content is String
              ? Text(
                  content,
                  style: textTheme.bodyLarge
                      ?.copyWith(color: Colors.grey.shade700),
                )
              : content,
        ],
      );

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Dialog(
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.black12,
                  ),
                ),
              ),
              margin: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item == null ? 'Tambah Tiket' : 'Edit Tiket',
                    style: textTheme.headlineSmall,
                  ),
                  Badge(
                    label: Text(
                      widget.ticket.name,
                      style: textTheme.bodyLarge,
                    ),
                    backgroundColor: widget.ticket.color,
                    largeSize: 28,
                    smallSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 7.5,
            ),
            rowField(
              'Harga Tiket',
              widget.ticket.price.toString(),
              textTheme,
            ),
            const SizedBox(
              height: 10,
            ),
            rowField(
              'Jumlah Tiket',
              Flexible(
                fit: FlexFit.tight,
                child: TextFormField(
                  textAlign: TextAlign.right,
                  controller: qty,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Jumlah Tiket',
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  focusNode: qtyFocusNode,
                ),
              ),
              textTheme,
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    child: const Text('Batal'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () => submit(),
                    child: Text(item == null ? 'Simpan' : 'Perbaharui'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
