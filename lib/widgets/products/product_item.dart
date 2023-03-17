import 'package:flutter/material.dart';
import 'package:sharefood/models/product.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product
  });
  final Product product;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Image.network(widget.product.pictureUrl),
          Text(widget.product.name),
          const Text("Type de produit :"),
          Text(widget.product.type),
          const Text("Localisation :"),
          Text("${widget.product.seller.address.street}\n${widget.product.seller.address.zipcode} ${widget.product.seller.address.city}"),
      ],)
    );
  }
}
