import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/screens/homepage.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;
  Future<void> signIn(String email, password, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      var authCredential = credential.user;
      if (authCredential!.uid.isNotEmpty) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("User not found"),
            action: SnackBarAction(
                label: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Wrong password!"),
            action: SnackBarAction(
                label: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        );
      }
    }
  }
  Future<void> signUp(String email, password,name,username, context) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      var authCredential = credential.user;
      if (authCredential!.uid.isNotEmpty) {
        _fireStore.collection('users').doc(authCredential.uid).set({

          'name':name,
          'username':username,
          'image':'https://firebasestorage.googleapis.com/v0/b/flutter-chat-firebase-9e7b0.appspot.com/o/icon.svg?alt=media&token=9583a084-d695-420f-b247-f353ea9b619e',
          'email': email,
          'password': password,

        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Home()));
      }
    } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:  Text(e.toString()),
            action: SnackBarAction(
                label: 'Cancel',
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        );

    }
  }
}
