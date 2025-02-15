import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
  TextEditingController noteController = TextEditingController();

  double pay = 0;
  double change = 0;
  bool paymentPassed = false;
  bool isGroup = false;

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
    double grandTotal = (controller.state as TransactionInProgress).grandTotal;
    double amount = type == 'cash' ? 0 : grandTotal;
    final amountText = _formatter.formatDouble(amount);
    payController.text = amountText;
    setState(() {
      paymentMethod = type;
      change = 0;
      pay = amount;
      paymentPassed = amount >= grandTotal;
    });
    if (type == 'cash') {
      payNode.requestFocus();
      payController.selection =
          const TextSelection(baseOffset: 0, extentOffset: 1);
    } else {
      payRefNode.requestFocus();
    }
  }

  void submitTransaction() {
    controller.submitTransaction(
      paymentMethod: paymentMethod,
      pay: pay,
      refNo: payRefController.text,
      printTicket: true,
      isGroup: isGroup,
      note: noteController.text,
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
          final cart = controller.state as TransactionInProgress;
          var transactionCard = Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: Colors.grey.shade100))),
                  child: Text(
                    'Pembelian Tiket',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 7.5),
                ListView.builder(
                  itemBuilder: (context, idx) {
                    final ticket = cart.tickets[idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.5),
                      child: Row(
                        children: [
                          Text(
                            CurrencyFormat.idr(ticket.qty, 0, symbol: false),
                            style: textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(ticket.name),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(CurrencyFormat.idr(ticket.total, 0)),
                        ],
                      ),
                    );
                  },
                  itemCount: cart.tickets.length,
                  shrinkWrap: true,
                )
              ],
            ),
          );
          var paymentCard = SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 10 : 20, horizontal: 20)
                .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rowField(
                  'Total Transaksi',
                  Text(
                    CurrencyFormat.idr(
                        (controller.state as TransactionInProgress)
                            .grandTotal
                            .toDouble(),
                        0),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                  ),
                  textTheme,
                ),
                const SizedBox(height: 15),
                rowField(
                  'Tiket Kelompok',
                  Switch(
                      value: isGroup,
                      onChanged: (val) {
                        setState(() {
                          isGroup = val;
                        });
                      }),
                  textTheme,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Pilih Metode Pembayaran',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey.shade800),
                ),
                const SizedBox(
                  height: 5,
                ),
                isMobile
                    ? Column(
                        children: [
                          PaymentMethodButton(
                            name: 'TUNAI',
                            active: paymentMethod == 'cash',
                            value: 'cash',
                            onSelect: setPaymentMethod,
                          ),
                          PaymentMethodButton(
                            name: 'NON TUNAI',
                            active: paymentMethod == 'qris',
                            value: 'qris',
                            onSelect: setPaymentMethod,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: PaymentMethodButton(
                              name: 'TUNAI',
                              active: paymentMethod == 'cash',
                              value: 'cash',
                              onSelect: setPaymentMethod,
                            ),
                          ),
                          Expanded(
                            child: PaymentMethodButton(
                              name: 'NON TUNAI',
                              active: paymentMethod == 'qris',
                              value: 'qris',
                              onSelect: setPaymentMethod,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade50,
                  ),
                  child: rowField(
                    'Jumlah Bayar',
                    Flexible(
                      fit: FlexFit.tight,
                      child: TextFormField(
                        style: textTheme.headlineMedium?.copyWith(
                            color: paymentPassed
                                ? Colors.green.shade700
                                : Colors.blue.shade700,
                            fontWeight: FontWeight.bold),
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
                          hintText: 'Masukkan Nominal',
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
                ),
                const SizedBox(
                  height: 20,
                ),
                paymentMethod == 'cash'
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Kembali',
                              style: textTheme.labelLarge
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(
                              CurrencyFormat.idr(change, 0),
                              style: textTheme.headlineSmall
                                  ?.copyWith(color: Colors.grey.shade800),
                            ),
                          ],
                        ),
                      )
                    : TextFormField(
                        controller: payRefController,
                        focusNode: payRefNode,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'No. Ref',
                          hintText: 'Nomor referensi transaksi',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none),
                          fillColor: Colors.grey.shade50,
                          focusColor: Colors.grey.shade50,
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Catatan',
                    hintText: 'Masukkan catatan untuk transaksi ini',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none),
                    fillColor: Colors.grey.shade50,
                    focusColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          );

          return Scaffold(
            appBar: AppBar(
              title: const Text('Pembayaran Tiket'),
              elevation: 3,
              actions: [
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
                      ? () => settingController.printer is PrinterConnected ||
                              kDebugMode
                          ? submitTransaction()
                          : settingController.openPrinterSetting()
                      : null,
                  label: const Text('TRANSAKSI SELESAI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            backgroundColor: Colors.grey.shade100,
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: isMobile
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [transactionCard, paymentCard],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: transactionCard,
                          ),
                          Container(
                            height: double.maxFinite,
                            width: 1,
                            color: Colors.blueGrey.shade50,
                          ),
                          Expanded(child: paymentCard)
                        ],
                      ),
              ),
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
