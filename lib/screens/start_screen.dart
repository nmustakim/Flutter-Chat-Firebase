import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/screens/auth_gate.dart';
import 'package:flutter_chat_firebase/screens/login.dart';
import 'package:flutter_svg/svg.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'ChatBase',
              style: TextStyle(fontSize: 36),
            ),

            Text(
              'Chatting app with Firebase',
              style: TextStyle(fontSize: 12,color: Colors.yellow),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  alignment: Alignment.topRight,
                  child: SvgPicture.asset('assets/images/ci2.svg')),
              Container(
                  alignment: Alignment.topLeft,
                  child: SvgPicture.asset('assets/images/ci1.svg')),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Stay connected with your friends and family',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 45,
              ),
              Row(
                children: [
                  SvgPicture.asset('assets/images/shield.svg'),
                  const SizedBox(width: 9,),
                  const Text(
                    'Secure, private messaging',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  )
                ],
              ),
              const SizedBox(height: 42.5,),
              SizedBox(height: 50,width: 314,child: ElevatedButton(onPressed:()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginForm(),)),style: ElevatedButton.styleFrom(shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),backgroundColor: Colors.white),child: const Text('Get started',style: TextStyle(color: Colors.black,fontSize: 16),),),)
            ],
          ),
        ),
      ),
    );
  }
}
