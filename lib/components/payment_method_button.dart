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
        side: BorderSide(
          color: active ? Colors.blue.shade700 : Colors.blueGrey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      color: active ? Colors.blue.shade50 : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onSelect(value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
          child: Row(
            children: [
              Icon(
                active
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off,
                color: active ? Colors.blue.shade700 : Colors.black54,
              ),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
