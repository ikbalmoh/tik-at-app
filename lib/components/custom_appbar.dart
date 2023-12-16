import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/auth/auth.dart';
import 'package:tik_at_app/modules/setting/setting.dart';

enum PopupMenus { logout, server, printer }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(60.0);

  final AuthController auth = Get.find();
  final SettingController setting = Get.find();

  void onSelectMenu(PopupMenus menu) {
    switch (menu) {
      case PopupMenus.logout:
        auth.logout();
        break;
      case PopupMenus.printer:
        setting.openPrinterSetting();
        break;
      case PopupMenus.server:
        setting.openApiSetting();
        break;
      default:
    }
  }

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
        Badge(
          smallSize: 10,
          child: PopupMenuButton<PopupMenus>(
            onSelected: onSelectMenu,
            itemBuilder: (context) => [
              const PopupMenuItem<PopupMenus>(
                value: PopupMenus.printer,
                child: Row(
                  children: [
                    Icon(CupertinoIcons.printer),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Pengaturan Printer'),
                  ],
                ),
              ),
              const PopupMenuItem<PopupMenus>(
                value: PopupMenus.server,
                child: Row(
                  children: [
                    Icon(CupertinoIcons.globe),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Pengaturan Server'),
                  ],
                ),
              ),
              const PopupMenuItem<PopupMenus>(
                value: PopupMenus.logout,
                child: Row(
                  children: [
                    Icon(CupertinoIcons.square_arrow_right),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Keluar'),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
