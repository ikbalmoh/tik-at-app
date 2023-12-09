import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tik_at_app/models/ticket.dart';

class TicketItem extends StatelessWidget {
  final Ticket ticket;
  final Function onPress;

  const TicketItem({super.key, required this.ticket, required this.onPress});

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
                Text(
                  ticket.name,
                  style: GoogleFonts.varelaRound(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  ticket.price.toString(),
                  style: GoogleFonts.varelaRound(
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
