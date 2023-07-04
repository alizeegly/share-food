import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/form_fields/custom_number_field.dart';
import 'package:sharefood/widgets/form_fields/custom_text_field.dart';

import 'package:intl/number_symbols.dart' as symbols;

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
                  print(nameController.text.trim());
                  print(typeController.text.trim());
                  print(descriptionController.text.trim());
                  print(double.parse(priceController.text.trim().replaceAll(',', '.')));
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