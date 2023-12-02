import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usermameController = TextEditingController();
  final passwordController = TextEditingController();

  var passwordHidden = true;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
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
            'eTiket Bagendit',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: 75),
          Text(
            'Selamat Datang',
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Silahkan gunakan akun operator untuk masuk',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'username',
            ),
            controller: usermameController,
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
            controller: passwordController,
            obscureText: passwordHidden,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
            },
            child: const Text('Masuk'),
          ),
        ],
      ),
    );
  }
}
