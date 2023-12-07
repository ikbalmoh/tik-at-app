import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/auth/auth.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(60.0);

  final AuthController auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Obx(
          () {
            if (auth.state is Authenticated) {
              Authenticated state = auth.state as Authenticated;
              return TextButton.icon(
                onPressed: () => auth.logout(),
                icon: const Icon(
                  CupertinoIcons.person,
                ),
                label: Row(
                  children: [
                    Text(state.user.name),
                    const SizedBox(
                      width: 20,
                    ),
                    const Icon(
                      CupertinoIcons.square_arrow_right,
                      size: 20,
                      color: Colors.black45,
                    )
                  ],
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
              );
            }
            return const Icon(
              CupertinoIcons.person,
            );
          },
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
