import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_firebase/services/auth_service.dart';
import '../models/user_model.dart';

class AppProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isObscure = true;
  static final authService = AuthService();
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('users');

  List<UserModel> _allUsers = [];

  List<UserModel> get allUsers => _allUsers;

  Future<void> fetchAllUsers() async {
    try {
      final QuerySnapshot snapshot = await _usersCollection.get();

      _allUsers = snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Error fetching all users: $e');
    }
  }

  Future<UserModel> fetchUserData(String uid) async {
    try {
      final DocumentSnapshot snapshot = await _usersCollection.doc(uid).get();

      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      } else {
        return UserModel(
          name: 'User not found',
          image: '',
          email: '', id: '',
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
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
