import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pawlorie/SignupPage.dart'; 

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
      // Handle login logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logging in...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 22, 21, 86)
          ),
          
        ),
         Container(
          margin: const EdgeInsets.all(50),
          child: Image.asset('lib/assets/login.png',
                width: 300,)
        ),
        Padding(
          padding: const EdgeInsets.only(top: 320.0),
          child: Container(
            decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50)
            ),
            color: Color.fromARGB(255, 222, 152, 32),
            ),
            height: double.infinity,
            width: double.infinity,
            child: Center(
                    child: 
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top:30),
                          child: Text("Welcome Back!",
                          style:
                            TextStyle(
                              color:Color.fromARGB(255, 22, 21, 86),
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Rubik'
                              
                            )),
                        ),
                        Text("Login to your Account",
                        style:
                          TextStyle(
                            color: Colors.white,
                            fontSize: 18
                          ),),
                          buildForm()
                      ],
                    ),
                    ),
            
          ),
        ),
       

        ],
      ),
    );
  }


  Widget buildForm(){
  return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.mail),
                prefixIconColor: Color.fromARGB(255, 22, 21, 86),
                hintText: 'Email',
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 22, 21, 86),
                  fontSize: 15),
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
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                prefixIconColor: Color.fromARGB(255, 22, 21, 86),
                hintText: 'Password',
                hintStyle: TextStyle(
                  color:Color.fromARGB(255, 22, 21, 86),
                  fontSize: 15),
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
            ElevatedButton(
              onPressed: _login,
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 22, 21, 86),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text('Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        )
                    ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Text('New here?',
                      style: TextStyle(
                        color: Colors.white
                      ),),
                  TextButton(
                   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage())), // anonymous route
                    child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text('Sign up',
                            style: TextStyle(
                              color: Color.fromARGB(255, 22, 21, 86),
                              fontWeight: FontWeight.bold
                            )
                        ),
                                    ),
                  ),
              
                ],),
            )






          ],
        ),
      ),
    );
  }
}

