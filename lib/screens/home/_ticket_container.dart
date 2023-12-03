import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        return Card(
          color: Colors.amber.shade200,
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
        );
      }).toList(),
    );
  }
}
