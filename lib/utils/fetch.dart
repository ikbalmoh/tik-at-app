import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:validators/validators.dart';

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
    if (err.response == null || err.response?.data != null) {
      if (!isJSON(err.response?.data)) {
        err.response?.data = {'message': 'Tidak dapat terhubung ke server'};
      }
    }
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] \n => PATH: ${err.requestOptions.path}\n => DATA: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}
