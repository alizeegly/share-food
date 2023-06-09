import 'package:flutter/material.dart';
import 'package:sharefood/models/product.dart';

class CartProductItem extends StatefulWidget {
  const CartProductItem({
    super.key,
    required this.product
  });
  final Product product;

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
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
                        Text("${widget.product.seller.address}\n${widget.product.seller.zipcode} ${widget.product.seller.city}", style: Theme.of(context).textTheme.bodySmall)
                      ],
                    ),
                  ),

                  const Spacer(),

                  Container(margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0), child: Text('${widget.product.price.toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center))
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

          Positioned(
            top: -50.0,
            right: -10,
            child: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {},
              style: IconButton.styleFrom(
                foregroundColor: colors.onError,
                backgroundColor: colors.error,
                disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
                hoverColor: colors.onError.withOpacity(0.08),
                focusColor: colors.onError.withOpacity(0.12),
                highlightColor: colors.onError.withOpacity(0.12),
              )),
          ),
        ],
      )
    );
  }
}
