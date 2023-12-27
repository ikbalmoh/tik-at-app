import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class PrinterManager extends StatefulWidget {
  const PrinterManager({super.key});

  @override
  State<PrinterManager> createState() => _PrinterManagerState();
}

class _PrinterManagerState extends State<PrinterManager> {
  SettingController controller = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.devices.isEmpty) {
        controller.scanPrinters();
      }
    });
    super.initState();
  }

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

    return Obx(
      () => Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 5),
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
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () => controller.scanPrinters(),
                            icon: const Icon(
                              CupertinoIcons.search,
                              size: 18,
                            ),
                          )
                  ],
                ),
              ),
              controller.devices.isNotEmpty
                  ? Column(
                      children: controller.devices
                          .map((d) => ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 0,
                                ),
                                title: Text(d.name ?? ''),
                                subtitle: Text(d.address ?? '-'),
                                onTap: () => controller.selectPrinter(d),
                                trailing:
                                    deviceIndicator(controller.printer, d),
                              ))
                          .toList(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          controller.loading
                              ? 'Mencari Perangkat'
                              : 'Tidak Ada Perangkat Terdeteksi',
                          style: const TextStyle(
                            color: Colors.grey,
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
        ),
      ),
    );
  }
}
