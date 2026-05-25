import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gartix/modules/auth/controller/auth_controller.dart';
import 'package:validators/validators.dart';
import 'package:get/get.dart' hide Response;

final GetStorage box = GetStorage();

Dio fetch({bool ignoreBaseUrl = false}) {
  Dio dio = Dio();

  dio.interceptors
      .add(CustomInterceptors(dio: dio, ignoreBaseUrl: ignoreBaseUrl));

  return dio;
}

class CustomInterceptors extends Interceptor {
  Dio dio;
  bool ignoreBaseUrl;

  CustomInterceptors({required this.dio, required this.ignoreBaseUrl});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!ignoreBaseUrl && box.hasData('api')) {
      String apiUrl = box.read('api');
      options.baseUrl = '$apiUrl/api';
    }
    if (kDebugMode) {
      print(
          'REQUEST[${options.method}]\n => PATH: ${options.path}\n => DATA: ${options.data}');
    }

    String? token = box.read('token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // options.followRedirects = false;
    // options.validateStatus = (status) => status != null && status < 500;

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'RESPONSE[${response.statusCode}]\n => PATH: ${response.requestOptions.path}\n => DATA: ${response.data}');
    }
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    dynamic originalData = err.response?.data;
    bool json = err.response?.data != null
        ? isJSON(jsonEncode(err.response?.data))
        : false;
    String message = err.message ?? 'Unexpected Error Occured!';
    if (err.response?.data is String) {
      message = err.response?.data;
    } else if (err.response?.data['msg'] != null) {
      message = err.response?.data?['msg'];
    } else if (err.response?.data['message'] != null) {
      message = err.response?.data?['message'];
    } else if (err.response?.statusCode == 422) {
      message = 'Invalid data. Please check your input and try again.';
    } else {
      message = 'Unexpected Error Occured!';
    }
    err = err.copyWith(message: message);
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] \n => JSON: $json\n=> PATH: ${err.requestOptions.path}\n => DATA: $originalData');
    }

    if (err.response?.statusCode == 401) {
      AuthController authController = Get.find();
      authController.clearAuth();
    }

    super.onError(err, handler);
  }
}
