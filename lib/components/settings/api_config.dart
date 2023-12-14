import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/setting/setting.dart';

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
    super.initState();
  }

  void submit() async {
    try {
      if (_formKey.currentState!.validate()) {
        await controller.setApiUrl(urlController.text);
        Get.back();
        Get.snackbar('Terhubung ke Server', 'Konfigurasi Disimpan');
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

    return Container(
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
              onChanged: (value) => setState(() {
                error = value.isEmpty ? 'Masukkan alamat server' : '';
              }),
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
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Simpan'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
