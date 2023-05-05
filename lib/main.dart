import 'package:flutter/material.dart';
import 'package:sharefood/Screens/close_products.dart';
import 'package:sharefood/SplashScreen/splash_screen.dart';
import 'package:sharefood/authentication/auth_screen.dart';
import 'package:sharefood/authentication/register.dart';
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
          brightness: Brightness.light,

          primary: const Color(0xFF4C9311),
          onPrimary: const Color(0xFFF6F6F9),

          secondary: const Color(0xFF6FAE3A),
          onSecondary: const Color(0xFFFFFFFF),

          error: const Color(0xFFCC1111),
          onError: const Color(0xFFFFFFFF),

          background: const Color(0xFFF5F5F8),
          onBackground: const Color(0xFF000000),
          surface: const Color(0xFFFFFFFF),
          onSurface: const Color(0xFF000000),
          
          outline: const Color(0xFF000000),

          shadow: const Color(0x39393939)
        )
      ),
      home: const AuthScreen()
    );
  }
}