import 'package:get/get.dart';
import 'package:gartix/modules/transaction/transaction.dart';

class TransactionBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionController(TransactionService()));
  }
}
