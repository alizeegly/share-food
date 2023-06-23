import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/widgets/products/product_item.dart';

class MyProductItemLayoutGrid extends StatefulWidget {
  const MyProductItemLayoutGrid({
    super.key,
    required this.products
  });
  final List<Product> products;

  @override
  State<MyProductItemLayoutGrid> createState() => _MyProductItemLayoutGridState();
}

class _MyProductItemLayoutGridState extends State<MyProductItemLayoutGrid> {
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
            ProductItem(product: widget.products[i], storage: CartStorage(), screen: "myProducts", notifyParent: (){},),
        ],
      ),
    );
  }
}