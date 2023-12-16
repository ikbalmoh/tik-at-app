import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tik_at_app/components/custom_appbar.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:tik_at_app/modules/transaction/transaction.dart';
import 'package:tik_at_app/screens/home/_cart.dart';
import 'package:tik_at_app/screens/home/_ticket_container.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TransactionController transactionController = Get.find();
  SettingController settingController = Get.find();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      settingController.initPrinter();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;
    return Obx(
      () => Scaffold(
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
          child: isMobile
              ? const TicketContainer()
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Colors.blueGrey.shade50, width: 0.5),
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
        floatingActionButton: (transactionController.tickets.isNotEmpty &&
                isMobile)
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  tooltip: 'Kerangjang',
                  backgroundColor: Colors.blue.shade100,
                  onPressed: () {
                    showModalBottomSheet(
                      showDragHandle: true,
                      enableDrag: true,
                      context: context,
                      builder: (context) => const Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
                        child: Cart(),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                    );
                  },
                  child: Badge(
                    label: Text(
                      transactionController.tickets
                          .fold(0, (sum, t) => sum + t.qty)
                          .toString(),
                    ),
                    child: const Icon(CupertinoIcons.cart),
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
