import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/utils/fetch.dart';

class SettingService {
  final api = fetch(ignoreBaseUrl: true);

  final GetStorage box = GetStorage();

  Future ping(String url) async {
    return await api.get('$url/api/ping');
  }
}
