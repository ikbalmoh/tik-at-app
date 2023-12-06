import 'package:flutter/material.dart';
import 'package:tik_at_app/screens/home/components/ticket.dart';

final List<String> _tickets = ['Dewasa', 'Anak-anak', 'Mancanegara'];

final List<Color> _colors = [
  Colors.orange.shade200,
  Colors.blue.shade200,
  Colors.pink.shade200,
  Colors.green.shade200,
  Colors.indigo.shade200
];

class TicketContainer extends StatelessWidget {
  const TicketContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(15),
      physics: const ScrollPhysics(),
      shrinkWrap: false,
      crossAxisCount: 3,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: _tickets.asMap().entries.map((ticket) {
        return Ticket(
          ticketName: ticket.value,
          color: _colors[ticket.key],
        );
      }).toList(),
    );
  }
}
