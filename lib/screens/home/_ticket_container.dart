import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tik_at_app/screens/home/_ticket.dart';

final List<String> _tickets = ['Dewasa', 'Anak-anak', 'Mancanegara'];

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
      children: _tickets.map((ticketName) {
        return Ticket(ticketName: ticketName);
      }).toList(),
    );
  }
}
