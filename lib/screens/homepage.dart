import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/screens/login.dart';
import 'package:flutter_chat_firebase/screens/profile.dart';
import 'package:flutter_chat_firebase/screens/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'chat_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  final _auth = FirebaseAuth.instance;

  void fetchUsers() async {
    final appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.fetchUsers();
    await appProvider.fetchCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AppProvider>(context);

    final users = userProvider.users
        .where((user) => user.id != _auth.currentUser?.uid)
        .toList();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          elevation: 0,
          centerTitle: true,
          title: const Column(
            children: [
              Text(
                'Chatbase',
                style: TextStyle(fontSize: 36),
              ),
              Text(
                'Chatting app using Firebase',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
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
                      child:userProvider.fetchingUser
                          ? const Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(fontSize: 20, color: Colors.indigo),
                          ))
                          :userProvider.users.isNotEmpty?  Column(
                        children: [
                          const SizedBox(height: 10),
                          CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                NetworkImage(userProvider.currentUser?.image??''),
                          ),
                          SingleSection(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileScreen(
                                              name: userProvider
                                                  .currentUser?.name??'',
                                              email: userProvider
                                                  .currentUser?.email??"",
                                              image: userProvider
                                                  .currentUser?.image??"",
                                              username: userProvider
                                                  .currentUser?.username??"")));
                                },
                                child: const ListTile(
                                    title: Text("Profile"),
                                    trailing:
                                        Icon(Icons.person_outline_rounded)),
                              ),
                            ],
                          ),
                          const Divider(),
                          const ListTile(
                            title: Text('About'),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                          const Divider(),
                          const ListTile(
                            title: Text('Help & Support'),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('Logout'),
                            trailing: const Icon(Icons.logout),
                            onTap: () async => await FirebaseAuth.instance
                                .signOut()
                                .then((value) => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginForm()),
                                    (route) => false)),
                          ),
                        ],
                      ):Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Something went wrong'),
                            IconButton(
                                onPressed: () => fetchUsers(),
                                icon: const Icon(Icons.refresh))
                          ],
                        ),
                      )
                    )))),
        backgroundColor: Colors.indigo,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                height: 580,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                child: userProvider.fetchingUser
                    ? const Center(
                        child: Text(
                        'Loading...',
                        style: TextStyle(fontSize: 20, color: Colors.indigo),
                      ))
                    : userProvider.users.isNotEmpty
                        ? ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];

                              return ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                              image: user.image,
                                              name: user.name,
                                              username: user.username,
                                              id: user.id,
                                              email: user.email,
                                            ))),
                                title: Text(user.name),
                                subtitle: Text(user.email),
                                leading: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfileScreen(
                                                name: user.name,
                                                email: user.email,
                                                image: user.image,
                                                username: user.username)));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(user.image),
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Something went wrong'),
                                IconButton(
                                    onPressed: () => fetchUsers(),
                                    icon: const Icon(Icons.refresh))
                              ],
                            ),
                          )),
          ],
        )));
  }
}
