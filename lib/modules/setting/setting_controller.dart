import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/components/settings/api_config.dart';
import 'package:tik_at_app/components/settings/printer_manager.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class SettingController extends GetxController {
  final GetStorage box = GetStorage();

  final SettingService _service;

  SettingController(this._service);

  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  final _loading = false.obs;

  final _api = ''.obs;
  final _printerState = const PrinterState().obs;

  bool get loading => _loading.value;
  String get api => _api.value;
  PrinterState get printer => _printerState.value;

  @override
  void onInit() {
    initSetting();
    super.onInit();
  }

  void initSetting() {
    if (box.hasData('api')) {
      _api.value = box.read('api');
    }
  }

  void initPrinter() {
    listenPrinterState();
    if (box.hasData('printer')) {
      final BluetoothDevice device =
          BluetoothDevice.fromJson(box.read('printer'));
      if (kDebugMode) {
        print('HAS CONNECTED PRINTER: ${device.toJson()}');
      }
      selectPrinter(device);
    } else {
      if (kDebugMode) {
        print('NO CONNECTED PRINTER');
      }
      _printerState.value = PrinterNotSelected();
    }
  }

  Future setApiUrl(String url) async {
    _loading.value = true;
    try {
      await _service.ping(url);
      await box.write('api', url);
      _api.value = url;
      _loading.value = false;
      return Future.value(true);
    } on DioException catch (e) {
      _loading.value = false;
      String message =
          e.response?.data['message'] ?? 'Tidak Dapat Terhubung Ke Server';
      return Future.error(message);
    } catch (e) {
      _loading.value = false;
      return Future.error('Tidak Dapat Terhubung');
    }
  }

  void openApiSetting() {
    Get.dialog(
      const Dialog(
        child: ApiConfig(),
      ),
      barrierDismissible: false,
    );
  }

  void openPrinterSetting() {
    Get.dialog(
      const Dialog(
        child: PrinterManager(),
      ),
      barrierDismissible: false,
    );
  }

  void listenPrinterState() {
    bluetoothPrint.state.listen((state) {
      if (kDebugMode) {
        print('PRINTER STATUS: $state');
      }

      switch (state) {
        case BluetoothPrint.CONNECTED:
          Get.showSnackbar(
            const GetSnackBar(
              title: 'Printer',
              message: 'Terhubung ke perangkat',
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
              snackPosition: SnackPosition.TOP,
            ),
          );
          break;
        case BluetoothPrint.DISCONNECTED:
          box.remove('printer');
          Get.showSnackbar(
            const GetSnackBar(
              title: 'Printer',
              message: 'Koneksi terputus',
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.red,
              snackPosition: SnackPosition.TOP,
            ),
          );
          break;
        default:
      }
    });
  }

  void scanPrinters() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 5));
    bluetoothPrint.isScanning.listen((scaning) {
      _loading.value = scaning;
    });
  }

  void selectPrinter(BluetoothDevice device) async {
    try {
      if (kDebugMode) {
        print('SELECT PRINTER : ${device.toJson()}');
      }
      _printerState.value = PrinterConnecting(device: device);
      await bluetoothPrint.connect(device);
      bool? connected = await bluetoothPrint.isConnected;
      if (connected!) {
        _printerState.value = PrinterConnected(device: device);
        box.write('printer', device.toJson());
      } else {
        _printerState.value = PrinterNotSelected();
        throw Exception('Tidak dapat terhubung ke perangkat');
      }
    } on Exception catch (e) {
      if (kDebugMode) {
        print('FAILED SELECT PRINTER : $e');
      }
    }
  }
}
