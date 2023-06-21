import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharefood/controllers/profile_controller.dart';
import 'package:sharefood/models/order.dart' as order_model;
import 'package:get/get.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';
import 'package:sharefood/widgets/orders/order_item_layout_grid.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

Future<List<order_model.Order>> fetchSales() async {
  List<order_model.Order> orders = [];

  final controller = Get.put(ProfileController());
  UserModel user = await controller.getUserData();

  QuerySnapshot ordersSnapshot =  await FirebaseFirestore.instance.collection('orders').where("seller", isEqualTo: FirebaseFirestore.instance.doc("sellers/${user.id}")).get();

  for (final orderSnapshot in ordersSnapshot.docs) {
    List<Product> products = await order_model.OrderQuery().getOrderProducts(orderSnapshot.reference.id);

    DocumentSnapshot<Map<String, dynamic>> sellerSnapshot = await orderSnapshot["seller"].get();
    UserModel seller = UserModel.fromSnapshot(sellerSnapshot);

    DocumentSnapshot<Map<String, dynamic>> buyerSnapshot = await orderSnapshot["buyer"].get();
    UserModel buyer = UserModel.fromSnapshot(buyerSnapshot);

    order_model.Order order = order_model.Order(orderSnapshot.reference.id, seller, buyer, orderSnapshot['createdAt'], orderSnapshot['appointment'], products);

    orders.add(order);
  }

  return orders;
}

class _SalesScreenState extends State<SalesScreen> {
  late Future<List<order_model.Order>> futureSalesList;

  @override
  void initState() {
    super.initState();
    setState(() {
      futureSalesList = fetchSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar:
          AppBar(title: const Text("Mes ventes"), centerTitle: false, backgroundColor: colors.secondary, foregroundColor: colors.onSecondary),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: FutureBuilder<List<order_model.Order>>(
            future: futureSalesList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return OrderItemLayoutGrid(purchases: snapshot.data!, type: 'sale',);
                }
                else {
                  return Container(margin: const EdgeInsets.all(20), child: const Text("Vous n'avez pas encore fait de ventes. Lorsque vous aurez vendu des produits, vous retrouverez le détail des commandes ici."));
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