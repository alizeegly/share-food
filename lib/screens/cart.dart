import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/screens/payment.dart';
import 'package:sharefood/widgets/products/cart_product_item_layout_grid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.storage});

  final CartStorage storage;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

Future<List<Product>> fetchCart(List<String> productIds) async {
  List<Product> products = [];

  for(final productId in productIds) {
    DocumentSnapshot<Map<String, dynamic>> productSnapshot = 
      await FirebaseFirestore.instance.collection('products').doc(productId).get();

    DocumentSnapshot<Map<String, dynamic>> sellerSnapshot = 
      await productSnapshot["seller"].get();

    Product product = Product(
      productSnapshot.reference.id,
      productSnapshot['name'],
      productSnapshot['pictureUrl'],
      productSnapshot['type'],
      productSnapshot['price'],
      UserModel(firstname: sellerSnapshot["firstname"], lastname: sellerSnapshot["lastname"], address: sellerSnapshot["address"], email: sellerSnapshot["email"], city: sellerSnapshot["city"], zipcode: sellerSnapshot["zipcode"], status: sellerSnapshot["status"], lat: sellerSnapshot["lat"], lng: sellerSnapshot["lng"], password: sellerSnapshot["password"], avatarUrl: sellerSnapshot["avatarUrl"], createdAt: sellerSnapshot["createdAt"])
    );

    products.add(product);
  }

  return products;
}

class _CartScreenState extends State<CartScreen> {
  List<String> _productIds = [];
  Future<List<Product>>? futureCartScreen;

  void refresh() {
    widget.storage.readCart().then((value) {
      setState(() {
        _productIds = value;
        futureCartScreen = fetchCart(_productIds);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    widget.storage.readCart().then((value) {
      setState(() {
        _productIds = value;
        futureCartScreen = fetchCart(_productIds);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar:
          AppBar(title: const Text("Panier"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FutureBuilder<List<Product>>(
              future: futureCartScreen,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return CartProductItemLayoutGrid(products: snapshot.data!, notifyParent: refresh);
                  }
                  else {
                    return Container(margin: const EdgeInsets.all(20), child: const Text("Ajoutez un produit à votre panier, et il s'affichera ici."));
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              },
            )
          ),

          SliverToBoxAdapter(child: FutureBuilder<List>(
              future: futureCartScreen,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
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
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                          Text("Récapitulatif de commande", style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text("Nombre d'articles :", style: Theme.of(context).textTheme.titleSmall),
                                      Text(snapshot.data!.length.toString(), style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text("Prix total :", style: Theme.of(context).textTheme.titleSmall),
                                      Text('${snapshot.data!.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text("Frais :", style: Theme.of(context).textTheme.titleSmall),
                                      Text("0€", style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Text('Prix total : ${snapshot.data!.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center)
                      ]
                    )
                  );
                }
                return Container();
              },
            )
          ),

          SliverToBoxAdapter(child: FutureBuilder<List>(
            future: futureCartScreen,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(storage: CartStorage())));
                    },
                    style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary),
                    child: Text("Passer commande", style: TextStyle(fontSize: Theme.of(context).textTheme.labelLarge?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center)
                  )
                );
              }

              return Container();
            }
          ))
        ]
      )
    );
  }
}
