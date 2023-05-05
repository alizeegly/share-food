import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharefood/global/global.dart';
import 'package:sharefood/mainScreens/home_screen.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/custom_text_field.dart';
import 'package:sharefood/widgets/error_dialog.dart';
import 'package:sharefood/widgets/loading_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipcodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String sellerImageUrl = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if(imageXFile == null){
      showDialog(
        context: context, 
        builder: (c){
          return const ErrorDialog(message: "Veuillez choisir une image de profile.");
        }
      );
    } else {
      if(passwordController.text == confirmPasswordController.text){
        if(nameController.text.isNotEmpty && firstnameController.text.isNotEmpty && emailController.text.isNotEmpty && addressController.text.isNotEmpty && zipcodeController.text.isNotEmpty && cityController.text.isNotEmpty){
          // upload image
          showDialog(
            context: context, 
            builder: ((c) {
              return const LoadingDialog(
                message: "Création du compte..."
              );
            })
          );

          String filename = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("sellers").child(filename);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
          await taskSnapshot.ref.getDownloadURL().then((url) => {
            sellerImageUrl = url,
            print("here"),
            // Save into firestore
            authenticateSellerAndSignUp()
          });
        } else {
          showDialog(
            context: context, 
            builder: (c) {
              return const ErrorDialog(message: "Veuillez remplir tous les champs nécessaire à l'inscription.");
            }
          );
        }
      } else {
        showDialog(
          context: context, 
          builder: (c){
            return const ErrorDialog(message: "Les mots de passe ne correspondent pas.");
          }
        );
      }
    }
  }

  void authenticateSellerAndSignUp() async {
    User? currentUser;
    
    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim()
    ).then((auth) {
      currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (c){
          return ErrorDialog(message: error.toString());
        }
      );
    });

    if(currentUser != null) {
      saveDataToFirestore(currentUser!).then((value){
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellersUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerFirstName": firstnameController.text.trim(),
      "sellerAvatarUrl": sellerImageUrl,
      "address": addressController.text.trim(),
      "zipcode": zipcodeController.text.trim(),
      "city": cityController.text.trim(),
      "status": "approved",
      "earnings": 0.0,
      "lat": 48.866667,
      "lng": 2.333333
    });

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("firstName", firstnameController.text.trim());
    await sharedPreferences!.setString("email", emailController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFFF2F2F2),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: MediaQuery.of(context).size.width * 0.1,
                backgroundImage: imageXFile == null ? null : FileImage(File(imageXFile!.path)),
                child: imageXFile == null ? Icon(
                  Icons.add_a_photo,
                  size: MediaQuery.of(context).size.width * 0.09,
                  color: Colors.grey,
                ) : null,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      hintText: "Nom",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: firstnameController,
                      hintText: "Prénom",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: emailController,
                      hintText: "Email",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: passwordController,
                      hintText: "Mot de passe",
                      isObsecre: true,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirmation du mot de passe",
                      isObsecre: true,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: addressController,
                      hintText: "Adresse",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: zipcodeController,
                      hintText: "Code postal",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: cityController,
                      hintText: "Ville",
                      isObsecre: false,
                    ),
                    // Get my current location
                    // https://youtu.be/KLmNCzjsokM?list=PLxefhmF0pcPlKgRigYdXvrTOawobNyqUS&t=1050
                    // geolocator
                  ],
                )
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              onPressed: formValidation,
              color: Theme.of(context).primaryColor,
              text: "S'inscrire",
            ),
            const SizedBox(height: 50),
          ],
        )
      ),
    );
  }
}