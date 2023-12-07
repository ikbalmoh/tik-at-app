import 'package:tik_at_app/data/network/api.dart';

class TicketService {
  final Api api = Api();

  Future loadTickets() async {
    return await api.tickets();
  }
}
