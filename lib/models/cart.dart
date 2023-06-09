import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sharefood/models/product.dart';
import 'package:sharefood/models/seller.dart';

class Cart {
  late List<Product> products;
  late Seller seller;

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

  Future<List<int>> readCart() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return json.decode(contents).cast<int>();
    } catch (e) {
      // If encountering an error, return 0
      return [];
    }
  }

  Future<File> writeCart(List<int> cart) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$cart');
  }
}
