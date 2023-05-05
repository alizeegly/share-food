import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sharefood/models/product.dart';

import 'cart_product_item.dart';

class CartProductItemLayoutGrid extends StatelessWidget {
  const CartProductItemLayoutGrid({
    super.key,
    required this.products,
  });
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: LayoutGrid(
        columnSizes: [1.fr, 1.fr],
        rowSizes: List.filled((products.length/2).ceil(), auto),
        rowGap: 15,
        columnGap: 20,
        children: [
          for (var i = 0; i < products.length; i++)
            CartProductItem(product: products[i]),
        ],
      ),
    );
  }
}