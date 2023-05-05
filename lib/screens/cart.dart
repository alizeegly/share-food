import 'package:flutter/material.dart';
import 'package:sharefood/data/products.dart';
import '../widgets/products/cart_product_item_layout_grid.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

Future<List> fetchCart() async {
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
  return products;
}

class _CartScreenState extends State<CartScreen> {
  late Future<List> futureCartScreen;

  @override
  void initState() {
    super.initState();
    futureCartScreen = fetchCart();
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
            child: FutureBuilder<List>(
              future: futureCartScreen,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return CartProductItemLayoutGrid(products: products);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              },
            )
          ),

          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
            child: FutureBuilder<List>(
              future: futureCartScreen,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
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
                                    Text(products.length.toString(), style: Theme.of(context).textTheme.bodySmall),
                                  ],
                                ),
                              ),

                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Prix total :", style: Theme.of(context).textTheme.titleSmall),
                                    Text('${products.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: Theme.of(context).textTheme.bodySmall),
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

                        Text('Prix total : ${products.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center)
                    ]
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(child: CircularProgressIndicator());
              },
            ),
          )),

          SliverToBoxAdapter(child: Container(margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Theme.of(context).primaryColor),  child: Text("Passer commande", style: TextStyle(fontSize: Theme.of(context).textTheme.labelLarge?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center))))
        ]
      )
    );
  }
}
