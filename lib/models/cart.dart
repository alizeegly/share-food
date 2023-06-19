import 'dart:convert';
import 'dart:io';

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

  Future<List<String>> readCart() async {
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
