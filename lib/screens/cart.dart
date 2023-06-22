import 'package:flutter/material.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/screens/checkout_funnel/payment.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/products/cart_product_item_layout_grid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.storage});

  final CartStorage storage;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Future<List<Product>>? futureCartScreen;

  void refresh() {
    setState(() {
      futureCartScreen = widget.storage.readCart();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      futureCartScreen = widget.storage.readCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(text: "Panier"),
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
                                      Text("Vendeur :", style: Theme.of(context).textTheme.titleSmall),
                                      Text("${snapshot.data![0].seller.firstname} ${snapshot.data![0].seller.lastname}", style: Theme.of(context).textTheme.bodySmall),
                                    ],
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Text("Lieu de rendez-vous :", style: Theme.of(context).textTheme.titleSmall),
                                      Text("${snapshot.data![0].seller.address}\n${snapshot.data![0].seller.zipcode} ${snapshot.data![0].seller.city}", style: Theme.of(context).textTheme.bodySmall)
                                    ],
                                  ),
                                ),

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
                                      Text("Prix total des articles:", style: Theme.of(context).textTheme.titleSmall),
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
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
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
