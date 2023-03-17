import 'package:flutter/material.dart';
import 'package:sharefood/authentication/login.dart';
import 'package:sharefood/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              color: Colors.white
            ),
          ),
          toolbarHeight: 200,
          title: Image.asset(
            "assets/images/image2.png",
            width: 120
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.black87,
            tabs: [
              Tab(
                icon: Icon(Icons.lock, color: Colors.black87),
                text: "Connexion",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.black87),
                text: "Inscription",
              )
            ],
            indicatorColor:  Color(0xFF6FAE3A),
            indicatorWeight: 3,
          ),
        ),
        body: const TabBarView(
          children: [
            LoginScreen(),
            RegisterScreen()
          ]
        )
      )
    );
  }
}