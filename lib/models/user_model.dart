import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
final String id;
  final String name;
  final  String email;
   String? image;


  UserModel({required this.id, required this.name, required this.email,  this.image});

  }



