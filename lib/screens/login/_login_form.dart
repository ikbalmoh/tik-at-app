import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tik_at_app/modules/auth/auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  AuthController authController = Get.find();
  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool passwordHidden = true;

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

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black12,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ticket.png',
              height: 50,
            ),
            const SizedBox(height: 5),
            Text(
              'eTiket Situ Bagendit',
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: authController.state is AuthLoading
                  ? null
                  : () => _onLogin(context),
              child: Text(
                  authController.state is AuthLoading ? 'LOGIN ...' : 'LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}
