import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/repository/authentication_repository/auth_repository.dart';
import 'package:sharefood/repository/user_repository/user_repository.dart';
import 'package:sharefood/widgets/error_dialog.dart';
import 'package:sharefood/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  TextEditingController nameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  String sellerImageUrl = "";
  final userRepo = Get.put(UserRepository());


  void registerUser(UserModel user, XFile? imageXFile) async {
    if(imageXFile == null){
      print("Veuillez choisir une image de profile.");
    } else {
      if(passwordController.text == confirmPasswordController.text){
        if(nameController.text.isNotEmpty && firstnameController.text.isNotEmpty && emailController.text.isNotEmpty && addressController.text.isNotEmpty && zipcodeController.text.isNotEmpty && cityController.text.isNotEmpty){
          String filename = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("sellers").child(filename);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
          await taskSnapshot.ref.getDownloadURL().then((url) => {
            sellerImageUrl = url,
            // Save into firestore
            AuthRepository.instance.createUserWithEmailAndPassword(user.email, user.password),
            user.avatarUrl = url,
            AuthController.instance.createUser(user)
          });
        } else {
          print("Veuillez remplir tous les champs nécessaire à l'inscription.");
        }
      } else {
        print("Les mots de passe ne correspondent pas.");
      }
    }
  }

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }
}