import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streamlt/pages/main/home_page.dart';
import 'package:streamlt/pages/authentication/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snaphot) {
          //  user is logged in
          if (snaphot.hasData){
            return const HomePage();
          }
          //  user is NOT logged in
          else{
            return const LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
