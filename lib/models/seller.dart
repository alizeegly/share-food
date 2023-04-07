import 'package:sharefood/models/adress.dart';

class Seller {
  late int id;
  late String firstname;
  late String lastname;
  late Address address;

  Seller(this.id, this.firstname, this.lastname, this.address);
}