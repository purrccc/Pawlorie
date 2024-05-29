import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlorie/HomePage.dart';
import 'package:pawlorie/components/LoginForm.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawlorie/user_auth/firebase_auth_services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  bool _isLoggedIn = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserWithUsername? userWithUsername =
          await _auth.signInWithEmailAndPassword(email, password);

      if (userWithUsername != null && userWithUsername.user != null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Success",
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              content: Text(
                "Logged in successfully!",
                style: GoogleFonts.rubik(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        setState(() {
          _isLoggedIn = true;
        });
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Row(
                children: [
                  Text(
                    "Login Failed",
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              content: Text(
                "Please double-check your email and password and try again.",
                style: GoogleFonts.rubik(
                  fontSize: 16,
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColor.darkBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.rubik(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        print("Failed to log in");
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      // If the user is logged in, navigate to the HomePage
      return HomePage();
    } else {
      // If the user is not logged in, display the login UI
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(color: AppColor.darkBlue),
            ),
            Container(
              margin: const EdgeInsets.all(50),
              child: Image.asset(
                'lib/assets/login.png',
                width: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 320.0),
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          child: Text(
                            "Welcome Back!",
                            style: GoogleFonts.rubik(
                              fontSize: 45,
                              fontWeight: FontWeight.w600,
                              color: AppColor.darkBlue,
                            ),
                          ),
                        ),
                        Text(
                          "Login to your Account",
                          style: GoogleFonts.ubuntu(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        LoginForm(
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          loginCallback: _login,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
