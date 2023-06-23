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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes ventes"),
          centerTitle: false,
          backgroundColor: colors.background,
          foregroundColor: colors.onBackground,
          bottom: const TabBar(
            tabs: [
              Tab(text: "En attente"),
              Tab(text: "Passées")
            ]
          ),
        ),

        body: TabBarView(
          children: [
            // 1) Commandes en attente
            ListView(
              children: [
                FutureBuilder<List<order_model.Order>>(
                  future: futureSalesList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty && snapshot.data!.where((order) => order.appointment.toDate().toLocal().compareTo(DateTime.now()) > 0).toList().isNotEmpty) {
                        return OrderItemLayoutGrid(purchases: snapshot.data!.where((order) => order.appointment.toDate().toLocal().compareTo(DateTime.now()) > 0).toList(), type: 'awaitingSale',);
                      }
                      else {
                        return Container(margin: const EdgeInsets.all(20), child: const Text("Vous n'avez aucune vente en attente."));
                      }
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    // By default, show a loading spinner.
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              ]
            ),
            
            // 2) Commandes passées
            ListView(
              children: [
                FutureBuilder<List<order_model.Order>>(
                  future: futureSalesList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isNotEmpty  && snapshot.data!.where((order) => order.appointment.toDate().toLocal().compareTo(DateTime.now()) < 0).toList().isNotEmpty) {
                        return OrderItemLayoutGrid(purchases: snapshot.data!.where((order) => order.appointment.toDate().toLocal().compareTo(DateTime.now()) < 0).toList(), type: 'passedSale',);
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
                )
              ]
            ),
          ],
        )
      )
    );
  }
}