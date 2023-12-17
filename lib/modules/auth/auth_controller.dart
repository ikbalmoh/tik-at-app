import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:tik_at_app/models/user.dart';
import 'package:tik_at_app/modules/auth/auth.dart';
import 'package:tik_at_app/routes/routes.dart';

class AuthController extends GetxController {
  final GetStorage box = GetStorage();

  final AuthService _service;

  AuthController(this._service);

  final _authState = const AuthState().obs;

  AuthState get state => _authState.value;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future init() async {
    _authState.value = AuthInitial();
    final token = box.read('token');
    if (kDebugMode) {
      print('USER TOKEN: $token');
    }
    if (box.hasData('token')) {
      _getAuthenticatedUser();
    } else {
      _authState.value = UnAuthenticated();
    }
  }

  Future login(String username, String password) async {
    _authState.value = AuthLoading();

    try {
      final data = await _service.login(username, password);

      if (data is Map && data.containsKey('token')) {
        box.write('token', data['token']);

        final user = User.fromJson(data['user']);
        box.write('user', jsonEncode(user.toJson()));

        _authState.value = Authenticated(user: user, token: data['token']);
        Get.offAllNamed(Routes.home);
      } else {
        _authState.value = UnAuthenticated();
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('LOGN ERROR: ${e.message}');
      }
      String message = e.response?.data['message'] ?? e.message;
      Get.snackbar(
        'Login Gagal',
        message,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
      _authState.value = AuthFailure(message: message);
      box.remove('user');
      box.remove('token');
    }
  }

  void _getAuthenticatedUser() async {
    _authState.value = AuthLoading();
    try {
      final dataUser = await _service.user();
      final user = User.fromJson(dataUser);
      _authState.value = Authenticated(user: user, token: box.read('token'));
      if (kDebugMode) {
        print('USER AUTHENTICATED: ${user.toString()}');
      }
      if (Get.currentRoute != Routes.home) {
        Get.offAllNamed(Routes.home);
      }
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      _authState.value = AuthFailure(message: message);
      box.remove('user');
      box.remove('token');
      Get.showSnackbar(
        GetSnackBar(
          title: message,
          message: 'Silahkan Login Kembali',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
      if (Get.currentRoute != Routes.login) {
        Get.offAllNamed(Routes.login);
      }
    }
  }

  Future logout() async {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.all(20),
      title: 'Logout',
      content: const Text('Apakah Anda ingin keluar dari aplikasi?'),
      confirm: TextButton(
        onPressed: () {
          _authState.value = AuthInitial();

          box.remove('user');
          box.remove('token');

          Get.offAllNamed(Routes.login);
        },
        style: TextButton.styleFrom(foregroundColor: Colors.red),
        child: const Text('Logout'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        style: TextButton.styleFrom(foregroundColor: Colors.grey.shade800),
        child: const Text('Tidak'),
      ),
    );
  }
}
