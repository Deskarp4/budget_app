import 'package:cost_control/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async{
    debugPrint('UserRepository CREATE USER DOC  →  uid=${user.id}');
    await _db.collection('Users').doc(user.id).set(user.toJson()).whenComplete(
            () =>
            Get.snackbar("Success!", "Your account has been created",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green))
        .catchError((error, stackTrace) {
      Get.snackbar(
          "Error!", "Something went wrong", snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }
}