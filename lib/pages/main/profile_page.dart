// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:streamlt/pages/main/widgets/customnavbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late Future<DocumentSnapshot> userSnapshot;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    userSnapshot = getUser();
  }

  Future<DocumentSnapshot> getUser() async {
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    return userSnapshot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Profile Page',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 70,
                        ),
                        const SizedBox(height: 30),
                        FutureBuilder<DocumentSnapshot>(
                          future: userSnapshot,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return const Text('Error fetching user data');
                            } else if (!snapshot.hasData) {
                              return const Text('No data available');
                            } else {
                              final userData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              return Column(
                                children: [
                                  TextBox(
                                    title: 'username',
                                    currentUser: userData['name'],
                                    onPressed: () {
                                      _showEditPopup('name', userData['name']);
                                    },
                                  ),
                                  TextBox(
                                    title: 'email',
                                    currentUser: userData['email'],
                                    onPressed: () {
                                      _showEditPopup(
                                          'email', userData['email']);
                                    },
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomNavBar(),
    );
  }

  void _showEditPopup(String field, String currentValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedValue = currentValue;
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextField(
            onChanged: (value) {
              editedValue = value;
            },
            controller: TextEditingController(text: currentValue),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (field == 'email') {
                  // Update email in FirebaseAuth
                  await currentUser.updateEmail(editedValue);
                }

                // Update email in Firestore
                await updateUserValue(currentUser.uid, field, editedValue);

                Navigator.of(context).pop();

                // Show a success alert
                _showSuccessAlert(context);

                setState(() {
                  // Rebuild the widget tree to reflect the updated data
                  userSnapshot = getUser();
                });
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Data has been updated.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({
    Key? key,
    required this.currentUser,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String currentUser;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
              IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.settings),
                color: Colors.grey[400],
              ),
            ],
          ),
          Text(currentUser),
        ],
      ),
    );
  }
}

Future<void> updateUserValue(
    String userUid, String field, String newValue) async {
  await FirebaseFirestore.instance.collection('users').doc(userUid).update({
    field: newValue,
  });
}
