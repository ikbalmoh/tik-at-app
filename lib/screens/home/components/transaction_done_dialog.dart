import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';

class TransactionDoneDialog extends StatefulWidget {
  const TransactionDoneDialog({super.key});

  @override
  State<TransactionDoneDialog> createState() => _TransactionDoneDialogState();
}

class _TransactionDoneDialogState extends State<TransactionDoneDialog> {
  TransactionController controller = Get.find();
  SettingController setting = Get.find();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Obx(() {
      if (controller.state is TransactionDone) {
        TransactionDone state = controller.state as TransactionDone;
        bool done = state.printCount >= state.tickets.length;
        return Dialog(
            child: Container(
          width: isMobile ? double.infinity : 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  'Mencetak Tiket',
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              state.printing
                  ? const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : done
                      ? const Icon(
                          CupertinoIcons.checkmark_alt,
                          size: 38,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.print_disabled,
                          size: 38,
                          color: Colors.red,
                        ),
              const SizedBox(
                height: 10,
              ),
              Text(
                state.printing || !done
                    ? '${state.printCount} / ${state.tickets.length}'
                    : 'Tiket Selesai Dicetak',
                style: textTheme.bodyLarge?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => setting.printer is PrinterConnected
                        ? controller.printTransactionTickets()
                        : setting.openPrinterSetting(),
                    child: const Text(
                      'Cetak Lagi',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: !state.printing && done
                        ? () => controller.resetTransaction(snackbar: false)
                        : null,
                    child: const Text('Selesai'),
                  )
                ],
              )
            ],
          ),
        ));
      }

      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    });
  }
}
