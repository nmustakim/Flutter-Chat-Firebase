import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_firebase/services/auth_service.dart';
import '../models/user_model.dart';

class AppProvider extends ChangeNotifier {
  bool isLoading = false;
  bool fetchingUser = false;
  bool isObscure = true;
  static final authService = AuthService();
  List<UserModel> _users = [];
  UserModel? _currentUser;

  List<UserModel> get users => _users;
  UserModel? get currentUser => _currentUser;

  Future<void> fetchUsers() async {
    try {
      fetchingUser = true;
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('users');
      final QuerySnapshot snapshot = await usersCollection.get();

      _users = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
          id: doc.id,
          username:data['username'],
          email: data['email'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();



    } catch (e) {
      print('Error fetching users: $e');
    }
    finally{
     fetchingUser = false;
     notifyListeners();
    }

  }


  Future<void> fetchCurrentUser() async {
    try {

      final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      final DocumentSnapshot snapshot = await usersCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      _currentUser = UserModel(
        id: snapshot.id,
        username: data['username'],
        email: data['email'],
        name: data['name'],
        image: data['image'],
      );
      notifyListeners();
    } catch (e) {
      print('Error fetching current user: $e');
    }
    finally{

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
