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
import 'package:dropdown_button2/dropdown_button2.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController descriptionController = TextEditingController(text: "");
  TextEditingController priceController = TextEditingController(text: "");

  final List<String> types = [
    'Fruit',
    'Légume',
    'Féculent',
    'Conserve',
    'Produit laitier',
    'Eau et boisson',
    'Dessert',
    'Plat préparé'
  ];
  String? selectedType;

  String? _setDate;
  late String dateTime;
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  String pictureUrl = "";
  bool isLoading = false;

  Future<void> saveProduct() async {
    setState(() {
      isLoading = true;
    });

    // Validation
    // Valeurs nulles
    if (
      descriptionController.text.trim() == "" ||
      selectedDate == null ||
      nameController.text.trim() == "" ||
      imageXFile == null ||
      priceController.text.trim() == "" ||
      selectedType == null
    ) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Erreur", "Tous les champs sont obligatoires", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white
      );
      throw Exception("Tous les champs sont obligatoires");
    }

    // Prix valide
    if (
      double.tryParse(priceController.text.trim().replaceAll(',', '.')) == null ||
      double.parse(priceController.text.trim().replaceAll(',', '.')) <= 0
    ) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Erreur", "Le prix n'est pas valide", 
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white
      );
      throw Exception("Le prix n'est pas valide");
    }

    // Uploader l'image
    String filename = DateTime.now().millisecondsSinceEpoch.toString();
    fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("products").child(filename);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
    pictureUrl = await taskSnapshot.ref.getDownloadURL();

    // Créer l'objet json
    final controller = Get.put(ProfileController());
    UserModel user = await controller.getUserData();
    var product = {
      "description": descriptionController.text.trim(),
      "expirationDate": Timestamp.fromDate(DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, 0, 0)),
      "name": nameController.text.trim(),
      "order": false,
      "pictureUrl": pictureUrl,
      "price": double.parse(priceController.text.trim().replaceAll(',', '.')),
      "seller": FirebaseFirestore.instance.doc("sellers/${user.id}"),
      "type": selectedType
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
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
      locale: const Locale('fr', 'FR')
    );
    if (picked != null){
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("dd/MM/yyyy").format(selectedDate!);
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

                    DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                          'Type de produit',
                          style: TextStyle(
                            fontFamily: 'Montserrat Medium',
                            fontSize: 15,
                            color: Colors.grey.shade800
                          ),
                        ),
                        items: types
                            .map((String item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat Medium',
                                      fontSize: 15,
                                      color: Colors.black
                                    ),
                                  ),
                                ))
                            .toList(),
                        value: selectedType,
                        onChanged: (String? value) {
                          setState(() {
                            selectedType = value;
                          });
                        },
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.all(5),
                          height: 50,
                          width: 140,
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.black, style: BorderStyle.solid)),
                          )
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40
                        ),
                        dropdownStyleData: const DropdownStyleData(
                          maxHeight: 170,
                        ),
                      )
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
