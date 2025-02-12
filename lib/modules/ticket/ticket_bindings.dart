import 'package:get/get.dart';

import 'package:gartix/modules/ticket/ticket.dart';

class TicketBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketController(TicketService()));
  }
}
