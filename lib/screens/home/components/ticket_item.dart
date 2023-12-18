import 'package:flutter/material.dart';
import 'package:tik_at_app/models/ticket_type.dart';
import 'package:tik_at_app/utils/utils.dart';

class TicketItem extends StatelessWidget {
  final TicketType ticket;
  final Function onPress;
  final int qtyCart;

  const TicketItem(
      {super.key,
      required this.ticket,
      required this.onPress,
      required this.qtyCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ticket.color,
      child: InkWell(
        onTap: () => onPress(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Badge(
                  isLabelVisible: qtyCart > 0,
                  label: Text(
                    qtyCart.toString(),
                  ),
                  offset: const Offset(20, 0),
                  child: Text(
                    ticket.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  CurrencyFormat.idr(ticket.price, 0),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
