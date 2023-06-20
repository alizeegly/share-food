import 'package:flutter/material.dart';
import 'package:sharefood/models/cart.dart';
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
  List<Product> products = [];
  QuerySnapshot productsSnapshot;

  // If there's a product in cart, we have to filter the products to get only the products of the same seller
  List<Product> cart = await CartStorage().readCart();
  if (cart.isNotEmpty) {
    String sellerId = cart[0].seller.id!;
    productsSnapshot =  await FirebaseFirestore.instance.collection('products').where("seller", isEqualTo: FirebaseFirestore.instance.doc("sellers/$sellerId")).where("order", isEqualTo: false).get();
  } else {
    productsSnapshot = await FirebaseFirestore.instance.collection('products').where("order", isEqualTo: false).get();
  }

  for (final productSnapshot in productsSnapshot.docs) {
    DocumentSnapshot<Map<String, dynamic>> sellerSnapshot = 
      await productSnapshot["seller"].get();

    Product product = Product(
      productSnapshot.reference.id,
      productSnapshot['name'],
      productSnapshot['pictureUrl'],
      productSnapshot['type'],
      productSnapshot['price'],
      UserModel(id: sellerSnapshot.reference.id, firstname: sellerSnapshot["firstname"], lastname: sellerSnapshot["lastname"], address: sellerSnapshot["address"], email: sellerSnapshot["email"], city: sellerSnapshot["city"], zipcode: sellerSnapshot["zipcode"], status: sellerSnapshot["status"], lat: sellerSnapshot["lat"], lng: sellerSnapshot["lng"], password: sellerSnapshot["password"], avatarUrl: sellerSnapshot["avatarUrl"], createdAt: sellerSnapshot["createdAt"])
    );

    products.add(product);
  }

  return products;
}

class _CloseProductsListState extends State<CloseProductsList> {
  late Future<List<Product>> futureCloseProductsList;
  Key _refreshKey = UniqueKey();
  
  void refresh() {
    setState(() {
      futureCloseProductsList = fetchCloseProducts();
      _refreshKey = UniqueKey();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      futureCloseProductsList = fetchCloseProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      key: _refreshKey,
      appBar:
          AppBar(title: const Text("Produits proches"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: FutureBuilder<List<Product>>(
            future: futureCloseProductsList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return ProductItemLayoutGrid(products: snapshot.data!, notifyParent: refresh);
                }
                else {
                  return Container(margin: const EdgeInsets.all(20), child: const Text("Oups ! Aucun produit n'est en vente à proximité... Revenez plus tard !"));
                }
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
