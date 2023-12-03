import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomAppBar extends AppBar {
  @override
  CustomAppBar({super.key})
      : super(
          backgroundColor: Colors.white,
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage('assets/images/ticket.png'),
                height: 30,
              ),
              SizedBox(width: 10),
              Text('eTiket Situ Bagendit'),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.list_bullet_below_rectangle,
              ),
              label: const Text('Loket'),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.person),
            ),
          ],
        );
}
