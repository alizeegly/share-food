import 'package:flutter/material.dart';
import 'package:sharefood/data/products.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import '../widgets/products/cart_product_item_layout_grid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.storage});

  final CartStorage storage;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

Future<List<Product>> fetchCart(List<int> productIds) async {
  // var headers = {'X-MAL-CLIENT-ID': dotenv.env['X-MAL-CLIENT-ID']!};
  // var request = http.Request('GET',
  //     Uri.parse('https://api.myanimelist.net/v2/anime/season/2023/winter'));

  // request.headers.addAll(headers);

  // http.StreamedResponse streamedResponse = await request.send();
  // var response = await http.Response.fromStream(streamedResponse);

  // if (response.statusCode == 200) {
  //   var jsonResponse = jsonDecode(response.body)['data'];
  //   return jsonResponse;
  // } else {
  // throw Exception(response.reasonPhrase);
  // }

  // En attendant d'avoir l'API
  return products.where((product) => productIds.contains(product.id)).toList();
}

class _CartScreenState extends State<CartScreen> {
  List<int> _productIds = [];
  Future<List<Product>>? futureCartScreen;

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
                    return CartProductItemLayoutGrid(products: snapshot.data!);
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
                    onPressed: () {},
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
