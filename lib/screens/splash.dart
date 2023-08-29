import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'auth_gate.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    toHome();
  }

  void toHome() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) =>  const AuthGate()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A4C93), Color(0xFFAC4D92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cosmic chat bubble SVG
              SvgPicture.asset(
                'assets/images/bubbles.svg',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'ChatBase',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Chatting app using Firebase',
                style: TextStyle(
                  color: Colors.black,
                  fontSize:12 ,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}