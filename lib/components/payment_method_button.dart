import 'package:flutter/material.dart';

class PaymentMethodButton extends StatelessWidget {
  const PaymentMethodButton({
    required this.name,
    required this.value,
    required this.active,
    required this.onSelect,
    super.key,
  });

  final String name;
  final String value;
  final bool active;
  final Function(String type) onSelect;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.blueGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: active ? Colors.blue.shade50 : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onSelect(value),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      ),
    );
  }
}
