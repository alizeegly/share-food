import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sharefood/controllers/profile_controller.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/form_fields/custom_number_field.dart';
import 'package:sharefood/widgets/form_fields/custom_text_field.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController priceController = TextEditingController(text: "");
  TextEditingController typeController = TextEditingController(text: "");

  void saveProduct() async {
    // Créer l'objet json
    final controller = Get.put(ProfileController());
    UserModel user = await controller.getUserData();
    var product = {
      "description": descriptionController.text.trim(),
      "expirationDate": Timestamp.now(),
      "name": nameController.text.trim(),
      "order": false,
      "pictureUrl": "https://www.bricozor.com/static/img/visuel-indisponible-650.png",
      "price": double.parse(priceController.text.trim().replaceAll(',', '.')),
      "seller": FirebaseFirestore.instance.doc("sellers/${user.id}"),
      "type": typeController.text.trim()
    };

    // Créer le produit dans Firestore
    /*DocumentReference<Map<String, dynamic>> newProductsnapshot =*/ await FirebaseFirestore.instance.collection("products").add(product);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(text: "Ajouter un produit"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      hintText: "Nom",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: typeController,
                      hintText: "Type de produit",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomTextField(
                      controller: descriptionController,
                      hintText: "Description",
                      isObsecre: false,
                    ),
                    const SizedBox(height: 17),
                    CustomNumberField(
                      controller: priceController,
                      hintText: "Prix (en euros)",
                      isObsecre: false,
                    )
                  ],
                )
              ),
              const SizedBox(height: 30),
              CustomButton(
                onPressed: () {
                  saveProduct();
                  Navigator.pop(context);
                },
                color: colors.primary,
                text: "Proposer mon produit",
              )
            ],
          ),
        ),
      ),
    );
  }
}