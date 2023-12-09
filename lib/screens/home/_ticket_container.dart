import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/models/ticket.dart';
import 'package:tik_at_app/modules/ticket/ticket.dart';
import 'package:tik_at_app/screens/home/components/add_ticket_dialog.dart';
import 'package:tik_at_app/screens/home/components/ticket_item.dart';

class TicketContainer extends StatefulWidget {
  const TicketContainer({super.key});

  @override
  State<TicketContainer> createState() => _TicketContainerState();
}

class _TicketContainerState extends State<TicketContainer> {
  TicketController controller = Get.find();

  void selectTicket(Ticket ticket) {
    Get.dialog(AddTicketDialog(
      ticket: ticket,
    ));
  }

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
        return Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Text(
                'Pilih Tiket',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey.shade700,
                    ),
              ),
            ),
            Expanded(
                child: GridView.count(
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
                  onPress: () => selectTicket(ticket.value),
                );
              }).toList(),
            ))
          ],
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
