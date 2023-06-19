import 'package:flutter/material.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/products/product_item_layout_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloseProductsList extends StatefulWidget {
  const CloseProductsList({super.key});

  @override
  State<CloseProductsList> createState() => _CloseProductsListState();
}

Future<List<Product>> fetchCloseProducts() async {
  QuerySnapshot productsSnapshot = 
      await FirebaseFirestore.instance.collection('products').get();

  return productsSnapshot.docs.map(
    (doc) => Product(
      doc.reference.id,
      doc['name'],
      doc['pictureUrl'],
      doc['type'],
      doc['price'],
      UserModel(id: "1", lastname: "Bukal", firstname: "Johana", address: "1 place Saint Blaise", zipcode: "78955", city: "Carrières sous Poissy", email: "test@mail.com", lat: 1, lng: 2, password: '', status: '', avatarUrl: '', createdAt: Timestamp.fromDate(DateTime.now()))
      )
  ).toList();
}

class _CloseProductsListState extends State<CloseProductsList> {
  late Future<List<Product>> futureCloseProductsList;

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
          SliverToBoxAdapter(child: FutureBuilder<List<Product>>(
            future: futureCloseProductsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ProductItemLayoutGrid(products: snapshot.data!, notifyParent:() {},);
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
