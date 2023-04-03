import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/custom_text_field.dart';
import 'package:sharefood/widgets/error_dialog.dart';

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
          return ErrorDialog(message: "Veuillez choisir une image de profile.");
        }
      );
    }
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
              onPressed: () => formValidation(),
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