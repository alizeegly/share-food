import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sharefood/controllers/profile_controller.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/form_fields/custom_date_time_field.dart';
import 'package:sharefood/widgets/form_fields/custom_number_field.dart';
import 'package:sharefood/widgets/form_fields/custom_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

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

  String? _setDate;
  late String dateTime;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String pictureUrl = "";
  bool isLoading = false;

  Future<void> saveProduct() async {
    setState(() {
      isLoading = true;
    });

    // Uploader l'image
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("products").child(filename);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path)); // TODO VALIDATION
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    pictureUrl = await taskSnapshot.ref.getDownloadURL();

    // Créer l'objet json
    final controller = Get.put(ProfileController());
    UserModel user = await controller.getUserData();
    var product = {
      "description": descriptionController.text.trim(),
      "expirationDate": Timestamp.fromDate(DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0)),
      "name": nameController.text.trim(),
      "order": false,
      "pictureUrl": pictureUrl,
      "price": double.parse(priceController.text.trim().replaceAll(',', '.')),
      "seller": FirebaseFirestore.instance.doc("sellers/${user.id}"),
      "type": typeController.text.trim()
    };

    // Créer le produit dans Firestore
    await FirebaseFirestore.instance.collection("products").add(product);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR')
    );
    if (picked != null){
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("dd/MM/yyyy").format(selectedDate);
      });
    }
  }

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageXFile;
    });
  }

  @override
  void initState() {
    _dateController.text = "";
    super.initState();
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Ajouter une photo", textAlign: TextAlign.left),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        _getImage();
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30), // Optional: Add border radius for rounded corners
                          image: imageXFile == null ? null : DecorationImage(
                            image: FileImage(File(imageXFile!.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: imageXFile == null ? Icon(
                          Icons.add_a_photo,
                          size: MediaQuery.of(context).size.width * 0.09,
                          color: Colors.grey,
                        ) : null,
                      ),
                    ),

                    const SizedBox(height: 17),

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

                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: CustomDateTimeField(
                        controller: _dateController,
                        setState: _setDate,
                        hintText: "Date de péremption",
                        isObsecre: false,
                      )
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
                onPressed: () async {
                  await saveProduct();
                  Navigator.pop(context);
                },
                color: colors.primary,
                text: isLoading ? "Patientez..." : "Proposer mon produit",
              )
            ],
          ),
        ),
      ),
    );
  }
}
