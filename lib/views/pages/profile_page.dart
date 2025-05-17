import 'package:cost_control/views/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(alignment: Alignment.center, child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size(200, 70)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAll(() => HomePage());
            },
            child: Text('Logout', style: TextStyle(fontSize: 26),),
          ),
        ],
      ),
      ),
    );
  }
}

