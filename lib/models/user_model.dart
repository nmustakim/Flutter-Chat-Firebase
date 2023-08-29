import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
final String id;
  final String name;
  final  String email;
   String? image;


  UserModel({required this.id, required this.name, required this.email,  this.image});


factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    id: map['id'],
    name: map['name'],
    image: map['image'],
    email: map['email'],
  );
}
  }



