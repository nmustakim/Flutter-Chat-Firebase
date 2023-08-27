import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'chat_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    update();
  }
void update() {
    final fireStore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;
    final data = {
      'name': auth.currentUser!.displayName ?? auth.currentUser!.email,
      'date_time': DateTime.now(),
      'email': auth.currentUser!.email,
    };
    try {
      fireStore.collection('users').doc(auth.currentUser!.uid).set(data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Chatbase'),
        actions: [
          InkWell(
              onTap: () async {
                await FirebaseUIAuth.signOut();
                debugPrint('Signed out !');
              },
              child: Icon(Icons.logout))
        ],
      ),
      drawer: Drawer(
          backgroundColor: Colors.indigo.shade400,
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 20),
                  child: Theme(
                    data: ThemeData.dark(),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(
                          color: Colors.white,
                        ),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Profile'),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ProfileScreen()));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Logout'),
                          onTap: () async =>
                              await FirebaseAuth.instance.signOut(),
                        )
                      ],
                    ),
                  )))),
      body: _buildUsersList(),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder(
        stream: fireStore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Err'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                if (auth.currentUser!.email != data['email']) {
                  return ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  sentToEmail: data['email'],
                                  sentToId: data.id,
                                ))),
                    title: Text('Name: ${snapshot.data!.docs[index]['name']}'),
                  );
                }
              });
        });
  }
}
