import 'package:flutter/material.dart';
import 'package:sharefood/data/products.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/widgets/products/cart_product_item_layout_grid.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key, required this.storage});

  final CartStorage storage;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
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

class _PaymentScreenState extends State<PaymentScreen> {
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
          AppBar(title: const Text("Paiement"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
      body: FutureBuilder<List<Product>>(
        future: futureCartScreen,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
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
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      Text("Vous paierez directement le vendeur par espèces", style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center,),

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
                                  Text("Localisation :", style: Theme.of(context).textTheme.titleSmall),
                                  Text(snapshot.data![0].seller.address.street, style: Theme.of(context).textTheme.bodySmall),
                                  Text("${snapshot.data![0].seller.address.zipcode} - ${snapshot.data![0].seller.address.city}", style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Date et heure de rendez-vous :", style: Theme.of(context).textTheme.titleSmall),
                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Total à régler :", style: Theme.of(context).textTheme.titleSmall),
                                  Text('${snapshot.data!.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(storage: CartStorage())));
                        },
                        style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary, padding: const EdgeInsets.symmetric(horizontal: 40)),
                        child: Text("Valider", style: TextStyle(fontSize: Theme.of(context).textTheme.labelLarge?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center)
                      )
                  ]
                )
              );
            }
            else {
              return const Text("Le panier est vide");
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}
