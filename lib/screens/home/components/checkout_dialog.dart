import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gartix/components/payment_method_button.dart';
import 'package:gartix/modules/setting/setting.dart';
import 'package:gartix/modules/transaction/transaction.dart';
import 'package:gartix/utils/utils.dart';
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

  double pay = 0;
  double change = 0;
  bool paymentPassed = false;

  final _formatter = CurrencyFormat.currencyInput();

  FocusNode payNode = FocusNode();
  FocusNode payRefNode = FocusNode();

  @override
  void initState() {
    if (controller.state is TransactionInProgress) {
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

  void onChangePayAmount(double value) {
    TransactionInProgress cart = controller.state as TransactionInProgress;
    paymentPassed = value >= cart.grandTotal.toDouble();
    setState(() {
      pay = value;
      paymentPassed = paymentPassed;
      change = paymentPassed ? value - cart.grandTotal.toDouble() : 0;
    });
  }

  void setPaymentMethod(String type) {
    setState(() {
      paymentMethod = type;
    });
    double grandTotal = (controller.state as TransactionInProgress).grandTotal;
    final amountText = _formatter.formatDouble(grandTotal);
    payController.text = type == 'cash' ? '0' : amountText;
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
      paymentMethod: paymentMethod,
      pay: double.parse(payController.text),
      refNo: payRefController.text,
      printTicket: false,
    );
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
          var paymentCard = Container(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.green.shade700,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: rowField(
                      'Total',
                      Text(
                        CurrencyFormat.idr(
                            (controller.state as TransactionInProgress)
                                .grandTotal
                                .toDouble(),
                            0),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                      ),
                      textTheme,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text('Pilih Metode Pembayaran'),
                  const SizedBox(
                    height: 10,
                  ),
                  PaymentMethodButton(
                    name: 'TUNAI',
                    active: paymentMethod == 'cash',
                    value: 'cash',
                    onSelect: setPaymentMethod,
                  ),
                  PaymentMethodButton(
                    name: 'NON TUNAI / QRIS',
                    active: paymentMethod == 'qris',
                    value: 'qris',
                    onSelect: setPaymentMethod,
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
                        onTap: () => payController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: payController.value.text.length,
                        ),
                        inputFormatters: [_formatter],
                        onChanged: (_) => onChangePayAmount(
                            _formatter.getUnformattedValue().toDouble()),
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
                          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
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
                              ? () =>
                                  settingController.printer is PrinterConnected
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
          );
          return Scaffold(
            appBar: AppBar(
              title: const Text('Pembayaran Tiket'),
              elevation: 3,
            ),
            backgroundColor: Colors.grey.shade100,
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: paymentCard,
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
