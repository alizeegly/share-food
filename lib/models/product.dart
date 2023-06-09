import 'package:sharefood/models/user_model.dart';

class Product {
  late int id;
  late String name;
  late String pictureUrl;
  late String type;
  late double price;
  late UserModel seller;

  Product(this.id, this.name, this.pictureUrl, this.type, this.price, this.seller);
}