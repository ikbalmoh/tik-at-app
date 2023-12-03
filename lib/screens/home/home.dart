import 'package:flutter/material.dart';
import 'package:tik_at_app/components/custom_appbar.dart';
import 'package:tik_at_app/screens/home/_cart.dart';
import 'package:tik_at_app/screens/home/_ticket_container.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: CustomAppBar(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    right:
                        BorderSide(color: Colors.blueGrey.shade50, width: 0.5),
                  ),
                ),
                child: const TicketContainer(),
              ),
            ),
            const SizedBox(
              width: 350,
              child: Cart(),
            )
          ],
        ),
      ),
    );
  }
}
