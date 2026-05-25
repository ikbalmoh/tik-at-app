import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:gartix/modules/ticket/model/ticket_type.dart';
import 'package:gartix/modules/ticket/controller/ticket.dart';
import 'package:gartix/modules/transaction/controller/transaction.dart';
import './components/add_ticket_dialog.dart';
import './components/ticket_item.dart';

class TicketContainer extends StatefulWidget {
  const TicketContainer({super.key});

  @override
  State<TicketContainer> createState() => _TicketContainerState();
}

class _TicketContainerState extends State<TicketContainer> {
  TicketController controller = Get.find();
  TransactionController transactionController = Get.find();

  void selectTicket(TicketType ticket) {
    Get.dialog(
      AddTicketDialog(
        ticket: ticket,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE);
    bool isTablet = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
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
                child: RefreshIndicator(
              onRefresh: () => controller.loadTickets(),
              child: GridView.count(
                padding: const EdgeInsets.all(15),
                physics: const ScrollPhysics(),
                shrinkWrap: false,
                crossAxisCount: isMobile
                    ? 1
                    : isTablet
                        ? 2
                        : 3,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1.5,
                children: state.tickets.asMap().entries.map((ticket) {
                  return TicketItem(
                    ticket: ticket.value,
                    onPress: () => selectTicket(ticket.value),
                    qtyCart: transactionController.state
                            is TransactionInProgress
                        ? (transactionController.state as TransactionInProgress)
                                .tickets
                                .firstWhereOrNull(
                                    (t) => t.ticketTypeId == ticket.value.id)
                                ?.qty ??
                            0
                        : 0,
                  );
                }).toList(),
              ),
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
