import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/components/settings/api_config.dart';
import 'package:tik_at_app/components/settings/printer_manager.dart';
import 'package:tik_at_app/models/ticket.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:tik_at_app/utils/utils.dart';

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
    initPrinter();
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
      Color color = Colors.black;

      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          message = "connected";
          color = Colors.green;
          break;
        case BlueThermalPrinter.DISCONNECTED:
          message = "disconnected";
          color = Colors.red;
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
          color = Colors.red;
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
          backgroundColor: color,
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
        print('${boundedDevices.length} PRINTERS FOUND');
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
      bool availble = await bluetooth.isAvailable ?? false;
      if (!availble) {
        _printerState.value = PrinterNotConnected();
        if (kDebugMode) {
          print('PRINTER IS NOT AVAILABLE');
        }
        return;
      }
      bool currentConnected = await bluetooth.isConnected ?? false;
      if (currentConnected) {
        await bluetooth.disconnect();
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
    } on PlatformException catch (e) {
      _printerState.value = PrinterNotConnected();
      if (kDebugMode) {
        print('FAILED SELECT PRINTER : $e');
      }
      Get.showSnackbar(
        GetSnackBar(
          title: 'Periksa Koneksi Printer',
          message: e.message,
          icon: const Icon(
            CupertinoIcons.printer,
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
    bool? isConnected = await bluetooth.isConnected ?? false;
    if (!isConnected) {
      throw Future.error('printer tidak terkoneksi');
    }

    ByteData bytesAsset = await rootBundle.load("assets/images/garut-bw.jpg");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    bluetooth.printCustom("TEST PRINTER", 1, 1);
    bluetooth.printNewLine();
    bluetooth.printImageBytes(imageBytesFromAsset);
    bluetooth.printNewLine();
    bluetooth.printCustom('-----------------------------', 1, 1);
    bluetooth.printNewLine();
    bluetooth.printQRcode("Situ Bagendit", 250, 250, 1);
    bluetooth.paperCut();
  }

  Future printTicket(Ticket ticket) async {
    if (kDebugMode) {
      print('PRINT TICKET: ${ticket.toString()}');
    }
    bool? isConnected = await bluetooth.isConnected ?? false;
    if (!isConnected) {
      throw Future.error('printer tidak terkoneksi');
    }
    String separator = '--------------------------------';

    ByteData bytesAsset = await rootBundle.load("assets/images/garut-bw.jpg");
    Uint8List imageBytesFromAsset = bytesAsset.buffer
        .asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

    bluetooth.printImageBytes(imageBytesFromAsset);
    bluetooth.printNewLine();
    bluetooth.printCustom('TIKET MASUK', 3, 1);
    bluetooth.printCustom('Situ Bagendit', 2, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printCustom(separator, 1, 1);
    bluetooth.printLeftRight(
        'Waktu', DateFormat('dd/MM/yy hh:mm').format(ticket.purchaseDate), 1);
    bluetooth.printLeftRight('Operator', ticket.operatorName, 1);
    bluetooth.printCustom(separator, 1, 1);
    bluetooth.printLeftRight('Tiket', ticket.ticketTypeName, 1);
    bluetooth.printLeftRight(
        'Harga', CurrencyFormat.idr(ticket.ticketPrice, 0), 1);
    bluetooth.printLeftRight('Berlaku untuk', '${ticket.entranceMax} orang', 1);
    bluetooth.printCustom(separator, 1, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom('Scan QR Code ', 1, 1);
    bluetooth.printQRcode(ticket.id, 250, 250, 1);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printCustom('Dinas Parisiwisata dan\nKebudayaan Garut', 1, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom('-', 1, 1);
    bluetooth.printNewLine();
    bluetooth.printCustom('Terimakasih atas Kunjungan Anda', 1, 1);
    bluetooth.paperCut();
  }
}
