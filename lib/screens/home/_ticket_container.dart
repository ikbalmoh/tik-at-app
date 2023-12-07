import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/ticket/ticket.dart';
import 'package:tik_at_app/screens/home/components/ticket_item.dart';

final List<Color> _colors = [
  Colors.orange.shade200,
  Colors.blue.shade200,
  Colors.pink.shade200,
  Colors.green.shade200,
  Colors.indigo.shade200
];

class TicketContainer extends StatefulWidget {
  const TicketContainer({super.key});

  @override
  State<TicketContainer> createState() => _TicketContainerState();
}

class _TicketContainerState extends State<TicketContainer> {
  TicketController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.state is TicketFailure) {
        TicketFailure state = controller.state as TicketFailure;
        return Center(
          child: Text(state.message),
        );
      } else if (controller.state is TicketLoaded) {
        TicketLoaded state = controller.state as TicketLoaded;
        return GridView.count(
          padding: const EdgeInsets.all(15),
          physics: const ScrollPhysics(),
          shrinkWrap: false,
          crossAxisCount: 3,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 1.5,
          children: state.tickets.asMap().entries.map((ticket) {
            return TicketItem(
              ticket: ticket.value,
              color: _colors[ticket.key],
            );
          }).toList(),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
