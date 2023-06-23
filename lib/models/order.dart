import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';

class Order {
  late String id;
  late UserModel seller;
  late UserModel buyer;
  late Timestamp createdAt;
  late Timestamp appointment;
  late List<Product> products;

  Order(this.id, this.seller, this.buyer, this.createdAt, this.appointment, this.products);
}

class OrderQuery {
  Future<List<Product>> getOrderProducts(String orderId, UserModel seller) async {
    List<Product> products = [];

    QuerySnapshot productsSnapshot =  await FirebaseFirestore.instance.collection('products').where("order", isEqualTo: FirebaseFirestore.instance.doc("orders/$orderId")).get();

    for (final productSnapshot in productsSnapshot.docs) {
      Product product = Product(
        productSnapshot.reference.id,
        productSnapshot['name'],
        productSnapshot['pictureUrl'],
        productSnapshot['type'],
        productSnapshot['price'],
        productSnapshot['expirationDate'].toDate(),
        productSnapshot['description'],
        seller
      );

      products.add(product);
    }

    return products;
  }
}
