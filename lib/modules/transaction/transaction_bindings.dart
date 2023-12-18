import 'package:get/get.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';

class TransactionBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionController(
        TransactionService(), SettingController(SettingService())));
  }
}
