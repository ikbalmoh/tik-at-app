import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/components/settings/api_config.dart';
import 'package:tik_at_app/modules/setting/setting.dart';

class SettingController extends GetxController {
  final GetStorage box = GetStorage();

  final SettingService _service;

  SettingController(this._service);

  final _api = ''.obs;
  final _loading = false.obs;

  String get api => _api.value;
  bool get loading => _loading.value;

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
}
