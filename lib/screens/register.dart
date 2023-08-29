import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import 'login.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String name = '';
  String userName = '';
  TextEditingController dateController = TextEditingController();
  bool isObscure = true;


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF160062),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  _buildInputField('Name', 'Enter name here', TextInputType.text, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    } else if (value.length > 25 || value.length < 2) {
                      return 'Name is invalid';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildInputField('Username', 'Enter username here', TextInputType.text, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required';
                    } else if (value.length > 12 || value.length < 2) {
                      return 'Username is invalid';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildInputField('Email', 'Please enter your email', TextInputType.emailAddress, (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Email is invalid';
                    }
                    return null;
                  }),
                  const SizedBox(height: 16),
                  _buildInputFieldWithToggle('Password', 'Please enter your password', (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    } else if (!RegExp(r'^.{8,}$').hasMatch(value)) {
                      return 'At least 8 characters needed';
                    }
                    return null;
                  }),

                  const SizedBox(height: 32),
                  _buildSignUpButton(),
                  const SizedBox(height: 16),
                  _buildSignInText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextInputType keyboardType, String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 7),
        TextFormField(
          maxLines: 1,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.fromLTRB(13, 10, 0, 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          validator: validator,
          onSaved: (value) {
            if (label == 'Name') {
              name = value ?? '';
            } else if (label == 'Username') {
              userName = value ?? '';
            } else if (label == 'Email') {
              email = value ?? '';
            }
          },
        ),
      ],
    );
  }

  Widget _buildInputFieldWithToggle(String label, String hint, String? Function(String?) validator) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 7),
        TextFormField(
          maxLines: 1,
          obscureText: Provider.of<AppProvider>(context).isObscure,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(13, 10, 0, 12),
            hintText: hint,
            suffixIcon: InkWell(
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
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
          ),
          validator: validator,
          onSaved: (value) {
            password = value ?? '';
          },
        ),
      ],
    );
  }


  Widget _buildSignUpButton() {
    final userProvider = Provider.of<AppProvider>(context);
    return SizedBox(
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF160062),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        onPressed: () async{
          if (_loginFormKey.currentState!.validate()) {
            _loginFormKey.currentState!.save();
           await userProvider.signUp(email, password,name,userName, context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(child: Text('Sign Up failed')),
              ),
            );
          }
        },
        child:  Center(child:userProvider.isLoading ? Container(margin:const EdgeInsets.all(9),child: const CircularProgressIndicator(color: Colors.white,)): const Text('Sign Up')),
      ),
    );
  }

  Widget _buildSignInText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: TextStyle(
            fontFamily: GoogleFonts.manrope().fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF999EA1),
          ),
        ),
        const SizedBox(width: 9),
        InkWell(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginForm())),

          child: Text(
            'Sign In',
            style: TextStyle(
              fontFamily: GoogleFonts.manrope().fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

