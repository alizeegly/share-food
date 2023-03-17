import 'package:flutter/material.dart';
import 'package:sharefood/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {

  TextEditingController anyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2F2F2),
      child: Center(
        child: CustomTextField(
          controller: anyController,
          data: Icons.phone,
          hintText: "Nom",
          isObsecre: false,
        ),
      ),
    );
  }
}