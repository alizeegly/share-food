import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/user_model.dart';

class Cart {
  late List<Product> products;
  late UserModel seller;

  Cart(this.products, this.seller);
}

class CartStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/Cart.txt');
  }

  Future<List<Product>> readCart() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      final decodedContents = json.decode(contents);

      // Ensure that the decoded contents is a list of strings
      if (decodedContents is List<dynamic>) {
        final productIds = decodedContents.cast<String>();

        List<Product> products = [];

        for(final productId in productIds) {
          DocumentSnapshot<Map<String, dynamic>> productSnapshot = 
            await FirebaseFirestore.instance.collection('products').doc(productId).get();

          DocumentSnapshot<Map<String, dynamic>> sellerSnapshot = 
            await productSnapshot["seller"].get();

          Product product = Product(
            productSnapshot.reference.id,
            productSnapshot['name'],
            productSnapshot['pictureUrl'],
            productSnapshot['type'],
            productSnapshot['price'],
            UserModel(firstname: sellerSnapshot["firstname"], lastname: sellerSnapshot["lastname"], address: sellerSnapshot["address"], email: sellerSnapshot["email"], city: sellerSnapshot["city"], zipcode: sellerSnapshot["zipcode"], status: sellerSnapshot["status"], lat: sellerSnapshot["lat"], lng: sellerSnapshot["lng"], password: sellerSnapshot["password"], avatarUrl: sellerSnapshot["avatarUrl"], createdAt: sellerSnapshot["createdAt"])
          );

          products.add(product);
        }

        return products;

      } else {
        // Handle the case when the decoded contents is not a list of strings
        throw Exception('Invalid data format');
      }
    } catch (e) {
      print((e.toString()));
      writeCart([]);
      return [];
    }
  }

  Future<List<String>> readCartToIds() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      final decodedContents = json.decode(contents);

      // Ensure that the decoded contents is a list of strings
      if (decodedContents is List<dynamic>) {
        final list = decodedContents.cast<String>();
        return list;
      } else {
        // Handle the case when the decoded contents is not a list of strings
        throw Exception('Invalid data format');
      }
    } catch (e) {
      print((e.toString()));
      writeCart([]);
      return [];
    }
  }

  Future<File> writeCart(List<String> cart) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(json.encode(cart));
  }
}
