import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tik_at_app/models/transaction.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.item,
    required this.onDelete,
  });

  final TransactionItem item;
  final Function onDelete;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.all(0),
      shape: const Border(
        bottom: BorderSide(
          width: 0.5,
          color: Colors.black12,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item.qty.toString(),
              style: textTheme.bodyLarge,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(child: Text(item.name)),
            Text(
              item.total.toString(),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            IconButton(
              onPressed: () => onDelete(),
              icon: const Icon(
                CupertinoIcons.xmark_circle,
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
