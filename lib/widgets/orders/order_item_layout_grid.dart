import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sharefood/models/order.dart';
import 'package:sharefood/widgets/orders/order_item.dart';

class OrderItemLayoutGrid extends StatefulWidget {
  const OrderItemLayoutGrid({
    super.key,
    required this.purchases,
    required this.type
  });
  final List<Order> purchases;
  final String type;

  @override
  State<OrderItemLayoutGrid> createState() => _OrderItemLayoutGridState();
}

class _OrderItemLayoutGridState extends State<OrderItemLayoutGrid> {
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
            OrderItem(order: widget.purchases[i], type: widget.type),
        ],
      ),
    );
  }
}