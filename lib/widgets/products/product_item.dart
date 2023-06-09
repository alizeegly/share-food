import 'package:flutter/material.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    super.key,
    required this.product,
    required this.storage,
    required this.notifyParent,
    this.screen = "closeProducts"
  });
  final Product product;
  final CartStorage storage;
  final Function() notifyParent;
  final String screen;

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isInCart = false;
  List<int> _cart = [];

  void _toggleInCart() {
    widget.storage.readCart().then((cart) {
      setState(() {
        _cart = cart;
        _isInCart = _cart.contains(widget.product.id);

        if (_isInCart) {
          // S'il était dans le panier, alors il ne l'est plus :
          _cart.remove(widget.product.id);
        } else {
          // S'il n'était pas dans le panier, il le devient :
          _cart.add(widget.product.id);
        }
        _isInCart = _cart.contains(widget.product.id);
        widget.storage.writeCart(_cart);
        widget.notifyParent();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    widget.storage.readCart().then((cart) {
      setState(() {
        _cart = cart;
        _isInCart = _cart.contains(widget.product.id);
      });
    });
  }
  
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

                  Container(margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0), child: Text('${widget.product.price.toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center)),

                  _isInCart || widget.screen=="cart"
                    ? OutlinedButton(onPressed: _toggleInCart, style: OutlinedButton.styleFrom(shape: const StadiumBorder(), side: BorderSide(width: 2, color: colors.primary)), child: Text("Retirer du panier", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.primary), textAlign: TextAlign.center))

                    : ElevatedButton(onPressed: _toggleInCart, style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary),  child: Text("Ajouter au panier", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center))
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
