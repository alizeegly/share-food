import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:flutter/material.dart';

class UserRepository extends GetxController {

  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;


  // Create user
  createUser(UserModel user) async {
    await _db.collection("sellers").add(user.toJson()).whenComplete(
      () => Get.snackbar("Success", "Votre compte a bien été créé", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green
      )
    )
    .catchError((error, stackTrace) {
        Get.snackbar("Error", "Something went wrong. Try again.", 
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red
        );
        print(error.toString());
      });
  }

  // Fetch user details
  Future<UserModel> getUserDetails(String email) async {
    final snapshot = await _db.collection("sellers").where("email", isEqualTo: email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  // Update user details
  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("sellers").doc(user.id).update(user.toJson());
  }
}