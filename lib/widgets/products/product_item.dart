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
                  Text(widget.product.name, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Type de produit :", style: Theme.of(context).textTheme.titleSmall),
                        Text(widget.product.type, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Localisation :", style: Theme.of(context).textTheme.titleSmall),
                        Text("${widget.product.seller.address.street}\n${widget.product.seller.address.zipcode} ${widget.product.seller.address.city}", style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ),
                  ),

                  const Spacer(),

                  Container(margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0), child: Text('${widget.product.price.toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center)),

                  ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Theme.of(context).primaryColor),  child: Text("Ajouter au panier", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: Colors.white), textAlign: TextAlign.center))
                ]
              ),
          ),

          Positioned(
            top: -50.0,
            height: 120,
            width: 120,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(
                  color: Color(0x12000000),
                  spreadRadius: 0,
                  blurRadius: 40,
                  offset: Offset(0, 40)
                )]
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(120),
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.network(widget.product.pictureUrl)
                  ) 
              ),
            ),
          ),
        ],
      )
    );
  }
}
