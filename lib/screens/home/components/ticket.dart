import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ticket extends StatelessWidget {
  final String ticketName;
  final Color color;

  const Ticket({super.key, required this.ticketName, required this.color});

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
              ticketName,
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
