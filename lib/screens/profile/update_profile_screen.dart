import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/custom_text_field.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text("Modifier mon profil", style: Theme.of(context).textTheme.headline4),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120, height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(image: AssetImage("https://firebasestorage.googleapis.com/v0/b/share-food-d3e9b.appspot.com/o/sellers%2F1680876057524?alt=media&token=18254daa-5218-484a-a257-caab07524415"))
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                        size: 20
                      ),
                    )
                  )
                ],
              ),
              const SizedBox(height: 30),
              Form(
                child: Column(
                  children: [
                    CustomTextField(
                      // controller: nameController,
                      hintText: "Nom",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      // controller: firstnameController,
                      hintText: "Prénom",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      // controller: emailController,
                      hintText: "Email",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      // controller: passwordController,
                      hintText: "Mot de passe",
                      isObsecre: true,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      // controller: addressController,
                      hintText: "Adresse",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      // controller: zipcodeController,
                      hintText: "Code postal",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      // controller: cityController,
                      hintText: "Ville",
                      isObsecre: false,
                    ),
                    // Get my current location
                    // https://youtu.be/KLmNCzjsokM?list=PLxefhmF0pcPlKgRigYdXvrTOawobNyqUS&t=1050
                    // geolocator
                  ],
                )
              ),
              const SizedBox(height: 30),
              CustomButton(
                onPressed: (){},
                color: Theme.of(context).primaryColor,
                text: "S'inscrire",
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text.rich(
                    TextSpan(
                      text: "A rejoint le ",
                      style: TextStyle(fontSize: 12),
                      children: [
                        TextSpan(
                          text: "12 décembre 2022",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                        )
                      ]
                    )
                  ),
                  ElevatedButton(
                    onPressed: (){}, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      elevation: 0,
                      foregroundColor: Colors.red,
                      shape: const StadiumBorder(),
                      side: BorderSide.none
                    ),
                    child: const Text("Supprimer", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}