import 'package:flutter/material.dart';
import 'package:flutter_chat_firebase/screens/register.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isChecked = true;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _loginFormKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 27, right: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 58),
                    width: 144,
                    height: 139,
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(11)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 34, 34, 52),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontFamily: GoogleFonts.gochiHand().fontFamily,
                            fontSize: 44.56,
                            fontWeight: FontWeight.w400,
                            color: const Color(0XFFB6158A)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  'Hi, Welcome Back! 👋',
                  style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: const Color(0XFF000000)),
                ),
                Text(
                  'Hello again, you’ve been missed!',
                  style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0XFF999EA1)),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text(
                  'Email',
                  style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0XFF00004D)),
                ),
                const SizedBox(
                  height: 7,
                ),
                SizedBox(
                  height: 41,
                  child: Center(
                    child: TextFormField(


                      maxLines: 1,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Please Enter Your Email',
                          contentPadding:
                          const EdgeInsets.fromLTRB(13, 10, 0, 12),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),borderSide: const BorderSide(color: Color(0XFFC6C6C6))),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0XFFC6C6C6)))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email)) {
                          return 'Email is invalid';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String? newValue) {
                        email = newValue ?? '';
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Password',
                  style: TextStyle(
                      fontFamily: GoogleFonts.manrope().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0XFF00004D)),
                ),
                const SizedBox(
                  height: 7,
                ),
                SizedBox(
                  height: 41,
                  child: Center(
                    child: TextFormField(
                      maxLines: 1,
                      obscureText: Provider.of<AppProvider>(context).isObscure,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.fromLTRB(13, 10, 0, 12),
                          labelText: 'Please Enter Your Password',
                          suffixIcon:InkWell(
                            onTap: () {
                              Provider.of<AppProvider>(context,listen: false).setObscure();

                            },
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: SvgPicture.asset( Provider.of<AppProvider>(context).isObscure?
                              'assets/images/hide.svg':'assets/images/show.svg',
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),

                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5),borderSide: const BorderSide(color: Color(0XFFC6C6C6))),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0XFFC6C6C6)))

                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (!RegExp(r'^.{8,}$').hasMatch(password)) {
                          return 'At least 8 char needed';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (String? newValue) {
                        password = newValue ?? '';
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Text('Forgot Password',
                    style: TextStyle(
                        fontFamily: GoogleFonts.manrope().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0XFFFB344F))),
                const SizedBox(
                  height: 55,
                ),
                SizedBox(
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: const Color(0XFF351A96)),
                        onPressed: () async{
                          _loginFormKey.currentState!.save();
                          _loginFormKey.currentState!.validate();
                          if (_loginFormKey.currentState!.validate() == true) {
                           await userProvider.signIn(email, password, context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                    Center(child: Text('Login failed'))));
                          }
                        },
                        child:  Center(child: userProvider.isLoading?Container(margin:const EdgeInsets.all(9),child: const CircularProgressIndicator(color: Colors.white,)):const Text('Login')))),
                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account?',
                        style: TextStyle(
                            fontFamily: GoogleFonts.manrope().fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0XFF999EA1))),
                    const SizedBox(
                      width: 9,
                    ),
                    InkWell(
                      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpForm())),
                      child: Text('Sign Up',
                          style: TextStyle(
                              fontFamily: GoogleFonts.manrope().fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0XFF160062))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



