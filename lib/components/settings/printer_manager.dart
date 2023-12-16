import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/setting/setting.dart';

class PrinterManager extends StatefulWidget {
  const PrinterManager({super.key});

  @override
  State<PrinterManager> createState() => _PrinterManagerState();
}

class _PrinterManagerState extends State<PrinterManager> {
  SettingController controller = Get.find();

  Widget? deviceIndicator(PrinterState state, BluetoothDevice device) {
    if (state is PrinterConnecting && state.device.address == device.address) {
      return const SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    } else if (state is PrinterConnected &&
        state.device.address == device.address) {
      return const Icon(
        Icons.check,
        color: Colors.green,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: Colors.black12,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Printer',
                  style: textTheme.headlineSmall,
                ),
                controller.loading
                    ? const SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : IconButton(
                        onPressed: () => controller.scanPrinters(),
                        icon: const Icon(
                          CupertinoIcons.search,
                          size: 18,
                        ),
                      )
              ],
            ),
          ),
          StreamBuilder<List<BluetoothDevice>>(
            stream: controller.bluetoothPrint.scanResults,
            initialData: const [],
            builder: (c, snapshot) => snapshot.data!.isNotEmpty
                ? Column(
                    children: snapshot.data!
                        .map(
                          (d) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            title: Text(d.name ?? ''),
                            subtitle: Text(d.address ?? '-'),
                            onTap: () => controller.selectPrinter(d),
                            trailing: deviceIndicator(controller.printer, d),
                          ),
                        )
                        .toList(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: controller.loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Tidak Ada Perangkat',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Get.back(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
                child: const Text('Tutup'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
