import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/widgets/products/product_item.dart';

class CartProductItemLayoutGrid extends StatefulWidget {
  const CartProductItemLayoutGrid({
    super.key,
    required this.products,
    required this.notifyParent
  });
  final List<Product> products;
  final Function() notifyParent;

  @override
  State<CartProductItemLayoutGrid> createState() => _CartProductItemLayoutGridState();
}

class _CartProductItemLayoutGridState extends State<CartProductItemLayoutGrid> {
  void refresh() {
    widget.notifyParent();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr],
        rowSizes: List.filled((widget.products.length/2).ceil(), auto),
        rowGap: 15,
        columnGap: 20,
        children: [
          for (var i = 0; i < widget.products.length; i++)
            ProductItem(product: widget.products[i], storage: CartStorage(), notifyParent: refresh, screen: "cart",),
        ],
      ),
    );
  }
}