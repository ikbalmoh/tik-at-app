import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:gartix/shared/components/custom_appbar.dart';
import 'package:gartix/modules/setting/controller/setting.dart';
import 'package:gartix/modules/transaction/controller/transaction.dart';
import './_cart.dart';
import './_ticket_container.dart';
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

  void openCartBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (context) => DraggableScrollableSheet(
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
          child: Cart(scrollController: controller,),
        ),
        minChildSize: 0.5,
        maxChildSize: 0.8,
        initialChildSize: 0.6,
        expand: false,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET);
    return Obx(
      () {
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
          floatingActionButton:
              (transactionController.state is TransactionInProgress &&
                      (transactionController.state as TransactionInProgress)
                          .tickets
                          .isNotEmpty &&
                      isMobile)
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FloatingActionButton.extended(
                        tooltip: 'Kerangjang',
                        label: const Text('Tiket Dipilih'),
                        onPressed: openCartBottomSheet,
                        icon: Badge(
                          label: Text(
                            transactionController.state is TransactionInProgress
                                ? (transactionController.state
                                        as TransactionInProgress)
                                    .tickets
                                    .fold(0, (sum, t) => sum + t.qty)
                                    .toString()
                                : '0',
                          ),
                          child: const Icon(CupertinoIcons.tickets),
                        ),
                      ),
                    )
                  : Container(),
        );
      },
    );
  }
}
