import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: Center(
            child: Text('cart'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: () {},
                icon: const Icon(CupertinoIcons.trash),
                label: const Text('RESET'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.green.shade50,
                    padding: const EdgeInsets.all(15),
                  ),
                  onPressed: () {},
                  child: const Text('BAYAR'),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
