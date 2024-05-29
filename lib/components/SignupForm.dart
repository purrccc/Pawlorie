import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/Loginpage.dart'; // Adjust this import based on your file structure

class SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController retypePasswordController;
  final VoidCallback signUpCallback;

  SignUpForm({
    required this.formKey,
    required this.emailController,
    required this.nameController,
    required this.passwordController,
    required this.retypePasswordController,
    required this.signUpCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                prefixIconColor: Color.fromARGB(255, 22, 21, 86),
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 22, 21, 86),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(color: Color.fromARGB(255, 22, 21, 86)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                prefixIconColor: Color.fromARGB(255, 22, 21, 86),
                hintText: 'Name',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 22, 21, 86),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
               inputFormatters: [LengthLimitingTextInputFormatter(10)],
              style: TextStyle(color: Color.fromARGB(255, 22, 21, 86)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Color.fromARGB(255, 22, 21, 86),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 22, 21, 86),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(color: Color.fromARGB(255, 22, 21, 86)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: retypePasswordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                prefixIconColor: Color.fromARGB(255, 22, 21, 86),
                hintText: 'Retype Password',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 22, 21, 86),
                  fontSize: 15,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              style: TextStyle(color: Color.fromARGB(255, 22, 21, 86)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please retype your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Call the sign-up callback
                  signUpCallback();

                  // Show the SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signed in successfully!'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 22, 21, 86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Sign Up',
                  style: GoogleFonts.ubuntu(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: GoogleFonts.ubuntu(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Login',
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 22, 21, 86),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
