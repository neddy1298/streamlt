import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streamlt/components/my_button.dart';
import 'package:streamlt/components/my_textfield.dart';
import 'package:streamlt/components/square_tile.dart';
import 'package:streamlt/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterPage> {
  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // sign user in method
  void signUserUp() async{

    // show loading circle
    showDialog(
        context: context,
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // try creating the user
    try{
      // check if password is confirmed
      if(passwordController.text == confirmpasswordController.text){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
      //  show error message, passwords
        Navigator.pop(context);
        showErrorMessage("Password don't match!");

      }
      // pop the loading circle
    } on FirebaseAuthException catch (e){

      // pop the loading circle
      Navigator.pop(context);

      // Wrong email or password
      showErrorMessage(e.code);
    }
  }

  // error message to user
  void showErrorMessage(String message){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
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
              const SizedBox(height: 25,),

              //  logo
              const Icon(
                Icons.lock,
                size: 50,
              ),

              const SizedBox(height: 25,),

              //  Let's create an account for you!
              Text(
                'Let\'s create an account for you!',
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

              // confirm password textfield
              MyTextField(
                controller: confirmpasswordController,
                hintText: 'Confirm Password',
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
                text: 'Sign Up',
                onTap: signUserUp,
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
                children: [
                  //  google button
                  SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google-icon.png'
                  ),

                  const SizedBox(width: 25,),

                  // apple button
                  SquareTile(
                      onTap: () {},
                      imagePath: 'lib/images/apple-icon.png'
                  ),
                ],
              ),
              const SizedBox(height: 50,),

              //  not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: Colors.grey[700]),),
                  const SizedBox(width: 4,),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Login Now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
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
