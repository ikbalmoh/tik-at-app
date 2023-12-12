import 'package:tik_at_app/utils/fetch.dart';

class ApiUrl {
  static const String auth = '/auth/operator';
  static const String user = '/user';
  static const String ticketTypes = '/ticket/types';
  static const String transaction = '/transaction';
}

class Api {
  final api = fetch();

  Future<dynamic> login(
    String username,
    String password,
    String deviceName,
  ) async {
    final data = {
      'username': username,
      'password': password,
      'device_name': deviceName
    };
    final res = await api.post(ApiUrl.auth, data: data);

    return res.data;
  }

  Future user() async {
    final res = await api.get(ApiUrl.user);
    return res.data;
  }

  Future tickets() async {
    final res = await api.get(ApiUrl.ticketTypes);
    return res.data;
  }

  Future transaction(Object data) async {
    final res = await api.post(ApiUrl.transaction, data: data);
    return res.data;
  }
}
