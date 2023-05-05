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
          toolbarHeight: 150,
          title: Image.asset(
            "assets/images/image2.png",
            width: 120
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: Colors.black87,
            tabs: const [
              Tab(
                icon: Icon(Icons.lock, color: Colors.black87),
                text: "Connexion",
              ),
              Tab(
                icon: Icon(Icons.person, color: Colors.black87),
                text: "Inscription",
              )
            ],
            indicatorColor: Theme.of(context).colorScheme.secondary,
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