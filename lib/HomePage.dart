import 'dart:async';
import 'dart:core'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlorie/AddDogPage.dart';
import 'package:pawlorie/CalTrackerPage.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:pawlorie/components/DogCard.dart';
import 'package:intl/intl.dart'; 
import 'package:pawlorie/user_auth/firebase_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class HomePage extends StatefulWidget {
  final String username;

  HomePage({this.username = ''});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DateTime _currentDate;
  late Timer _timer;
  late String _currentUserDocumentId;

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
    
    _firebaseService.getCurrentUserDocumentId().then((documentId)
    {
      setState(() {
        _currentUserDocumentId = documentId ?? '';
        print("Current user document ID: $_currentUserDocumentId");
      });
    });
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
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 22, 21, 86),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                          '${widget.username}!',
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
              margin: const EdgeInsets.only(top: 150),
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
                    StreamBuilder<List<Dog>>(
                      stream: _firebaseService.getDogs(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text('No dogs found'));
                        }

                        final dogs = snapshot.data!.where((dog) => dog.userId == _currentUserDocumentId).toList();

                        if (dogs.isEmpty) {
                          return Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: Image.asset(
                                      'lib/assets/no_dog.png',  //picture of dog sleeping
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "You haven't added any dogs yet. Add one now!",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.rubik(
                                            fontSize: 22,
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
                                  username: widget.username, 
                                  imageURL: dog.imageUrl,),
                              ),
                            );
                          },
                        );
                      }
                    ),
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
                  MaterialPageRoute(builder: (context) => AddDogPage(userId:_currentUserDocumentId)),
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

class Dog {
  final String id;
  final String name;
  final String breed;
  final String userId;
  final String imageUrl; // Add imageUrl field

  Dog({
    required this.id,
    required this.name,
    required this.breed,
    required this.userId,
    required this.imageUrl, // Initialize the imageUrl field
  });

  factory Dog.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Dog(
      id: doc.id,
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      userId: data['userId'] ?? '',
      imageUrl: data['imageUrl'] ?? '', // Assign the value of imageUrl from Firestore
    );
  }
}

