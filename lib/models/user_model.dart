import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final String image;

  UserModel({required this.username,
      required this.id,
      required this.name,
      required this.email,
      required this.image});
}
