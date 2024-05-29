// HomePage

import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pawlorie/constants/colors.dart';

// Import pages
import 'package:pawlorie/AddDogPage.dart';
import 'package:pawlorie/CalTrackerPage.dart';
import 'package:pawlorie/LoginPage.dart';
import 'package:pawlorie/components/DogCard.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime currentDate;
  late Timer timer;
  late String _currentUserDocumentId;
  String _username = '';

  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();

    // Initialize current date and time
    currentDate = DateTime.now();
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) {
      setState(() {
        currentDate = DateTime.now();
      });
    });

    // Fetch current user document id and username
    firebaseService.getCurrentUserDocumentId().then((documentId) {
      setState(() {
        _currentUserDocumentId = documentId ?? '';
        print("Current user document ID: $_currentUserDocumentId");
      });

      // Fetch the username once we have the user document ID
      firebaseService.getCurrentUsername(documentId).then((username) {
        setState(() {
          _username = username ?? '';
        });
      });
    });
  }

  // signout function
  final FirebaseAuth auth = FirebaseAuth.instance;
  signOut() async {
    await auth.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = DateFormat('MMMM');
    String formattedMonth = formatter.format(currentDate);

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
                        Container(    // Logout button
                          margin: const EdgeInsets.only(right: 20.0, top: 30.0),
                          child: IconButton(
                            icon:
                                Icon(
                                  Icons.logout_rounded, 
                                  color: Colors.white),
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
                      "Today is $formattedMonth ${currentDate.day}, ${currentDate.year}",
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
                    // Listen for changes in the list of dogs
                    StreamBuilder<List<Dog>>(
                        stream: firebaseService.getDogs(),
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

                          // Filter dogs list to show only the current user's dogs
                          final dogs = snapshot.data!
                              .where(
                                  (dog) => dog.userId == _currentUserDocumentId)
                              .toList();

                          // If user has no dogs, display message and image suggesting adding a dog
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
                                // Message suggesting user to add a dog
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

                          // If user has dogs, display them using a ListView
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

   // Retrieves the current user's document ID
  Future<String?> getCurrentUserDocumentId() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _db.collection('users').doc(user.uid).get();
        return snapshot.id;     // Return the document ID
      }
    } catch (error) {
      print("Error getting current user document ID: $error");
    }
    return null;
  }

  // Retrieves the username associated with a given document ID
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
  // Retrieves a stream of dogs from the 'dogs' collection
  Stream<List<Dog>> getDogs() {
    return _db.collection('dogs').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Dog.fromFirestore(doc)).toList());
  }
  // Signs the current user out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print("Error signing out: $error");
    }
  }
}

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

  // Factory method to create a Dog object from a Firestore 
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
