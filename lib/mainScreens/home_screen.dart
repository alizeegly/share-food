import 'package:flutter/material.dart';
import 'package:sharefood/authentication/auth_screen.dart';
import 'package:sharefood/global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          firebaseAuth.signOut().then((value) => {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: ((context) => const AuthScreen())
              )
            )
          });
        }, 
        child: const Text("Logout")
      ),
    );
  }
}