import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          BluetoothDevice.fromJson(box.read('printer'));
      if (kDebugMode) {
        print('HAS CONNECTED PRINTER: ${device.toJson()}');
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
          _printerState.value = PrinterNotConnected();
          Get.showSnackbar(
            const GetSnackBar(
              title: 'Printer',
              message: 'Koneksi printer terputus',
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
    bool isConnected = await bluetoothPrint.isConnected ?? false;
    bluetoothPrint.startScan(timeout: const Duration(seconds: 5));
    bluetoothPrint.isScanning.listen((scaning) {
      _loading.value = scaning;
    });
    bluetoothPrint.scanResults.listen((results) {
      final deviceList = results;
      if (kDebugMode) {
        print('PRINTER FOUND: ${results.length}');
      }
      if (isConnected) {
        BluetoothDevice current =
            (_printerState.value as PrinterConnected).device;
        BluetoothDevice? isCurrentExist =
            deviceList.firstWhereOrNull((r) => r.address == current.address);
        if (isCurrentExist == null) {
          deviceList.add(current);
        }
      }
      _devices.value = deviceList;
    });
  }

  void selectPrinter(BluetoothDevice device) async {
    try {
      if (kDebugMode) {
        print('SELECT PRINTER : ${device.toJson()}');
      }
      bool currentConnected = await bluetoothPrint.isConnected ?? false;
      if (currentConnected && _printerState.value is PrinterConnected) {
        if ((_printerState.value as PrinterConnected).device.address ==
            device.address) {
          _printerState.value = PrinterNotConnected();
          await bluetoothPrint.disconnect();
          return;
        }
      }
      if (kDebugMode) {
        print('CONNECT TO PRINTER : ${device.toJson()}');
      }
      _printerState.value = PrinterConnecting(device: device);
      await bluetoothPrint.connect(device);
      bool connected = await bluetoothPrint.isConnected ?? false;
      if (kDebugMode) {
        print('CONNECTED TO PRINTER : ${device.toJson()}');
      }
      if (connected) {
        _printerState.value = PrinterConnected(device: device);
        box.write('printer', device.toJson());
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

  Future printExample() async {
    Map<String, dynamic> config = {};
    List<LineText> list = [];
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'A Title',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'this is conent left',
        weight: 0,
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: 'this is conent right',
        align: LineText.ALIGN_RIGHT,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_BARCODE,
        content: 'A12312112',
        size: 10,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        type: LineText.TYPE_QRCODE,
        content: 'qrcode i',
        size: 10,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    list.add(LineText(linefeed: 1));

    ByteData data = await rootBundle.load("assets/images/ticket.png");
    List<int> imageBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    String base64Image = base64Encode(imageBytes);
    list.add(LineText(
        type: LineText.TYPE_IMAGE,
        content: base64Image,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));

    if (kDebugMode) {
      print('PRINTING EXAMPLE: ${list.length} line');
    }
    return bluetoothPrint.printReceipt(config, list);
  }
}
