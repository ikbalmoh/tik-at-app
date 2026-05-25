import 'package:get/get.dart';
import './transaction.dart';

class TransactionBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionController(TransactionService()));
  }
}
