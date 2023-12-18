import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/setting/setting.dart';
import 'package:validators/validators.dart';

class ApiConfig extends StatefulWidget {
  const ApiConfig({super.key});

  @override
  State<ApiConfig> createState() => _ApiConfigState();
}

class _ApiConfigState extends State<ApiConfig> {
  SettingController controller = Get.find();

  final _formKey = GlobalKey<FormState>();

  TextEditingController urlController = TextEditingController();
  String error = 'Masukkan alamat server';

  @override
  void initState() {
    urlController.text = controller.api;
    if (controller.api.isNotEmpty) {
      setState(() {
        error = '';
      });
    }
    super.initState();
  }

  void onChangeUrl(String value) {
    String msg = '';
    if (value.isEmpty) {
      msg = 'Masukkan alamat server';
    } else if (!isURL(value)) {
      msg = 'Alamat tidak valid';
    }
    setState(() {
      error = msg;
    });
  }

  void submit() async {
    try {
      if (_formKey.currentState!.validate()) {
        await controller.setApiUrl(urlController.text);
        Get.back(closeOverlays: true);
        Get.showSnackbar(
          const GetSnackBar(
            title: 'Terhubung ke Server',
            message: 'Alamat server disimpan',
            duration: Duration(seconds: 3),
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP,
          ),
        );
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
      _formKey.currentState!.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Obx(
      () => Container(
        width: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  'Pengaturan Server',
                  style: textTheme.headlineSmall,
                ),
              ),
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Server URL',
                  hintText: 'http://192.168.1.1',
                ),
                autofocus: true,
                onChanged: onChangeUrl,
                validator: (_) {
                  if (error.isNotEmpty) {
                    return error;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  controller.api.isNotEmpty
                      ? TextButton(
                          onPressed: () => Get.back(),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey,
                          ),
                          child: const Text('Batal'),
                        )
                      : const Spacer(),
                  ElevatedButton.icon(
                    onPressed: controller.loading ? null : () => submit(),
                    icon: controller.loading
                        ? const SizedBox(
                            height: 10,
                            width: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Simpan'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
