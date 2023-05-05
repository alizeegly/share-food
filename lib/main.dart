import 'package:flutter/material.dart';
import 'package:sharefood/SplashScreen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sharefood/authentication/auth_screen.dart';
import 'package:sharefood/mainScreens/home_screen.dart';
import 'package:sharefood/global/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    checkCurrentUser();
  }

  // Vérifie si l'utilisateur est connecté ou non
  void checkCurrentUser() async {
    final user = await firebaseAuth.currentUser;
    setState(() {
      _isLoading = false;
      _isAuthenticated = user != null;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Food',
      theme: ThemeData(
        primaryColor: const Color(0xFF4C9311),
      ),
      // home: const SplashScreen()
      home: _isLoading
          ? const SplashScreen()
          : _isAuthenticated
              ? const HomeScreen()
              : const AuthScreen(),
    );
  }
}