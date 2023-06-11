import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharefood/controllers/auth_controller.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final controller = Get.put(AuthController());

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String sellerImageUrl = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    
    return SingleChildScrollView(
      child: Container(
        color: colors.background,
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
                      controller: controller.nameController,
                      hintText: "Nom",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: controller.firstnameController,
                      hintText: "Prénom",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: controller.emailController,
                      hintText: "Email",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: controller.passwordController,
                      hintText: "Mot de passe",
                      isObsecre: true,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: controller.confirmPasswordController,
                      hintText: "Confirmation du mot de passe",
                      isObsecre: true,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: controller.addressController,
                      hintText: "Adresse",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: controller.zipcodeController,
                      hintText: "Code postal",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: controller.cityController,
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
              // onPressed: formValidation,
              onPressed: () {
                if(_formkey.currentState!.validate()){
                  final user = UserModel(
                    address: controller.emailController.text.trim(), 
                    city: controller.cityController.text.trim(), 
                    email: controller.emailController.text.trim(), 
                    firstname: controller.firstnameController.text.trim(), 
                    lastname: controller.nameController.text.trim(), 
                    lat: 0, 
                    lng: 0,
                    password: controller.passwordController.text.trim(), 
                    status: 'approuved', 
                    zipcode: controller.zipcodeController.text.trim(), 
                    avatarUrl: '',
                    createdAt: Timestamp.fromDate(DateTime.now())
                  );
                  AuthController.instance.registerUser(user,imageXFile);
                }
              },
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