import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streamlt/components/my_button.dart';
import 'package:streamlt/components/my_textfield.dart';
import 'package:streamlt/components/square_tile.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async{

    // show loading circle
    showDialog(
        context: context,
        builder: (context){
        return Center(
          child: CircularProgressIndicator(),
        );
    });

    // try sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e){

      // pop the loading circle
      Navigator.pop(context);

      // Wrong email or password
      if(e.code == 'user-not-found' || e.code == 'wrong-password'){
        wrongEmailPasswordMessage();
      }
    }
  }
  
  void wrongEmailPasswordMessage(){
    showDialog(
        context: context,
        builder: (context){
          return const AlertDialog(
            title: Text('User not found, check again your email and password'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50,),

              //  logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50,),

              //  welcome back, you've been missed!
              Text(
                'Welcome back you\'ev been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 25,),

              //  Email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),

              const SizedBox(height: 10,),

              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 10,),

              //  forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25,),

              // sign in button
              MyButton(
                onTap: signUserIn,
              ),
              const SizedBox(height: 25,),
              //  or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child:Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),

                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50,),

              //  google + apple sign in buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  //  google button
                  SquareTile(imagePath: 'lib/images/google-icon.png'),

                  SizedBox(width: 25,),

                  // apple button
                  SquareTile(imagePath: 'lib/images/apple-icon.png'),
                ],
              ),
              const SizedBox(height: 50,),

              //  not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(
                        color: Colors.grey[700]),),
                  const SizedBox(width: 4,),
                  const Text(
                    'Register Now',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
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
