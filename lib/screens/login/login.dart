import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tik_at_app/screens/login/_login_form.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
            ),
          ),
          ResponsiveBreakpoints.of(context).isMobile
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: LoginForm(),
                    ),
                  ],
                )
              : const Positioned(
                  right: 15,
                  top: 15,
                  bottom: 15,
                  child: SizedBox(
                    width: 350,
                    child: LoginForm(),
                  ),
                ),
        ],
      ),
    );
  }
}
