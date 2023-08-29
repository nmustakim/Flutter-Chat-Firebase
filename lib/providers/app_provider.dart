import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_firebase/services/auth_service.dart';
import '../models/user_model.dart';

class AppProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isObscure = true;
  static final authService = AuthService();
  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  Future<void> fetchUsers() async {
    try {
      final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      final QuerySnapshot snapshot = await usersCollection.get();

      _users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
          id: doc.id,
          email: data['email'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
    }
  }


  Future<void> signIn(String email, password, context) async {
    try {
      setLoading(true);
      await authService.signIn(email, password, context);
    } catch (e) {
      print('Sign-in error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> signUp(String email, password,name,username, context) async {
    try {
      setLoading(true);
      await authService.signUp(email, password,name,username, context);
    } catch (e) {
      print('Sign-up error: $e');
    } finally {
      setLoading(false);
    }
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }
}
