import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tik_at_app/models/ticket.dart';

class TicketItem extends StatelessWidget {
  final Ticket ticket;
  final Color color;

  const TicketItem({super.key, required this.ticket, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              ticket.name,
              style: GoogleFonts.varelaRound(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
