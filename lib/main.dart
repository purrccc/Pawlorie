import 'package:flutter/material.dart';
import 'package:pawlorie/LoginPage.dart'; 
import 'package:pawlorie/SignupPage.dart'; 
import 'package:pawlorie/HomePage.dart'; 
import 'package:pawlorie/AddDogPage.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawlorie',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

