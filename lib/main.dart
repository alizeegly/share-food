import 'package:flutter/material.dart';
import 'package:sharefood/Screens/close_products.dart';
import 'package:sharefood/SplashScreen/splash_screen.dart';
import 'package:sharefood/screens/cart.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Food',
      theme: ThemeData(
        useMaterial3: true,

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

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4C9311),
          primary: const Color(0xFF4C9311),
          onPrimary: const Color(0xffffffff),
          error: const Color(0xffcc1111),
          onError: const Color(0xffffffff)
        )
      ),
      home: const CartScreen()
    );
  }
}