import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharefood/models/order.dart';
import 'package:sharefood/widgets/custom_appbar.dart';
import 'package:sharefood/widgets/products/order_product_item_layout_grid.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.order, required this.type});

  final Order order;
  final String type;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(text: widget.type == 'purchase' ? "Commande n° ${widget.order.id}" : "Vente n° ${widget.order.id}"),
      body: ListView(
        children: [
          OrderProductItemLayoutGrid(products: widget.order.products),

          Container(
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
                                Text("N° de commande :", style: Theme.of(context).textTheme.titleSmall),
                                Text(widget.order.id, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Date de commande :", style: Theme.of(context).textTheme.titleSmall),
                                Text(DateFormat("dd/MM/yyyy à HH'h'mm").format(widget.order.createdAt.toDate().toLocal()), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),

                          widget.type == 'purchase' ?
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Vendeur :", style: Theme.of(context).textTheme.titleSmall),
                                  Text("${widget.order.seller.firstname} ${widget.order.seller.lastname}", style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Acheteur :", style: Theme.of(context).textTheme.titleSmall),
                                  Text("${widget.order.buyer.firstname} ${widget.order.buyer.lastname}", style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Lieu de rendez-vous :", style: Theme.of(context).textTheme.titleSmall),
                                Text("${widget.order.seller.address}\n${widget.order.seller.zipcode} ${widget.order.seller.city}", style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Date et heure de rendez-vous:", style: Theme.of(context).textTheme.titleSmall),
                                Text(DateFormat("dd/MM/yyyy à HH'h'mm").format(widget.order.appointment.toDate().toLocal()), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Nombre d'articles :", style: Theme.of(context).textTheme.titleSmall),
                                Text(widget.order.products.length.toString(), style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Prix total des articles :", style: Theme.of(context).textTheme.titleSmall),
                                Text('${widget.order.products.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: Theme.of(context).textTheme.bodySmall),
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
                          )
                        ],
                      ),
                    ),

                    Text('Prix total : ${widget.order.products.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center)
                ]
              )
            )
        ]
      )
    );
  }
}
