import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharefood/global/global.dart';
import 'package:sharefood/mainScreens/home_screen.dart';
import 'package:sharefood/widgets/custom_button.dart';
import 'package:sharefood/widgets/custom_text_field.dart';
import 'package:sharefood/widgets/error_dialog.dart';
import 'package:sharefood/widgets/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? _errorMessage = "";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _signInWithEmailAndPassword() async {
    User? currentUser;

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Vérifiez si les champs sont valides
      if (!_formkey.currentState!.validate()) {
        return;
      }

      // Connexion à Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).then((auth) {
        currentUser = auth.user;
      });

      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentUser!.uid)
        .get();
      
      if (snapshot.exists) {
        // Les données de l'utilisateur existent dans Firestore
        final data = snapshot.data();
        
        Map<String, dynamic> data2 = snapshot.data() as Map<String, dynamic>;

        // Faites quelque chose avec les données de l'utilisateur ici
        if (data != null) {
          sharedPreferences = await SharedPreferences.getInstance();
          // await sharedPreferences!.setString("uid", data2["sellersUID"]);
          await sharedPreferences!.setString("name", data2["lastname:"]);
          await sharedPreferences!.setString("firstName", data2["firstname"]);
          await sharedPreferences!.setString("email", data2["email"]);
          await sharedPreferences!.setString("photoUrl", data2["avatarUrl"]);
        }
        // etc.
      } else {
        // Les données de l'utilisateur n'existent pas dans Firestore
        print('Aucune donnée d\'utilisateur trouvée dans Firestore');
      }

      // Connexion réussie
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      
    } catch (e) {
      // Gestion des erreurs de connexion
      setState(() {
        _errorMessage = 'La connexion a échoué. Vérifiez vos identifiants et réessayez.';
      });

      showDialog(
        context: context, 
        builder: (c){
          return ErrorDialog(message: _errorMessage);
        }
      );
    }
  }
  
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
                    onPressed: _signInWithEmailAndPassword,
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