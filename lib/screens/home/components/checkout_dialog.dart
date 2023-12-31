import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/components/payment_method_button.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';
import 'package:tik_at_app/utils/utils.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key});

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  TransactionController controller = Get.find();
  SettingController settingController = Get.find();

  String paymentMethod = 'cash';
  TextEditingController payController = TextEditingController(text: '0');
  TextEditingController payRefController = TextEditingController();
  double change = 0;
  bool paymentPassed = false;

  FocusNode payNode = FocusNode();
  FocusNode payRefNode = FocusNode();

  @override
  void initState() {
    if (controller.state is TransactionInProgress) {
      TransactionInProgress cart = controller.state as TransactionInProgress;
      payController.addListener(() {
        final pay = payController.text.isNotEmpty
            ? double.parse(payController.text)
            : 0;
        paymentPassed = pay >= cart.grandTotal.toDouble();
        setState(() {
          paymentPassed = paymentPassed;
          change = paymentPassed ? pay - cart.grandTotal.toDouble() : 0;
        });
      });
      payNode.requestFocus();
      payController.selection =
          const TextSelection(baseOffset: 0, extentOffset: 1);
    }
    super.initState();
  }

  @override
  void dispose() {
    payController.dispose();
    super.dispose();
  }

  void setPaymentMethod(String type) {
    setState(() {
      paymentMethod = type;
    });
    payController.text = type == 'cash'
        ? '0'
        : (controller.state as TransactionInProgress).grandTotal.toString();
    if (type == 'cash') {
      payNode.requestFocus();
      payController.selection =
          const TextSelection(baseOffset: 0, extentOffset: 0);
    } else {
      payRefNode.requestFocus();
    }
  }

  void submitTransaction() {
    controller.submitTransaction(
        paymentMethod, double.parse(payController.text), payRefController.text);
  }

  Row rowField(String label, dynamic content, TextTheme textTheme) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyLarge?.copyWith(color: Colors.grey.shade800),
          ),
          content is String
              ? Text(
                  content,
                  style: textTheme.headlineSmall
                      ?.copyWith(color: Colors.grey.shade900),
                )
              : content,
        ],
      );

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Obx(
      () {
        if (controller.state is TransactionInProgress) {
          return Dialog(
            child: Container(
              width: isMobile ? double.infinity : 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        'Pembayaran Tiket',
                        style: textTheme.headlineSmall,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                          color: Colors.black54,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: rowField(
                        'Total',
                        CurrencyFormat.idr(
                            (controller.state as TransactionInProgress)
                                .grandTotal
                                .toDouble(),
                            0),
                        textTheme,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Metode Pembayaran'),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: PaymentMethodButton(
                            name: 'TUNAI',
                            active: paymentMethod == 'cash',
                            value: 'cash',
                            onSelect: setPaymentMethod,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: PaymentMethodButton(
                            name: 'QRIS',
                            active: paymentMethod == 'qris',
                            value: 'qris',
                            onSelect: setPaymentMethod,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    rowField(
                      'Bayar',
                      Flexible(
                        fit: FlexFit.tight,
                        child: TextFormField(
                          style: textTheme.headlineSmall?.copyWith(
                            color: paymentPassed
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                          textAlign: TextAlign.right,
                          controller: payController,
                          keyboardType: TextInputType.number,
                          focusNode: payNode,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Total Bayar',
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w200,
                              fontSize: 14,
                            ),
                          ),
                          readOnly: paymentMethod != 'cash',
                          scrollPadding: EdgeInsets.only(
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 10,
                          ),
                        ),
                      ),
                      textTheme,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    paymentMethod == 'cash'
                        ? rowField(
                            'Kembali',
                            Text(
                              CurrencyFormat.idr(change, 0),
                              style: textTheme.headlineSmall
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            textTheme)
                        : rowField(
                            'No. Ref',
                            Flexible(
                              fit: FlexFit.tight,
                              child: TextFormField(
                                style: textTheme.headlineSmall,
                                textAlign: TextAlign.right,
                                controller: payRefController,
                                focusNode: payRefNode,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'No. Referensi',
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                  ),
                                ),
                                scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                          10,
                                ),
                              ),
                            ),
                            textTheme,
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 15),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 0.5,
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey.shade700,
                            ),
                            child: const Text('Batal'),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton.icon(
                            icon: controller.loading
                                ? const SizedBox(
                                    height: 10,
                                    width: 10,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    CupertinoIcons.printer,
                                    size: 18,
                                  ),
                            onPressed: (paymentPassed && !controller.loading)
                                ? () => settingController.printer
                                        is PrinterConnected
                                    ? submitTransaction()
                                    : settingController.openPrinterSetting()
                                : null,
                            label: const Text('DIBAYAR'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Dialog(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
