import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/components/settings/api_config.dart';
import 'package:tik_at_app/components/settings/printer_manager.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';

class SettingController extends GetxController {
  final GetStorage box = GetStorage();

  final SettingService _service;

  SettingController(this._service);

  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  final _loading = false.obs;

  final _api = ''.obs;
  final _printerState = const PrinterState().obs;
  final _devices = <BluetoothDevice>[].obs;

  bool get loading => _loading.value;
  String get api => _api.value;
  PrinterState get printer => _printerState.value;
  List<BluetoothDevice> get devices => _devices;

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
          BluetoothDevice.fromMap(box.read('printer'));
      if (kDebugMode) {
        print('HAS CONNECTED PRINTER: ${device.toMap()}');
      }
      selectPrinter(device);
    } else {
      if (kDebugMode) {
        print('NO CONNECTED PRINTER');
      }
      _printerState.value = PrinterNotConnected();
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
      // barrierDismissible: false,
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
    bluetooth.onStateChanged().listen((state) {
      if (kDebugMode) {
        print('PRINTER STATUS: $state');
      }

      if (state != BlueThermalPrinter.CONNECTED) {
        _printerState.value = PrinterNotConnected();
      }

      String message = '';

      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          message = "connected";
          break;
        case BlueThermalPrinter.DISCONNECTED:
          message = "disconnected";
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          message = "disconnect requested";
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          message = "bluetooth turning off";
          break;
        case BlueThermalPrinter.STATE_OFF:
          message = "bluetooth off";
          break;
        case BlueThermalPrinter.STATE_ON:
          message = "bluetooth on";
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          message = "bluetooth turning on";
          break;
        case BlueThermalPrinter.ERROR:
          message = "error";
          break;
        default:
          break;
      }

      Get.showSnackbar(
        GetSnackBar(
          title: 'Printer',
          message: message,
          icon: const Icon(
            CupertinoIcons.printer,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
        ),
      );
    });
  }

  void scanPrinters() async {
    List<BluetoothDevice> boundedDevices = [];
    try {
      _loading.value = true;
      boundedDevices = await bluetooth.getBondedDevices();
      if (kDebugMode) {
        print('PRINTER FOUND: $boundedDevices');
      }
      _loading.value = false;
    } on PlatformException {
      _loading.value = false;
    }
    _devices.value = boundedDevices;
  }

  void selectPrinter(BluetoothDevice device) async {
    try {
      if (kDebugMode) {
        print('SELECT PRINTER : ${device.toMap()}');
      }
      bool currentConnected = await bluetooth.isConnected ?? false;
      if (currentConnected && _printerState.value is PrinterConnected) {
        if ((_printerState.value as PrinterConnected).device.address ==
            device.address) {
          _printerState.value = PrinterNotConnected();
          await bluetooth.disconnect();
          return;
        }
      }
      if (kDebugMode) {
        print('CONNECT TO PRINTER : ${device.toMap()}');
      }
      _printerState.value = PrinterConnecting(device: device);
      await bluetooth.connect(device);
      bool connected = await bluetooth.isConnected ?? false;
      if (kDebugMode) {
        print('CONNECTED TO PRINTER : ${device.toMap()}');
      }
      if (connected) {
        _printerState.value = PrinterConnected(device: device);
        box.write('printer', device.toMap());
        await printExample();
      } else {
        _printerState.value = PrinterNotConnected();
        throw Exception('Tidak dapat terhubung ke perangkat');
      }
    } on Error catch (e) {
      if (kDebugMode) {
        print('FAILED SELECT PRINTER : $e');
      }
      Get.showSnackbar(
        GetSnackBar(
          title: 'Printer Error',
          message: e.toString(),
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP,
        ),
      );
    }
  }

  Future printExample() async {}
}
