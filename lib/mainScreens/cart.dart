import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page panier'),
      ),
      body: Center(
        child: Text(
          'Contenu de la page panier',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}