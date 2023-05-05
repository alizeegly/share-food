import 'package:flutter/material.dart';
import 'package:sharefood/Screens/close_products.dart';
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
        // Colors
        primaryColor: const Color(0xFF4C9311),
        primaryColorLight: const Color(0xFF6FAE3A),
        
        // Fonts
        fontFamily: 'Montserrat Medium',

        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 34),
          headlineSmall: TextStyle(fontSize: 22),

          titleLarge: TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 16),
          titleMedium: TextStyle(fontFamily: 'Montserrat SemiBold', color: Color(0xFF6FAE3A), fontSize: 14),
          titleSmall: TextStyle(fontFamily: 'Montserrat SemiBold', color: Color(0xFF6FAE3A), fontSize: 12),

          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),

          labelLarge: TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 16),
          labelMedium: TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 14),
          labelSmall: TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 12)
        ),
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