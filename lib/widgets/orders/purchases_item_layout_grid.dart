import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sharefood/models/order.dart';
import 'package:sharefood/widgets/orders/order_item.dart';

class PurchaseItemLayoutGrid extends StatefulWidget {
  const PurchaseItemLayoutGrid({
    super.key,
    required this.purchases
  });
  final List<Order> purchases;

  @override
  State<PurchaseItemLayoutGrid> createState() => _PurchaseItemLayoutGridState();
}

class _PurchaseItemLayoutGridState extends State<PurchaseItemLayoutGrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr],
        rowSizes: List.filled((widget.purchases.length/2).ceil(), auto),
        rowGap: 15,
        columnGap: 20,
        children: [
          for (var i = 0; i < widget.purchases.length; i++)
            OrderItem(order: widget.purchases[i], type: 'purchase'),
        ],
      ),
    );
  }
}