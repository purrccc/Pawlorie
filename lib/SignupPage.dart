import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/LoginPage.dart';
import 'package:pawlorie/components/SignupForm.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/user_auth/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // Initialize the FirebaseAuthService instance
  final FirebaseAuthService _authService = FirebaseAuthService();
  // Key to identify the form and validate it
  final _formKey = GlobalKey<FormState>();
  // Controllers for the text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();

  // Function to handle sign-up logic
  void _signUp() async {
    // Validate the form fields
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String name = _nameController.text;

      // Call the sign up method in FirebaseAuthService
      User? user =
          await _authService.signUpWithEmailAndPassword(email, password, name);

      if (user != null) {
        // If user is created, navigate to LoginPage
        print("User created");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Print error message if sign-up fails
        print("Sign-up failed");
      }
    }
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is removed
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColor.darkBlue,
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Text(
                                "New here?",
                                style: GoogleFonts.rubik(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.darkBlue,
                                ),
                              ),
                            ),
                            Text(
                              "Sign up to get started",
                              style: GoogleFonts.ubuntu(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SignUpForm(
                              formKey: _formKey,
                              emailController: _emailController,
                              nameController: _nameController,
                              passwordController: _passwordController,
                              retypePasswordController:
                                  _retypePasswordController,
                              signUpCallback: _signUp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
