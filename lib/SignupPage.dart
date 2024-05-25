import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlorie/LoginPage.dart';
import 'package:pawlorie/components/SignupForm.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/constants/colors.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      // Handle sign-up logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signing up...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.darkBlue
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50, left: 70),
            child: Image.asset(
              'lib/assets/signup.png',
              width: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 250.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: AppColor.yellowGold,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 30),
                      child: Text(
                        "New here?",
                        style: GoogleFonts.rubik(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: AppColor.darkBlue),
                      ),
                    ),
                    Text("Sign up to get started",
                        style: GoogleFonts.ubuntu(
                            fontSize: 18, color: Colors.white)),
                    SignUpForm(
                        formKey: _formKey,
                        emailController: _emailController,
                        nameController: _nameController,
                        passwordController: _passwordController,
                        retypePasswordController: _retypePasswordController,
                        signUpCallback: _signUp,
                      ),
                                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}