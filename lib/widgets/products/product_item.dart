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
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              boxShadow: [BoxShadow(
                color: Color(0x39393939),
                spreadRadius: 0,
                blurRadius: 60,
                offset: Offset(0, 30)
              )],
              borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child:
              Column(
                children: [
                  Text(widget.product.name),
                  const Text("Type de produit :"),
                  Text(widget.product.type),
                  const Text("Localisation :"),
                  Text("${widget.product.seller.address.street}\n${widget.product.seller.address.zipcode} ${widget.product.seller.address.city}"),
                  Text('${widget.product.price.toStringAsFixed(2)}€'),
                  ElevatedButton(onPressed: () {}, child: const Text("Ajouter au panier"))
                ]
              ),
          ),

          Positioned(
            top: -50.0,
            height: 120,
            width: 120,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(120),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.network(widget.product.pictureUrl)
                ) 
            ),
          ),
        ],
      )
    );
  }
}
