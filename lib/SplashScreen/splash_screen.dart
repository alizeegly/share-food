import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sharefood/global/global.dart';
import 'package:sharefood/authentication/auth_screen.dart';
import 'package:sharefood/mainScreens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(const Duration(seconds: 1), () async {
      if(firebaseAuth.currentUser!= null){
        Navigator.push(context, MaterialPageRoute(builder: ((context) => const HomeScreen())));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: ((context) => const AuthScreen())));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/image2.png",
                width: 100
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "Slogan de l'app",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 30,
                    fontFamily: "Source Sans Pro",
                    letterSpacing: 3
                  ),
                ),
              )
            ]
          )
        ),
      ),
    );
  }
}