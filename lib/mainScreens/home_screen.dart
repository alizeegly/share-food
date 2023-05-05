import 'package:flutter/material.dart';
import 'package:sharefood/authentication/auth_screen.dart';
import 'package:sharefood/global/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder: ((context) => const AuthScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenue !'),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Se déconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}