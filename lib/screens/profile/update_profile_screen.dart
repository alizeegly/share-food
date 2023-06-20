import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharefood/controllers/profile_controller.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';


class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Get.back();
          }, 
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Modifier mon profil"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasData){
                  UserModel user = snapshot.data as UserModel;

                  TextEditingController nameController = TextEditingController(text: user.lastname);
                  TextEditingController firstnameController = TextEditingController(text: user.firstname);
                  TextEditingController emailController = TextEditingController(text: user.email);
                  TextEditingController passwordController = TextEditingController(text: user.password);
                  TextEditingController addressController = TextEditingController(text: user.address);
                  TextEditingController zipcodeController = TextEditingController(text: user.zipcode);
                  TextEditingController cityController = TextEditingController(text: user.city);

                  return Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120, height: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(user.avatarUrl, fit: BoxFit.cover)
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
                              controller: nameController,
                              // intitialValue: userData.lastname,
                              hintText: "Nom",
                              isObsecre: false,
                            ),
                            const SizedBox(height: 17),
                            CustomTextField(
                              // intitialValue: userData.firstname,
                              controller: firstnameController,
                              hintText: "Prénom",
                              isObsecre: false,
                            ),
                            const SizedBox(height: 17),
                            CustomTextField(
                              // intitialValue: userData.email,
                              controller: emailController,
                              hintText: "Email",
                              isObsecre: false,
                            ),
                            const SizedBox(height: 17),
                            CustomTextField(
                              // intitialValue: userData.password,
                              controller: passwordController,
                              hintText: "Mot de passe",
                              isObsecre: true,
                            ),
                            const SizedBox(height: 17),
                            CustomTextField(
                              // intitialValue: userData.address,
                              controller: addressController,
                              hintText: "Adresse",
                              isObsecre: false,
                            ),
                            const SizedBox(height: 17),
                            CustomTextField(
                              // intitialValue: userData.zipcode,
                              controller: zipcodeController,
                              hintText: "Code postal",
                              isObsecre: false,
                            ),
                            const SizedBox(height: 17),
                            CustomTextField(
                              // intitialValue: userData.city,
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
                      const SizedBox(height: 30),
                      CustomButton(
                        onPressed: () async {
                          final userData = UserModel(
                            id: user.id, 
                            firstname: firstnameController.text.trim(), 
                            lastname: nameController.text.trim(), 
                            address: addressController.text.trim(), 
                            email: emailController.text.trim(), 
                            city: cityController.text.trim(), 
                            zipcode: zipcodeController.text.trim(), 
                            status: "approuved", 
                            lat: user.lat, 
                            lng: user.lng, 
                            password: passwordController.text.trim(), 
                            avatarUrl: user.avatarUrl,
                            createdAt: user.createdAt
                          );
                          await controller.updateRecord(userData);
                        },
                        color: Theme.of(context).primaryColor,
                        text: "Modifier",
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "A rejoint le ",
                              style: const TextStyle(fontSize: 12),
                              children: [
                                TextSpan(
                                  text: DateFormat('dd MMMM yyyy', 'fr').format(user.createdAt.toDate()),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
                                )
                              ]
                            )
                          ),
                          ElevatedButton(
                            onPressed: () async {}, 
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
                  );
                } else if(snapshot.hasError){
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return const Center(
                    child: Text("Something went wrong"),
                  );
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          ),
        ),
      ),
    );
  }
}