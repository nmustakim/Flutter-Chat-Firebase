import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/providers/app_provider.dart';
import 'package:flutter_chat_firebase/screens/auth_gate.dart';
import 'package:flutter_chat_firebase/screens/splash.dart';
import 'package:flutter_chat_firebase/screens/start_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AppProvider()),

  ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade400)),
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
