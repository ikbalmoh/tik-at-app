import 'package:get/get.dart';

import './ticket.dart';

class TicketBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketController(TicketService()));
  }
}
