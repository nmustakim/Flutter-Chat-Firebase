import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/screens/login.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
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
    Provider.of<AppProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AppProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Chatbase',
            style: TextStyle(fontSize: 36),
          ),
          backgroundColor: Colors.indigo,
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
                                await FirebaseAuth.instance.signOut().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginForm()), (route) => false)),
                          )
                        ],
                      ),
                    )))),
        backgroundColor: Colors.indigo,
        body: Column(
          children: [
            const Expanded(child: SizedBox()),
            Container(
              height: 580,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))),
              child: ListView.builder(
                  itemCount: userProvider.users.length,
                  itemBuilder: (context, index) {
                    final user = userProvider.users[index];
                    if (auth.currentUser!.email != user.email) {
                      return ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    sentToEmail: user.name,
                                    sentToId: user.id))),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.image ?? ''),
                        ),
                      );
                    }
                  }),
            ),
          ],
        ));
  }
}
