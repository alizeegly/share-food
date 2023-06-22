import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharefood/controllers/profile_controller.dart';
import 'package:sharefood/models/order.dart' as order_model;
import 'package:get/get.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/orders/order_item_layout_grid.dart';

class PurchasesScreen extends StatefulWidget {
  const PurchasesScreen({super.key});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

Future<List<order_model.Order>> fetchPurchases() async {
  List<order_model.Order> orders = [];

  final controller = Get.put(ProfileController());
  UserModel user = await controller.getUserData();

  QuerySnapshot ordersSnapshot =  await FirebaseFirestore.instance.collection('orders').where("buyer", isEqualTo: FirebaseFirestore.instance.doc("sellers/${user.id}")).get();

  for (final orderSnapshot in ordersSnapshot.docs) {
    DocumentSnapshot<Map<String, dynamic>> sellerSnapshot = await orderSnapshot["seller"].get();
    UserModel seller = UserModel.fromSnapshot(sellerSnapshot);

    DocumentSnapshot<Map<String, dynamic>> buyerSnapshot = await orderSnapshot["buyer"].get();
    UserModel buyer = UserModel.fromSnapshot(buyerSnapshot);

    List<Product> products = await order_model.OrderQuery().getOrderProducts(orderSnapshot.reference.id, seller);

    order_model.Order order = order_model.Order(orderSnapshot.reference.id, seller, buyer, orderSnapshot['createdAt'], orderSnapshot['appointment'], products);

    orders.add(order);
  }

  return orders;
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  late Future<List<order_model.Order>> futurePurchasesList;

  @override
  void initState() {
    super.initState();
    setState(() {
      futurePurchasesList = fetchPurchases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(text: "Mes achats"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: FutureBuilder<List<order_model.Order>>(
            future: futurePurchasesList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return OrderItemLayoutGrid(purchases: snapshot.data!, type: 'purchase');
                }
                else {
                  return Container(margin: const EdgeInsets.all(20), child: const Text("Vous n'avez pas encore effectué d'achats. Lorsque vous aurez acheté des produits, vous retrouverez le détail de vos commandes ici."));
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