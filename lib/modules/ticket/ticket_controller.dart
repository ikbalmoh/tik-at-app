import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tik_at_app/models/ticket_type.dart';
import 'package:tik_at_app/modules/ticket/ticket.dart';
import 'package:tik_at_app/data/colors.dart';

class TicketController extends GetxController {
  final GetStorage box = GetStorage();

  final TicketService _service;

  TicketController(this._service);

  final _state = const TicketState().obs;
  TicketState get state => _state.value;

  @override
  void onInit() {
    loadTickets();
    super.onInit();
  }

  Future loadTickets() async {
    List<TicketType> tickets = [];
    try {
      _state.value = TicketLoading();
      final List<dynamic> data = await _service.loadTickets();
      box.write('tickets', data);
      for (final json in data) {
        json['color'] = colors[json['id']] ?? 0xffbee3db;
        if (kDebugMode) {
          print(json);
        }
        tickets.add(TicketType.fromJson(json));
      }
      _state.value = TicketLoaded(tickets: tickets);
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? e.message;
      _state.value = TicketFailure(message: message);
      if (box.hasData('tickets')) {
        final List<dynamic> savedTickets = box.read('tickets');
        for (final json in savedTickets) {
          json['color'] = colors[json['id']] ?? 0xffbee3db;
          tickets.add(TicketType.fromJson(json));
          _state.value = TicketLoaded(tickets: tickets);
        }
      }
    }
  }
}
