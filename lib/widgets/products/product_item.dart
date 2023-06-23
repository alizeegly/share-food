import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sharefood/models/cart.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/screens/products/product_details.dart';

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
  List<String> _cart = [];

  void _toggleInCart() {
    widget.storage.readCartToIds().then((cart) {
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

  void deleteProduct() async {
    await FirebaseFirestore.instance.doc("products/${widget.product.id}").delete();
    widget.notifyParent();
  }

  void refresh(){
    widget.storage.readCartToIds().then((cart) {
      setState(() {
        _cart = cart;
        _isInCart = _cart.contains(widget.product.id);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    widget.storage.readCartToIds().then((cart) {
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
          Ink(
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
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: widget.product, screen: widget.screen, notifyParent: refresh)));
              },
              customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 80, 10, 10),
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
            
                      widget.screen == 'closeProducts' ?
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text("Localisation :", style: Theme.of(context).textTheme.titleSmall),
                              Text("${widget.product.seller.address}\n${widget.product.seller.zipcode} ${widget.product.seller.city}", style: Theme.of(context).textTheme.bodySmall)
                            ],
                          ),
                        )
                      : Container(),
            
                      const Spacer(),
            
                      Container(margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0), child: Text('${widget.product.price.toStringAsFixed(2)}€', style: const TextStyle(fontFamily: 'Montserrat SemiBold', fontSize: 20), textAlign: TextAlign.center)),
            
                      widget.screen != 'order'  && widget.screen != 'myProducts' ?
                        
                        _isInCart ?
                          OutlinedButton(onPressed: _toggleInCart, style: OutlinedButton.styleFrom(shape: const StadiumBorder(), side: BorderSide(width: 2, color: colors.primary)), child: Text("Retirer du panier", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.primary), textAlign: TextAlign.center))
            
                          : ElevatedButton(onPressed: _toggleInCart, style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.primary),  child: Text("Ajouter au panier", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center))
                      
                      : widget.screen == 'myProducts' ? 
                        
                        widget.product.sold ?
                          OutlinedButton(onPressed: null, style: OutlinedButton.styleFrom(shape: const StadiumBorder(), side: BorderSide(width: 2, color: colors.primary)), child: Text("Vendu", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.primary), textAlign: TextAlign.center))
            
                          : ElevatedButton(onPressed: deleteProduct, style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: colors.error),  child: Text("Supprimer", style: TextStyle(fontSize: Theme.of(context).textTheme.labelSmall?.fontSize, color: colors.onPrimary), textAlign: TextAlign.center))

                      : Container()
                    ]
                  )
                )
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
