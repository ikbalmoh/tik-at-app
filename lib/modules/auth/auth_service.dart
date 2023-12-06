import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/data/network/api.dart';

class AuthService {
  final Api api = Api();
  final GetStorage box = GetStorage();

  Future login(String username, String password) async {
    final String deviceName = box.read('device');
    return await api.login(username, password, deviceName);
  }

  Future user() async {
    return await api.user();
  }
}
