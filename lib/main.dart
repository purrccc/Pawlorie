import 'package:flutter/material.dart';
import 'package:pawlorie/LoginPage.dart'; 
import 'package:pawlorie/SignupPage.dart'; 
import 'package:pawlorie/HomePage.dart'; 
import 'package:pawlorie/AddDogPage.dart'; 
import 'package:pawlorie/CalSuggestionPage.dart';
import 'package:pawlorie/CalTrackerPage.dart';
import 'package:google_fonts/google_fonts.dart';

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
      home: CalTrackerPage(),
    );
  }
}

