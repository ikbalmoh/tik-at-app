import 'package:get/get.dart';

import 'package:tik_at_app/modules/ticket/ticket.dart';

class TicketBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TicketController(TicketService()));
  }
}
