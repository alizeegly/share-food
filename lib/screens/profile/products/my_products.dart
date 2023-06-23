import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sharefood/controllers/profile_controller.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/products/my_product_item_layout_grid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProductsList extends StatefulWidget {
  const MyProductsList({super.key});

  @override
  State<MyProductsList> createState() => _MyProductsListState();
}

Future<List<Product>> fetchMyProducts() async {
  List<Product> products = [];
  QuerySnapshot productsSnapshot;

  final controller = Get.put(ProfileController());
  UserModel user = await controller.getUserData();
  
  productsSnapshot = await FirebaseFirestore.instance.collection('products').where("seller", isEqualTo: FirebaseFirestore.instance.doc("sellers/${user.id}")).get();

  for (final productSnapshot in productsSnapshot.docs) {
    Product product = Product(
      productSnapshot.reference.id,
      productSnapshot['name'],
      productSnapshot['pictureUrl'],
      productSnapshot['type'],
      productSnapshot['price'],
      productSnapshot['expirationDate'].toDate(),
      productSnapshot['description'],
      user,
      productSnapshot['order'] != false ? true : false
    );

    products.add(product);
  }

  return products;
}

class _MyProductsListState extends State<MyProductsList> {
  late Future<List<Product>> futureMyProductsList;
  Key _refreshKey = UniqueKey();
  
  void refresh() {
    setState(() {
      futureMyProductsList = fetchMyProducts();
      _refreshKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      futureMyProductsList = fetchMyProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      key: _refreshKey,
      appBar: const CustomAppBar(text: "Mes produits"),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: ElevatedButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(storage: CartStorage())));
              },
              style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary),
              child: Text("Ajouter un produit", style: TextStyle(fontSize: Theme.of(context).textTheme.labelLarge?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center)
            )
          ),

          FutureBuilder<List<Product>>(
            future: futureMyProductsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return MyProductItemLayoutGrid(products: snapshot.data!, notifyParent: refresh,);
                }
                else {
                  return Container(margin: const EdgeInsets.all(20), child: const Text("Vous n'avez aucun produit... Ajoutez votre premier produit à l'aide du bouton ci-dessus !"));
                }
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const Center(child: CircularProgressIndicator());
            },
          )
        ]
      )
    );
  }
}
