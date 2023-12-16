import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tik_at_app/screens/login/_login_form.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurple,
      body: ResponsiveBreakpoints.of(context).isMobile
          ? const Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [LoginForm()],
              ),
            )
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
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
