import 'package:flutter/material.dart';
import 'package:sharefood/data/products.dart';
import 'package:sharefood/mainScreens/home_screen.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';


class PaymentConfirmScreen extends StatefulWidget {
  const PaymentConfirmScreen({super.key});

  @override
  State<PaymentConfirmScreen> createState() => _PaymentConfirmScreenState();
}

class _PaymentConfirmScreenState extends State<PaymentConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar:
          AppBar(title: const Text("Paiement"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [BoxShadow(
            color: colors.shadow,
            spreadRadius: 0,
            blurRadius: 40,
            offset: const Offset(0, 40)
          )]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Le paiement est validé !", textAlign: TextAlign.center,),
            Container(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
              },
              style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary, padding: const EdgeInsets.symmetric(horizontal: 40)),
              child: Text("Accueil", style: TextStyle(fontSize: Theme.of(context).textTheme.labelLarge?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center)
            )
          ],
        )
        )
    );
  }
}
