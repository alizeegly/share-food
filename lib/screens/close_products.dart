import 'package:flutter/material.dart';
import 'package:sharefood/data/products.dart';
import 'package:sharefood/widgets/products/product_item_layout_grid.dart';

class CloseProductsList extends StatefulWidget {
  const CloseProductsList({super.key});

  @override
  State<CloseProductsList> createState() => _CloseProductsListState();
}

Future<List> fetchCloseProducts() async {
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

class _CloseProductsListState extends State<CloseProductsList> {
  late Future<List> futureCloseProductsList;

  @override
  void initState() {
    super.initState();
    futureCloseProductsList = fetchCloseProducts();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar:
          AppBar(title: const Text("Produits proches"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: FutureBuilder<List>(
            future: futureCloseProductsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ProductItemLayoutGrid(products: products, notifyParent:() {},);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            },
          ))
        ]
      )
    );
  }
}
