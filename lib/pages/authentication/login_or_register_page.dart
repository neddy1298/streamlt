import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamlt/pages/authentication/login_page.dart';
import 'package:streamlt/pages/authentication/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toogle between login and register page
  void togglePages(){
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
