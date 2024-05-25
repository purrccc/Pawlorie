import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlorie/components/LoginForm.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in...')),
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
            decoration:
                const BoxDecoration(color: AppColor.darkBlue),
          ),
          Container(
              margin: const EdgeInsets.all(50),
              child: Image.asset(
                'lib/assets/login.png',
                width: 300,
              )),
          Padding(
            padding: const EdgeInsets.only(top: 320.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50)),
                color: AppColor.yellowGold,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Text(
                        "Welcome Back!",
                        style: GoogleFonts.rubik(
                            fontSize: 45,
                            fontWeight: FontWeight.w600,
                            color: AppColor.darkBlue),
                      ),
                    ),
                    Text("Login to your Account",
                        style: GoogleFonts.ubuntu(
                            fontSize: 20, 
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                    LoginForm(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        loginCallback: _login,
                      )
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
 
