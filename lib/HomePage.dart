import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/AddDogPage.dart';
import 'package:pawlorie/CalTrackerPage.dart';
import 'package:pawlorie/LoginPage.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/components/DogCard.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/user_auth/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _currentDate;
  late Timer _timer;
  late String _currentUserDocumentId;
  String _username = '';

  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {
        _currentDate = DateTime.now();
      });
    });

    _firebaseService.getCurrentUserDocumentId().then((documentId) {
      setState(() {
        _currentUserDocumentId = documentId ?? '';
        print("Current user document ID: $_currentUserDocumentId");
      });

      // Fetch the username once we have the user document ID
      _firebaseService.getCurrentUsername(documentId).then((username) {
        setState(() {
          _username = username ?? '';
        });
      });
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  // signout function
  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('MMMM');
    String formattedMonth = formatter.format(_currentDate);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 21, 86),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 20.0, top: 30.0),
                          child: IconButton(
                            icon:
                                Icon(Icons.logout_rounded, color: Colors.white),
                            onPressed: signOut,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hello, ',
                          style: GoogleFonts.ubuntu(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '$_username!',
                          style: GoogleFonts.rubik(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: AppColor.yellowGold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Today is $formattedMonth ${_currentDate.day}, ${_currentDate.year}",
                      style: GoogleFonts.ubuntu(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              margin: const EdgeInsets.only(top: 200),
              child: Text(
                'Your dogs',
                style: GoogleFonts.rubik(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: AppColor.darkBlue,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 580,
              margin: const EdgeInsets.only(top: 200),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // stream builder for realtime updates from database
                    StreamBuilder<List<Dog>>(
                        stream: _firebaseService.getDogs(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No dogs found'));
                          }

                          final dogs = snapshot.data!
                              .where(
                                  (dog) => dog.userId == _currentUserDocumentId)
                              .toList();

                          // default display if user has not added any dog
                          if (dogs.isEmpty) {
                            return Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(35.0),
                                    child: Image.asset(
                                      'lib/assets/no_dog.png',
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "You haven't added any dogs yet. Add one now!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.darkBlue,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }

                          // display dogs of user in home page
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dogs.length,
                            itemBuilder: (context, index) {
                              final dog = dogs[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: dogCard(
                                  context,
                                  dog.name,
                                  dog.breed,
                                  dog.imageUrl,
                                  CalTrackerPage(
                                    petId: dog.id,
                                    petName: dog.name,
                                    username: _username,
                                    imageURL: dog.imageUrl,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 31, 104, 239),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddDogPage(userId: _currentUserDocumentId)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 202, 27),
                  padding: const EdgeInsets.all(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Color.fromARGB(255, 22, 21, 86),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Dog',
                      style: GoogleFonts.ubuntu(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 22, 21, 86),
                      ),
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

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // extract id of current user from database to show only dogs added by user
  Future<String?> getCurrentUserDocumentId() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _db.collection('users').doc(user.uid).get();
        return snapshot.id;
      }
    } catch (error) {
      print("Error getting current user document ID: $error");
    }
    return null;
  }

  
  Future<String?> getCurrentUsername(String? documentId) async {
    if (documentId != null) {
      try {
        DocumentSnapshot snapshot =
            await _db.collection('users').doc(documentId).get();
        return snapshot['name'] as String?;
      } catch (error) {
        print("Error getting username: $error");
      }
    }
    return null;
  }


  Stream<List<Dog>> getDogs() {
    return _db.collection('dogs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Dog.fromFirestore(doc)).toList());
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print("Error signing out: $error");
    }
  }
}

// create dog class to store info to be fetched from database

class Dog {
  final String id;
  final String name;
  final String breed;
  final String userId;
  final String imageUrl;

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.userId,
    required this.imageUrl,
  });

  factory Dog.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Dog(
      id: doc.id,
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
