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
  final Timestamp createdAt;

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
    required this.avatarUrl,
    required this.createdAt
  });

  toJson() {
    return {
      "id": id,
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "address": address,
      "city": city,
      "zipcode": zipcode,
      "password": password,
      "avatarUrl": avatarUrl,
      "status": status,
      "lat": lat,
      "lng": lng,
      "createdAt": createdAt
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      firstname: data["firstname"],
      lastname: data["lastname"],
      address: data["address"], 
      email: data["email"],
      city: data["city"],
      zipcode: data["zipcode"],
      status: data["status"],
      lat: data["lat"],
      lng: data["lng"],
      password: data["password"],
      avatarUrl: data["avatarUrl"],
      createdAt: data["createdAt"]
    );
  }
}