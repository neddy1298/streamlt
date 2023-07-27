import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:streamlt/pages/main/customnavbar.dart';
import 'package:streamlt/pages/main/widgets/newmovie_widget.dart';
import 'package:streamlt/pages/main/widgets/upcoming_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     IconButton(
      //         onPressed: signUserOut,
      //         icon: const Icon(Icons.logout),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 10
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello ${user.email!}",
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          "what to watch?",
                          style: TextStyle(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: const Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: 60,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF292B37),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      color: Colors.white54,
                      size: 30,
                    ),
                    Container(
                      width: 300,
                      margin: const EdgeInsets.only(left: 5),
                      child: TextFormField(
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.white)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              const UpComingWidget(),
              const SizedBox(height: 30,),
              const NewMovieWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }
}
