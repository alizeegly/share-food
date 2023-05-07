import 'package:flutter/material.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
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
                  const SizedBox(height: 30),
                  CustomButton(
                    onPressed: () => print('My Button tap'),
                    color: Theme.of(context).colorScheme.primary,
                    text: "Se connecter",
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          ),
        ],
      )
    );
  }
}