import 'package:sharefood/models/user_model.dart';

class Product {
  late String id;
  late String name;
  late String pictureUrl;
  late String type;
  late num price;
  late DateTime expirationDate;
  late String description;
  late UserModel seller;
  late bool sold;

  Product(this.id, this.name, this.pictureUrl, this.type, this.price, this.expirationDate, this.description, this.seller, this.sold);
}