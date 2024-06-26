// Login Form Component
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import pages
import 'package:pawlorie/SignupPage.dart';


class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback loginCallback;

  LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.loginCallback,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left:20.0,
        right: 20.0,
        top: 20.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(                  // Input field for email
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
                    borderRadius: BorderRadius.circular(10),
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
              TextFormField(                      // Input field for password
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

              ElevatedButton(         // Login Button
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // Call the login callback
                    loginCallback();
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
                    'Login',
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Sign up link
              Container(
                margin: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New here?',
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
                          builder: (context) => SignUpPage(),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Sign up',
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
      ),
    );
  }
}
