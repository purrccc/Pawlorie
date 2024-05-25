import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pawlorie/LoginPage.dart';
import 'package:pawlorie/SignupPage.dart';
import 'package:pawlorie/HomePage.dart';
import 'package:pawlorie/AddDogPage.dart';
import 'package:pawlorie/CalSuggestionPage.dart';
import 'package:pawlorie/CalSuggestUpdatePage.dart';
import 'package:pawlorie/InitialHomePage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: LoginPage(),
    );
  }
}
