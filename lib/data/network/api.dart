import 'package:tik_at_app/utils/fetch.dart';

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
    final res = await api.post('/auth/operator', data: data);

    return res.data;
  }

  Future user() async {
    final res = await api.get('/user');
    return res.data;
  }
}
