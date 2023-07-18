import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/widgets/custom_appbar.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.screen,
    required this.notifyParent,
  });
  final Product product;
  final String screen;
  final Function() notifyParent;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isInCart = false;
  List<String> _cart = [];

  void _toggleInCart() {
    CartStorage().readCartToIds().then((cart) {
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
        CartStorage().writeCart(_cart);
        widget.notifyParent();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    CartStorage().readCartToIds().then((cart) {
      setState(() {
        _cart = cart;
        _isInCart = _cart.contains(widget.product.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;

    return Scaffold(
      appBar: const CustomAppBar(text: "Informations"),
      body: ListView(
        children: [
          SizedBox(
            height: 245,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.product.pictureUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)
            )
          ),

          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              boxShadow: [BoxShadow(
                color: colors.shadow,
                spreadRadius: 0,
                blurRadius: 40,
                offset: const Offset(0, 40)
              )]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(widget.product.name, style: Theme.of(context).textTheme.headlineSmall),),
                    const SizedBox(width: 5),
                    Text("${widget.product.price.toStringAsFixed(2)}€",style: Theme.of(context).textTheme.headlineSmall),
                  ]
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Type de produit :", style: Theme.of(context).textTheme.titleSmall),
                            Text(widget.product.type, style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),

                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Date de péremption :", style: Theme.of(context).textTheme.titleSmall),
                            Text(DateFormat("dd/MM/yyyy").format(widget.product.expirationDate.toLocal()), style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Description :", style: Theme.of(context).textTheme.titleSmall),
                        Text(widget.product.description, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ]
            )
          ),

          widget.product.seller.email != user.email ?
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                boxShadow: [BoxShadow(
                  color: colors.shadow,
                  spreadRadius: 0,
                  blurRadius: 40,
                  offset: const Offset(0, 40)
                )]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Vendeur", style: Theme.of(context).textTheme.headlineSmall),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Nom du vendeur :", style: Theme.of(context).textTheme.titleSmall),
                              Text("${widget.product.seller.firstname} ${widget.product.seller.lastname}", style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ]
              )
            )
          : Container(),

          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            child: widget.screen != 'order' && widget.screen != 'myProducts' ?
            _isInCart
              ? OutlinedButton(onPressed: _toggleInCart, style: OutlinedButton.styleFrom(shape: const StadiumBorder(), side: BorderSide(width: 2, color: colors.primary), backgroundColor: colors.surface), child: Text("Retirer du panier", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.primary), textAlign: TextAlign.center))

              : ElevatedButton(onPressed: _toggleInCart, style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary),  child: Text("Ajouter au panier", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center))
            : Container()
          )
        ]
      )
    );
  }
}