import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharefood/models/order.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.order,
    this.type = "order"
  });
  final Order order;
  final String type;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          decoration: BoxDecoration(
            color: colors.surface,
            boxShadow: [BoxShadow(
              color: colors.shadow,
              spreadRadius: 0,
              blurRadius: 60,
              offset: const Offset(0, 30)
            )],
            borderRadius: const BorderRadius.all(Radius.circular(30))
          ),
          child:
            Column(
              children: [
                Text(widget.type == 'purchase' ? "Commande\nn° ${widget.order.id}" : "Vente\nn° ${widget.order.id}", style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 14)),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Date :", style: Theme.of(context).textTheme.titleSmall),
                      Text(DateFormat('dd/MM/yyyy').format(widget.order.createdAt.toDate().toLocal()), style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Nombre d'articles :", style: Theme.of(context).textTheme.titleSmall),
                      Text(widget.order.products.length.toString(), style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                ),

                widget.type != 'purchase' ?
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Rendez-vous :", style: Theme.of(context).textTheme.titleSmall),
                        Text(DateFormat("dd/MM/yyyy à HH'h'mm").format(widget.order.appointment.toDate().toLocal()), style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  )
                : Container(),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text("Prix total :", style: TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 14), textAlign: TextAlign.center),
                      Text('${widget.order.products.fold(0.0, (previousValue, element) => previousValue + element.price).toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center)
                    ],
                  )
                ),
              ]
            ),
        ),

        widget.type == 'awaiting-sale' ?
          Positioned(
            top: -10,
            right: -10,
            height: 35,
            width: 35,
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.orange.shade300,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                iconSize: 20,
                icon: const Icon(Icons.hourglass_empty_rounded),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          )
        : Container()
      ],
    );
  }
}
