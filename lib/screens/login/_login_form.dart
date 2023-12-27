import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/auth/auth.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:get_storage/get_storage.dart';

enum PopupMenus { server, printer }

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  AuthController authController = Get.find();
  SettingController settingController = Get.find();

  GetStorage box = GetStorage();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool passwordHidden = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 3)).then((_) {
        if (settingController.api.isEmpty) {
          settingController.openApiSetting();
        }
      });
    });
    super.initState();
  }

  void _onLogin(BuildContext context) async {
    try {
      FocusScope.of(context).unfocus();

      final username = _usernameController.text;
      final password = _passwordController.text;

      final empty = username.isEmpty || password.isEmpty;

      if (empty) {
        Get.snackbar('Login Gagal', 'Isi username dan password!');
        return;
      }

      authController.login(username, password);
    } catch (e) {
      _passwordController.clear();
    }
  }

  void onSelectMenu(PopupMenus menu) {
    switch (menu) {
      case PopupMenus.printer:
        settingController.openPrinterSetting();
        break;
      case PopupMenus.server:
        settingController.openApiSetting();
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    bool isMobile = ResponsiveBreakpoints.of(context).isMobile;

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              blurRadius: isMobile ? 0 : 5,
              color: Colors.black12,
            )
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/ticket.png',
                height: 50,
              ),
              const SizedBox(height: 5),
              Text(
                'eTiket Situ Bagendit',
                style:
                    textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              Text(
                'Selamat Datang',
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'Silahkan gunakan akun operator untuk login',
                style:
                    textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'username',
                ),
                controller: _usernameController,
                readOnly: settingController.api.isEmpty,
                scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        passwordHidden = !passwordHidden;
                      });
                    },
                    icon: Icon(passwordHidden
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye),
                  ),
                ),
                controller: _passwordController,
                obscureText: passwordHidden,
                readOnly: settingController.api.isEmpty,
                scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: authController.state is AuthLoading ||
                        settingController.api.isEmpty
                    ? null
                    : () => _onLogin(context),
                child: authController.state is AuthLoading
                    ? const SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.grey,
                        ),
                      )
                    : const Text('LOGIN'),
              ),
              const SizedBox(
                height: 30,
              ),
              Badge(
                smallSize: 10,
                isLabelVisible: settingController.api.isEmpty ||
                    settingController.printer is! PrinterConnected,
                child: PopupMenuButton(
                  tooltip: 'Pengaturan',
                  onSelected: onSelectMenu,
                  itemBuilder: (context) => [
                    PopupMenuItem<PopupMenus>(
                      value: PopupMenus.printer,
                      child: Row(
                        children: [
                          Badge(
                            backgroundColor:
                                settingController.printer is PrinterConnected
                                    ? Colors.green
                                    : Colors.red,
                            smallSize: 10,
                            child: const Icon(CupertinoIcons.printer),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text('Pengaturan Printer'),
                        ],
                      ),
                    ),
                    PopupMenuItem<PopupMenus>(
                      value: PopupMenus.server,
                      child: Row(
                        children: [
                          Badge(
                            smallSize: 10,
                            backgroundColor: settingController.api.isNotEmpty
                                ? Colors.green
                                : Colors.red,
                            child: const Icon(CupertinoIcons.globe),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Text('Pengaturan Server'),
                        ],
                      ),
                    )
                  ],
                  icon: const Icon(
                    CupertinoIcons.gear,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Dinas Parisiwisata dan Kebudayaan Garut',
                textAlign: TextAlign.center,
              ),
              const Text(
                '© 2023',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "v${box.read('version') ?? '0'}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
