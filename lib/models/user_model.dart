import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sharefood/models/adress.dart';

class UserModel {
  final String? id;
  final String firstname;
  final String lastname;
  final String email;
  final String address;
  final String city;
  final String zipcode;
  final String status;
  final double lat;
  final double lng;
  final String password;
  String avatarUrl;

  UserModel({
    this.id, 
    required this.firstname, 
    required this.lastname, 
    required this.address, 
    required this.email, 
    required this.city, 
    required this.zipcode, 
    required this.status, 
    required this.lat, 
    required this.lng, 
    required this.password,
    required this.avatarUrl
  });

  toJson() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "address": address,
      "city": city,
      "zipcode": zipcode,
      "password": password,
      "avatarUrl": avatarUrl
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      firstname: data["sellerFirstName"],
      lastname: data["sellerLastName"],
      address: data["address"], 
      email: data["sellerEmail"],
      city: data["city"],
      zipcode: data["zipcode"],
      status: data["status"],
      lat: data["lat"],
      lng: data["lng"],
      password: data["password"],
      avatarUrl: data["sellerAvatarUrl"]
    );
  }
}